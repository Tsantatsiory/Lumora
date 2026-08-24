import '../models/firestore/user_profile_model.dart';
import 'firestore_service.dart';

class LeaderboardFirestoreService {
  final FirestoreService _firestore = FirestoreService.instance;

  // Stream du Top 10 des utilisateurs trié par XP hebdomadaire (Weekly)
  Stream<List<UserProfileModel>> streamWeeklyLeaderboard({int limit = 10}) {
    return _firestore.usersCollection
        .orderBy('weeklyXp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserProfileModel.fromFirestore(doc)).toList();
    });
  }

  // Stream du Top 10 global (All-Time)
  Stream<List<UserProfileModel>> streamAllTimeLeaderboard({int limit = 10}) {
    return _firestore.usersCollection
        .orderBy('totalXp', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => UserProfileModel.fromFirestore(doc)).toList();
    });
  }

  // Obtenir le rang d'un utilisateur
  Future<int> getUserRank(String uid, {bool weekly = true}) async {
    final field = weekly ? 'weeklyXp' : 'totalXp';
    final userDoc = await _firestore.usersCollection.doc(uid).get();
    if (!userDoc.exists) return 1;

    final userXp = (userDoc.data() as Map<String, dynamic>)[field] as int? ?? 0;

    final higherUsersQuery = await _firestore.usersCollection
        .where(field, isGreaterThan: userXp)
        .count()
        .get();

    return (higherUsersQuery.count ?? 0) + 1;
  }
}
