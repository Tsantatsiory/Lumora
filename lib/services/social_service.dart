import 'package:flutter/foundation.dart';
import 'auth_service.dart';
import 'local_account_store.dart';

class FriendUser {
  final String uid;
  final String username;
  final String displayName;
  final String avatar;
  final int level;
  final int xp;
  final int streak;
  final String bio;
  int followersCount;
  final int followingCount;
  bool isFollowing;

  FriendUser({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.streak,
    required this.bio,
    required this.followersCount,
    required this.followingCount,
    this.isFollowing = false,
  });
}

class SocialService extends ChangeNotifier {
  static final SocialService instance = SocialService._internal();
  SocialService._internal();
  final LocalAccountStore _store = LocalAccountStore();

  final List<FriendUser> _allUsers = [
    FriendUser(
      uid: 'u_sarah',
      username: '@sarah_faith',
      displayName: 'Sarah M.',
      avatar: '👩‍🎓',
      level: 12,
      xp: 4820,
      streak: 54,
      bio: 'Apprendre à vivre la foi avec joie, un verset à la fois. ✨',
      followersCount: 318,
      followingCount: 97,
      isFollowing: true,
    ),
    FriendUser(
      uid: 'u_david',
      username: '@david_psalms',
      displayName: 'David K.',
      avatar: '🧑‍💼',
      level: 11,
      xp: 3950,
      streak: 42,
      bio: 'Les Psaumes sont ma force au quotidien. 📖',
      followersCount: 204,
      followingCount: 76,
      isFollowing: true,
    ),
    FriendUser(
      uid: 'u_esther',
      username: '@esther_grace',
      displayName: 'Esther L.',
      avatar: '👩‍🎨',
      level: 10,
      xp: 3410,
      streak: 38,
      bio: 'Grâce, créativité et reconnaissance chaque jour. 🎨',
      followersCount: 176,
      followingCount: 63,
      isFollowing: true,
    ),
    FriendUser(
      uid: 'u_samuel',
      username: '@samuel_seeker',
      displayName: 'Samuel B.',
      avatar: '👨‍🚀',
      level: 9,
      xp: 2890,
      streak: 29,
      bio: 'En quête de sagesse et de paix.',
      followersCount: 139,
      followingCount: 54,
      isFollowing: false,
    ),
    FriendUser(
      uid: 'u_rachel',
      username: '@rachel_light',
      displayName: 'Rachel P.',
      avatar: '👩‍🔬',
      level: 8,
      xp: 2310,
      streak: 21,
      bio: 'La lumière se partage mieux ensemble. 💡',
      followersCount: 121,
      followingCount: 48,
      isFollowing: true,
    ),
    FriendUser(
      uid: 'u_joshua',
      username: '@joshua_valiant',
      displayName: 'Joshua N.',
      avatar: '👨‍🏫',
      level: 7,
      xp: 1980,
      streak: 18,
      bio: 'Courage et fidélité pour chaque défi.',
      followersCount: 95,
      followingCount: 42,
      isFollowing: false,
    ),
    FriendUser(
      uid: 'u_miriam',
      username: '@miriam_song',
      displayName: 'Miriam T.',
      avatar: '👩‍⚕️',
      level: 7,
      xp: 1750,
      streak: 15,
      bio: 'Chanter la bonté de Dieu, chaque matin. 🎵',
      followersCount: 82,
      followingCount: 36,
      isFollowing: false,
    ),
    FriendUser(
      uid: 'u_daniel',
      username: '@daniel_wisdom',
      displayName: 'Daniel V.',
      avatar: '👨‍🌾',
      level: 6,
      xp: 1520,
      streak: 12,
      bio: 'Grandir dans la sagesse et la patience.',
      followersCount: 74,
      followingCount: 31,
      isFollowing: false,
    ),
    FriendUser(
      uid: 'u_hannah',
      username: '@hannah_prayer',
      displayName: 'Hannah G.',
      avatar: '👩‍🍳',
      level: 6,
      xp: 1400,
      streak: 9,
      bio: 'La prière ouvre toujours un chemin. 🙏',
      followersCount: 61,
      followingCount: 28,
      isFollowing: false,
    ),
  ];

  final Map<String, Set<String>> _followingByUser = {};

  Future<void> initialize() async {
    _followingByUser
      ..clear()
      ..addAll(await _store.readFollowing());
    notifyListeners();
  }

  String get _activeUid => AuthService.instance.currentUser.uid;
  Set<String> get _followingIds => _followingByUser.putIfAbsent(_activeUid, () => <String>{});
  Set<String> get _followerIds => _followingByUser.entries
      .where((entry) => entry.value.contains(_activeUid))
      .map((entry) => entry.key)
      .toSet();

  List<FriendUser> get _directoryUsers {
    final profiles = AuthService.instance.profiles;
    if (profiles.isEmpty) return _allUsers;
    return profiles.where((profile) => profile.uid != _activeUid).map(_fromProfile).toList();
  }

  FriendUser _fromProfile(profile) => FriendUser(
        uid: profile.uid,
        username: profile.username,
        displayName: profile.displayName,
        avatar: _avatarFor(profile.username),
        level: profile.level,
        xp: profile.totalXp,
        streak: profile.streakDays,
        bio: profile.bio,
        followersCount: profile.followersCount,
        followingCount: profile.followingCount,
        isFollowing: _followingIds.contains(profile.uid),
      );

  String _avatarFor(String username) {
    if (username.contains('sarah')) return '👩‍🎓';
    if (username.contains('david')) return '🧑‍💼';
    if (username.contains('esther')) return '👩‍🎨';
    return '🧑‍💻';
  }

  List<FriendUser> get following => _directoryUsers.where((u) => _followingIds.contains(u.uid)).toList();
  List<FriendUser> get followers => _directoryUsers.where((u) => _followerIds.contains(u.uid)).toList();
  List<FriendUser> get suggestions => _directoryUsers.where((u) => !_followingIds.contains(u.uid)).toList();

  bool isFollowing(String uid) => _followingIds.contains(uid);
  List<FriendUser> get allUsers => List.unmodifiable(_directoryUsers);

  FriendUser? findById(String uid) {
    for (final user in _directoryUsers) {
      if (user.uid == uid) return user;
    }
    return null;
  }

  Future<bool?> toggleFollow(String uid) async {
    final user = findById(uid);
    if (user == null) return null;
    final following = !isFollowing(uid);
    user.isFollowing = following;

    // Mise à jour du compteur sur AuthService
    if (following) {
      _followingIds.add(uid);
      await AuthService.instance.updateFollowingCount(1);
      await AuthService.instance.updateFollowersForUser(uid, 1);
    } else {
      _followingIds.remove(uid);
      await AuthService.instance.updateFollowingCount(-1);
      await AuthService.instance.updateFollowersForUser(uid, -1);
    }

    await _store.saveFollowing(_followingByUser);
    notifyListeners();
    return following;
  }
}
