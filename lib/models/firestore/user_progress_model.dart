import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgressModel {
  final String id;
  final String userId;
  final String lessonId;
  final bool isCompleted;
  final double accuracyPercent;
  final int xpEarned;
  final DateTime completedAt;

  const UserProgressModel({
    required this.id,
    required this.userId,
    required this.lessonId,
    required this.isCompleted,
    required this.accuracyPercent,
    required this.xpEarned,
    required this.completedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'lessonId': lessonId,
      'isCompleted': isCompleted,
      'accuracyPercent': accuracyPercent,
      'xpEarned': xpEarned,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }

  factory UserProgressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserProgressModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      lessonId: data['lessonId'] as String? ?? '',
      isCompleted: data['isCompleted'] as bool? ?? false,
      accuracyPercent: (data['accuracyPercent'] as num?)?.toDouble() ?? 0.0,
      xpEarned: data['xpEarned'] as int? ?? 0,
      completedAt: (data['completedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
