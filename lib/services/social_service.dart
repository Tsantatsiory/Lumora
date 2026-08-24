import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class FriendUser {
  final String uid;
  final String username;
  final String displayName;
  final String avatar;
  final int level;
  final int xp;
  final int streak;
  bool isFollowing;

  FriendUser({
    required this.uid,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.level,
    required this.xp,
    required this.streak,
    this.isFollowing = false,
  });
}

class SocialService extends ChangeNotifier {
  static final SocialService instance = SocialService._internal();
  SocialService._internal();

  final List<FriendUser> _allUsers = [
    FriendUser(
      uid: 'u_sarah',
      username: '@sarah_faith',
      displayName: 'Sarah M.',
      avatar: '👩‍🎓',
      level: 12,
      xp: 4820,
      streak: 54,
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
      isFollowing: false,
    ),
  ];

  List<FriendUser> get following => _allUsers.where((u) => u.isFollowing).toList();
  List<FriendUser> get followers => _allUsers.sublist(0, 5); // Liste simulée des followers
  List<FriendUser> get suggestions => _allUsers.where((u) => !u.isFollowing).toList();

  void toggleFollow(String uid) {
    final user = _allUsers.firstWhere((u) => u.uid == uid, orElse: () => _allUsers.first);
    user.isFollowing = !user.isFollowing;

    // Mise à jour du compteur sur AuthService
    if (user.isFollowing) {
      AuthService.instance.updateFollowingCount(1);
    } else {
      AuthService.instance.updateFollowingCount(-1);
    }

    notifyListeners();
  }
}
