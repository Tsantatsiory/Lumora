import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore/user_progress_model.dart';
import 'firestore_service.dart';

class ProgressFirestoreService {
  final FirestoreService _firestore = FirestoreService.instance;

  // Enregistrer ou mettre à jour la complétion d'une leçon
  Future<void> recordLessonCompletion({
    required String userId,
    required String lessonId,
    required double accuracyPercent,
    required int xpEarned,
  }) async {
    final docId = '${userId}_$lessonId';
    final progress = UserProgressModel(
      id: docId,
      userId: userId,
      lessonId: lessonId,
      isCompleted: true,
      accuracyPercent: accuracyPercent,
      xpEarned: xpEarned,
      completedAt: DateTime.now(),
    );

    await _firestore.userProgressCollection.doc(docId).set(
          progress.toFirestore(),
          SetOptions(merge: true),
        );
  }

  // Stream de toutes les leçons terminées par un utilisateur
  Stream<List<UserProgressModel>> streamUserProgress(String userId) {
    return _firestore.userProgressCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserProgressModel.fromFirestore(doc)).toList();
    });
  }

  // Vérifier si une leçon a déjà été complétée
  Future<bool> isLessonCompleted(String userId, String lessonId) async {
    final docId = '${userId}_$lessonId';
    final doc = await _firestore.userProgressCollection.doc(docId).get();
    if (!doc.exists) return false;
    return (doc.data() as Map<String, dynamic>)['isCompleted'] as bool? ?? false;
  }
}
