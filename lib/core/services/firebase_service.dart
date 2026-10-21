import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../../firebase_options.dart';

/// Centralized Firebase Service.
/// Manages Firebase initialization and cloud connectors for Auth, Firestore, and Storage.
class FirebaseService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;
  static bool get isConfigured => DefaultFirebaseOptions.isConfigured;

  /// Safe initialization with graceful fallback if credentials are placeholders
  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
      debugPrint('[FirebaseService] Firebase connected successfully (Project: ${DefaultFirebaseOptions.currentPlatform.projectId}).');
    } catch (e) {
      debugPrint('[FirebaseService] Firebase initialization notice: $e');
      debugPrint('[FirebaseService] App is operating with in-memory persistence & offline fallback until live Firebase credentials are provided.');
    }
  }

  /// Firebase Authentication Instance
  static FirebaseAuth? get auth {
    if (!_isInitialized) return null;
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  /// Cloud Firestore Database Instance
  static FirebaseFirestore? get firestore {
    if (!_isInitialized) return null;
    try {
      return FirebaseFirestore.instance;
    } catch (_) {
      return null;
    }
  }

  /// Firebase Cloud Storage Instance
  static FirebaseStorage? get storage {
    if (!_isInitialized) return null;
    try {
      return FirebaseStorage.instance;
    } catch (_) {
      return null;
    }
  }
}

