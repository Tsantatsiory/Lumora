import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static final FirestoreService instance = FirestoreService._internal();
  FirestoreService._internal();

  FirebaseFirestore get db => FirebaseFirestore.instance;

  // Collection References
  CollectionReference get usersCollection => db.collection('users');
  CollectionReference get lessonsCollection => db.collection('lessons');
  CollectionReference get userProgressCollection => db.collection('user_progress');
  CollectionReference get leaderboardsCollection => db.collection('leaderboards');
  CollectionReference get notificationsCollection => db.collection('notifications');
}
