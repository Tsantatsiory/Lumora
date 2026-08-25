import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Tente d'initialiser Firebase avec la plateforme courante
      await Firebase.initializeApp();
      _isInitialized = true;
      if (kDebugMode) {
        print('Firebase Cloud Firestore initialisé avec succès !');
      }
    } catch (e) {
      // En mode de développement local sans google-services.json configuré,
      // l'app continue de fonctionner en mode local résilient sans planter.
      if (kDebugMode) {
        print('Firebase non lié au projet distant pour le moment : utilisation du mode local résilient.');
      }
    }
  }
}
