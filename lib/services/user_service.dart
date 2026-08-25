import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore/user_profile_model.dart';
import 'firestore_service.dart';

class UserService {
  final FirestoreService _firestore = FirestoreService.instance;

  // Stream du profil utilisateur en temps réel
  Stream<UserProfileModel?> streamUserProfile(String uid) {
    return _firestore.usersCollection.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfileModel.fromFirestore(doc);
    });
  }

  // Obtenir le profil une seule fois
  Future<UserProfileModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.usersCollection.doc(uid).get();
      if (!doc.exists) return null;
      return UserProfileModel.fromFirestore(doc);
    } catch (e) {
      return null;
    }
  }

  // Créer ou initialiser un nouveau profil utilisateur
  Future<void> createUserProfile(UserProfileModel user) async {
    await _firestore.usersCollection.doc(user.uid).set(
          user.toFirestore(),
          SetOptions(merge: true),
        );
  }

  // Ajouter de l'XP et mettre à jour le niveau automatiquement
  Future<void> addXp(String uid, int xpToAdd) async {
    final userRef = _firestore.usersCollection.doc(uid);
    await _firestore.db.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      if (!snapshot.exists) return;

      final currentTotalXp = (snapshot.data() as Map<String, dynamic>)['totalXp'] as int? ?? 0;
      final currentWeeklyXp = (snapshot.data() as Map<String, dynamic>)['weeklyXp'] as int? ?? 0;
      final newTotalXp = currentTotalXp + xpToAdd;
      final newWeeklyXp = currentWeeklyXp + xpToAdd;
      final calculatedLevel = (newTotalXp / 300).floor() + 1;

      transaction.update(userRef, {
        'totalXp': newTotalXp,
        'weeklyXp': newWeeklyXp,
        'level': calculatedLevel,
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Mettre à jour la série de jours (Streak)
  Future<void> updateStreak(String uid) async {
    final userRef = _firestore.usersCollection.doc(uid);
    await userRef.update({
      'streakDays': FieldValue.increment(1),
      'lastActiveAt': FieldValue.serverTimestamp(),
    });
  }

  // Mettre à jour les informations du profil (bio, nom, photo)
  Future<void> updateProfileDetails(String uid, {String? displayName, String? bio, String? avatarUrl, String? bannerUrl, String? username, DateTime? usernameChangedAt}) async {
    final Map<String, dynamic> updates = {};
    if (displayName != null) updates['displayName'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (avatarUrl != null) updates['avatarUrl'] = avatarUrl;
    if (bannerUrl != null) updates['bannerUrl'] = bannerUrl;
    if (username != null) updates['username'] = username;
    if (usernameChangedAt != null) updates['usernameChangedAt'] = Timestamp.fromDate(usernameChangedAt);

    if (updates.isNotEmpty) {
      await _firestore.usersCollection.doc(uid).update(updates);
    }
  }

  // Système d'amis : Suivre un utilisateur
  Future<void> followUser(String currentUid, String targetUid) async {
    final batch = _firestore.db.batch();
    // Incrémenter followingCount pour l'utilisateur actuel
    batch.update(_firestore.usersCollection.doc(currentUid), {
      'followingCount': FieldValue.increment(1),
    });
    // Incrémenter followersCount pour l'utilisateur cible
    batch.update(_firestore.usersCollection.doc(targetUid), {
      'followersCount': FieldValue.increment(1),
    });
    await batch.commit();
  }
}
