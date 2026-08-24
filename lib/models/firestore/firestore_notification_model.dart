import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreNotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final String category; // 'retention' or 'gamification'
  final String iconName;
  final bool isRead;
  final int? targetNavIndex;
  final DateTime createdAt;

  const FirestoreNotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.category,
    this.iconName = 'notifications',
    this.isRead = false,
    this.targetNavIndex,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'message': message,
      'category': category,
      'iconName': iconName,
      'isRead': isRead,
      'targetNavIndex': targetNavIndex,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FirestoreNotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FirestoreNotificationModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      category: data['category'] as String? ?? 'retention',
      iconName: data['iconName'] as String? ?? 'notifications',
      isRead: data['isRead'] as bool? ?? false,
      targetNavIndex: data['targetNavIndex'] as int?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
