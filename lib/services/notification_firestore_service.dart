import '../models/firestore/firestore_notification_model.dart';
import 'firestore_service.dart';

class NotificationFirestoreService {
  final FirestoreService _firestore = FirestoreService.instance;

  // Stream des notifications d'un utilisateur triées par date
  Stream<List<FirestoreNotificationModel>> streamUserNotifications(String userId) {
    return _firestore.notificationsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => FirestoreNotificationModel.fromFirestore(doc)).toList();
    });
  }

  // Marquer une notification comme lue
  Future<void> markAsRead(String notificationId) async {
    await _firestore.notificationsCollection.doc(notificationId).update({'isRead': true});
  }

  // Tout marquer comme lu pour un utilisateur
  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _firestore.notificationsCollection
        .where('userId', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.db.batch();
    for (final doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  // Envoyer une notification (ex: rappel de streak, dépassement, etc.)
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String message,
    required String category,
    String iconName = 'notifications',
    int? targetNavIndex,
  }) async {
    final docRef = _firestore.notificationsCollection.doc();
    final notif = FirestoreNotificationModel(
      id: docRef.id,
      userId: userId,
      title: title,
      message: message,
      category: category,
      iconName: iconName,
      targetNavIndex: targetNavIndex,
      createdAt: DateTime.now(),
    );

    await docRef.set(notif.toFirestore());
  }
}
