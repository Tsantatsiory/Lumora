import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String username;
  final String displayName;
  final String email;
  final String avatarUrl;
  final String bannerUrl;
  final String bio;
  final int level;
  final int totalXp;
  final int weeklyXp;
  final int streakDays;
  final int energyCount;
  final int maxEnergy;
  final int followersCount;
  final int followingCount;
  final int badgesCount;
  final DateTime? lastActiveAt;
  final DateTime createdAt;

  const UserProfileModel({
    required this.uid,
    required this.username,
    required this.displayName,
    this.email = '',
    this.avatarUrl = 'assets/images/profile_avatar.jpg',
    this.bannerUrl = 'assets/images/profile_banner.jpg',
    this.bio = 'Seeking wisdom daily in Proverbs & Psalms 📖✨',
    this.level = 8,
    this.totalXp = 2480,
    this.weeklyXp = 480,
    this.streakDays = 35,
    this.energyCount = 5,
    this.maxEnergy = 5,
    this.followersCount = 142,
    this.followingCount = 86,
    this.badgesCount = 12,
    this.lastActiveAt,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'username': username,
      'displayName': displayName,
      'email': email,
      'avatarUrl': avatarUrl,
      'bannerUrl': bannerUrl,
      'bio': bio,
      'level': level,
      'totalXp': totalXp,
      'weeklyXp': weeklyXp,
      'streakDays': streakDays,
      'energyCount': energyCount,
      'maxEnergy': maxEnergy,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'badgesCount': badgesCount,
      'lastActiveAt': lastActiveAt != null ? Timestamp.fromDate(lastActiveAt!) : FieldValue.serverTimestamp(),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProfileModel(
      uid: doc.id,
      username: data['username'] as String? ?? '@user',
      displayName: data['displayName'] as String? ?? 'Seeker',
      email: data['email'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String? ?? 'assets/images/profile_avatar.jpg',
      bannerUrl: data['bannerUrl'] as String? ?? 'assets/images/profile_banner.jpg',
      bio: data['bio'] as String? ?? 'Seeking wisdom daily 📖✨',
      level: data['level'] as int? ?? 1,
      totalXp: data['totalXp'] as int? ?? 0,
      weeklyXp: data['weeklyXp'] as int? ?? 0,
      streakDays: data['streakDays'] as int? ?? 1,
      energyCount: data['energyCount'] as int? ?? 5,
      maxEnergy: data['maxEnergy'] as int? ?? 5,
      followersCount: data['followersCount'] as int? ?? 0,
      followingCount: data['followingCount'] as int? ?? 0,
      badgesCount: data['badgesCount'] as int? ?? 0,
      lastActiveAt: (data['lastActiveAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  UserProfileModel copyWith({
    String? username,
    String? displayName,
    String? avatarUrl,
    String? bannerUrl,
    String? bio,
    int? level,
    int? totalXp,
    int? weeklyXp,
    int? streakDays,
    int? energyCount,
    int? followersCount,
    int? followingCount,
    int? badgesCount,
    DateTime? lastActiveAt,
  }) {
    return UserProfileModel(
      uid: uid,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      bio: bio ?? this.bio,
      level: level ?? this.level,
      totalXp: totalXp ?? this.totalXp,
      weeklyXp: weeklyXp ?? this.weeklyXp,
      streakDays: streakDays ?? this.streakDays,
      energyCount: energyCount ?? this.energyCount,
      maxEnergy: maxEnergy,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      badgesCount: badgesCount ?? this.badgesCount,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      createdAt: createdAt,
    );
  }
}
