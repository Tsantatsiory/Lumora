import 'package:flutter/foundation.dart';
import '../models/firestore/user_profile_model.dart';
import 'firebase_initializer.dart';
import 'user_service.dart';

class AuthService extends ChangeNotifier {
  static final AuthService instance = AuthService._internal();
  AuthService._internal();

  final UserService _userService = UserService();

  UserProfileModel? _currentUser;
  bool _isLoggedIn = true; // Démarre connecté avec le compte démo ou le compte actif

  UserProfileModel get currentUser => _currentUser ?? _defaultDemoUser;
  bool get isLoggedIn => _isLoggedIn;

  static final UserProfileModel _defaultDemoUser = UserProfileModel(
    uid: 'demo_tsanta_01',
    username: '@tsanta_tsiory',
    displayName: 'Tsanta Tsiory',
    email: 'tsanta@lumora.app',
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
    // Simulation / Connexion Firestore
    _currentUser = UserProfileModel(
      uid: 'user_${email.hashCode.abs()}',
      username: '@${email.split('@').first}',
      displayName: email.split('@').first.capitalize(),
      email: email,
      avatarUrl: 'assets/images/profile_avatar.jpg',
      bannerUrl: 'assets/images/profile_banner.jpg',
      level: 1,
      totalXp: 50,
      weeklyXp: 50,
      streakDays: 1,
      followersCount: 0,
      followingCount: 0,
      badgesCount: 1,
      createdAt: DateTime.now(),
    );
    _isLoggedIn = true;
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
    final cleanUsername = username.startsWith('@') ? username : '@$username';
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
    notifyListeners();

    // Persistance Firestore si initialisé
    try {
      await _userService.createUserProfile(newUser);
    } catch (_) {}

    return true;
  }

  // Connexion Rapide Invité / Démo
  void loginAsDemo() {
    _currentUser = _defaultDemoUser;
    _isLoggedIn = true;
    notifyListeners();
  }

  // Déconnexion
  void logout() {
    _currentUser = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  // Ajouter de l'XP
  void addXp(int xpGained) {
    _currentUser ??= _defaultDemoUser;
    final newTotalXp = _currentUser!.totalXp + xpGained;
    final newWeeklyXp = _currentUser!.weeklyXp + xpGained;
    final newLevel = (newTotalXp / 300).floor() + 1;

    _currentUser = _currentUser!.copyWith(
      totalXp: newTotalXp,
      weeklyXp: newWeeklyXp,
      level: newLevel,
    );
    notifyListeners();

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
  }

  void updateFollowingCount(int delta) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      followingCount: (_currentUser!.followingCount + delta).clamp(0, 999999),
    );
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
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
