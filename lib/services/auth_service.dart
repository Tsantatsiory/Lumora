import 'package:flutter/foundation.dart';
import '../models/firestore/user_profile_model.dart';
import 'firebase_initializer.dart';
import 'local_account_store.dart';
import 'user_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final UserService _userService = UserService();
  final LocalAccountStore _localStore = LocalAccountStore();

  UserProfileModel? _currentUser;
  List<UserProfileModel> _profiles = [];
  bool _isLoggedIn = false;
  String? lastError;

  UserProfileModel get currentUser => _currentUser ?? _defaultDemoUser;
  bool get isLoggedIn => _isLoggedIn;
  List<UserProfileModel> get profiles => List.unmodifiable(_profiles);

  Future<void> restoreSession() async {
    await _seedTestAccounts();
    await _refreshProfiles();
    _currentUser = await _localStore.restoreSession();
    _isLoggedIn = _currentUser != null;
    notifyListeners();
  }

  Future<void> _refreshProfiles() async {
    _profiles = await _localStore.readProfiles();
  }

  Future<void> _seedTestAccounts() async {
    final seeds = [
      (name: 'Sarah M.', username: '@sarah_faith', email: 'sarah@lumora.app', password: 'demo123', xp: 4820, streak: 54),
      (name: 'David K.', username: '@david_psalms', email: 'david@lumora.app', password: 'demo123', xp: 3950, streak: 42),
      (name: 'Esther L.', username: '@esther_grace', email: 'esther@lumora.app', password: 'demo123', xp: 3410, streak: 38),
    ];
    final accounts = await _localStore.readAccounts();
    for (final seed in seeds) {
      if (accounts.containsKey(seed.email)) continue;
      await _localStore.saveAccount(
        UserProfileModel(
          uid: 'demo_${seed.username.substring(1)}',
          username: seed.username,
          displayName: seed.name,
          email: seed.email,
          bio: 'Compte de démonstration Lumora — une foi qui grandit chaque jour. ✨',
          level: (seed.xp / 300).floor() + 1,
          totalXp: seed.xp,
          weeklyXp: seed.xp ~/ 10,
          streakDays: seed.streak,
          followersCount: 0,
          followingCount: 0,
          badgesCount: 3,
          createdAt: DateTime(2026, 1, 15),
        ),
        seed.password,
      );
    }
  }

  static final UserProfileModel _defaultDemoUser = UserProfileModel(
    uid: 'demo_user_01',
    username: '@username_demo',
    displayName: 'username_demo',
    email: 'user@lumora.app',
    avatarUrl: 'assets/images/profile_avatar.jpg',
    bannerUrl: 'assets/images/profile_banner.jpg',
    bio: 'Seeking wisdom daily in Proverbs & Psalms 📖✨',
    level: 8,
    totalXp: 2480,
    weeklyXp: 480,
    streakDays: 35,
    energyCount: 5,
    maxEnergy: 5,
    followersCount: 142,
    followingCount: 86,
    badgesCount: 12,
    createdAt: DateTime(2026, 1, 15),
  );

  // Connexion
  Future<bool> login(String email, String password) async {
    final profile = await _localStore.login(email, password);
    if (profile == null) {
      lastError = 'Adresse email ou mot de passe incorrect.';
      return false;
    }
    _currentUser = profile;
    _isLoggedIn = true;
    lastError = null;
    await _localStore.saveSession(profile.email);
    await _refreshProfiles();
    notifyListeners();
    return true;
  }

  // Inscription
  Future<bool> register({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    final normalized = username.trim().replaceFirst(RegExp(r'^@+'), '');
    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(normalized)) {
      lastError = 'Identifiant invalide : 3 à 20 lettres, chiffres ou _.';
      return false;
    }
    if (await _localStore.login(email, password) != null || (await _localStore.readAccounts()).containsKey(email.toLowerCase())) {
      lastError = 'Cette adresse email est déjà utilisée.';
      return false;
    }
    final cleanUsername = '@$normalized';
    if (await _localStore.usernameExists(cleanUsername)) {
      lastError = 'Cet identifiant est déjà utilisé.';
      return false;
    }
    final newUser = UserProfileModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: cleanUsername,
      displayName: fullName,
      email: email,
      avatarUrl: 'assets/images/profile_avatar.jpg',
      bannerUrl: 'assets/images/profile_banner.jpg',
      level: 1,
      totalXp: 25,
      weeklyXp: 25,
      streakDays: 1,
      followersCount: 0,
      followingCount: 0,
      badgesCount: 1,
      createdAt: DateTime.now(),
    );

    _currentUser = newUser;
    _isLoggedIn = true;
    lastError = null;
    await _localStore.saveAccount(newUser, password);
    await _localStore.saveSession(newUser.email);
    await _refreshProfiles();
    notifyListeners();

    // Persistance Firestore si initialisé
    try {
      await _userService.createUserProfile(newUser);
    } catch (_) {}

    return true;
  }

  // Connexion Rapide Invité / Démo
  Future<bool> loginAsDemo() => login('sarah@lumora.app', 'demo123');

  // Déconnexion
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    lastError = null;
    _localStore.saveSession(null);
    notifyListeners();
  }

  // Ajouter de l'XP
  void addXp(int xpGained) {
    if (_currentUser == null) return;
    final newTotalXp = _currentUser!.totalXp + xpGained;
    final newWeeklyXp = _currentUser!.weeklyXp + xpGained;
    final newLevel = (newTotalXp / 300).floor() + 1;

    _currentUser = _currentUser!.copyWith(
      totalXp: newTotalXp,
      weeklyXp: newWeeklyXp,
      level: newLevel,
    );
    notifyListeners();
    _localStore.saveProfile(_currentUser!);
    _refreshProfiles();

    if (FirebaseInitializer.isInitialized) {
      _userService.addXp(_currentUser!.uid, xpGained).catchError((_) {});
    }
  }

  // Incrémenter / Décrémenter les followers / following
  void updateFollowersCount(int delta) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      followersCount: (_currentUser!.followersCount + delta).clamp(0, 999999),
    );
    notifyListeners();
    _localStore.saveProfile(_currentUser!);
    _refreshProfiles();
  }

  Future<void> updateFollowingCount(int delta) async {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      followingCount: (_currentUser!.followingCount + delta).clamp(0, 999999),
    );
    final index = _profiles.indexWhere((profile) => profile.uid == _currentUser!.uid);
    if (index != -1) _profiles[index] = _currentUser!;
    notifyListeners();
    await _localStore.saveProfile(_currentUser!);
  }

  Future<void> updateFollowersForUser(String uid, int delta) async {
    final index = _profiles.indexWhere((profile) => profile.uid == uid);
    if (index == -1) return;
    final updated = _profiles[index].copyWith(
      followersCount: (_profiles[index].followersCount + delta).clamp(0, 999999),
    );
    _profiles[index] = updated;
    await _localStore.saveProfile(updated);
    if (_currentUser?.uid == uid) _currentUser = updated;
    notifyListeners();
  }

  // Mettre à jour le profil (bio, nom, photo)
  void updateProfile({String? displayName, String? bio, String? avatarUrl, String? bannerUrl}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      displayName: displayName,
      bio: bio,
      avatarUrl: avatarUrl,
      bannerUrl: bannerUrl,
    );
    notifyListeners();
    _localStore.saveProfile(_currentUser!);

    if (FirebaseInitializer.isInitialized) {
      _userService.updateProfileDetails(
        _currentUser!.uid,
        displayName: displayName,
        bio: bio,
        avatarUrl: avatarUrl,
        bannerUrl: bannerUrl,
      ).catchError((_) {});
    }
  }

  int get usernameChangeDaysRemaining {
    final changedAt = _currentUser?.usernameChangedAt;
    if (changedAt == null) return 0;
    final remaining = 30 - DateTime.now().difference(changedAt).inDays;
    return remaining > 0 ? remaining : 0;
  }

  String? updateUsername(String username) {
    final normalized = username.trim().replaceFirst(RegExp(r'^@+'), '');
    if (!RegExp(r'^[a-zA-Z0-9_]{3,20}$').hasMatch(normalized)) {
      return 'Utilisez 3 à 20 caractères : lettres, chiffres ou _. ';
    }
    if (usernameChangeDaysRemaining > 0) {
      return 'Votre identifiant pourra être modifié dans $usernameChangeDaysRemaining jours.';
    }
    if (_currentUser == null) return 'Connectez-vous pour modifier votre identifiant.';
    _currentUser = _currentUser!.copyWith(
      username: '@$normalized',
      usernameChangedAt: DateTime.now(),
    );
    notifyListeners();
    _localStore.saveProfile(_currentUser!);
    if (FirebaseInitializer.isInitialized) {
      _userService.updateProfileDetails(
        _currentUser!.uid,
        username: _currentUser!.username,
        usernameChangedAt: _currentUser!.usernameChangedAt,
      ).catchError((_) {});
    }
    return null;
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
