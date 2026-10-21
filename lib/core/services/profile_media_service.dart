import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../errors/app_error.dart';
import 'firebase_service.dart';

/// Profile & Cover Photo Upload and Management Service
class ProfileMediaService {
  /// Upload profile picture to Firebase Storage: users/{userId}/profile.jpg
  static Future<String> uploadProfilePhoto({
    required String userId,
    required Uint8List bytes,
    String mimeType = 'image/jpeg',
  }) async {
    try {
      final storage = FirebaseService.storage ?? FirebaseStorage.instance;
      final ref = storage.ref().child('users/$userId/profile.jpg');
      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'type': 'profile_picture',
        },
      );

      final uploadTask = await ref.putData(bytes, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      debugPrint('[ProfileMediaService] Profile photo uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('[ProfileMediaService] Profile upload error: $e');
      throw MediaUploadError('প্রোফাইল ছবি আপলোড ব্যর্থ হয়েছে: ${e.toString()}');
    }
  }

  /// Upload cover photo to Firebase Storage: users/{userId}/cover.jpg
  static Future<String> uploadCoverPhoto({
    required String userId,
    required Uint8List bytes,
    String mimeType = 'image/jpeg',
  }) async {
    try {
      final storage = FirebaseService.storage ?? FirebaseStorage.instance;
      final ref = storage.ref().child('users/$userId/cover.jpg');
      final metadata = SettableMetadata(
        contentType: mimeType,
        customMetadata: {
          'uploadedAt': DateTime.now().toIso8601String(),
          'type': 'cover_photo',
        },
      );

      final uploadTask = await ref.putData(bytes, metadata);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      debugPrint('[ProfileMediaService] Cover photo uploaded successfully: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('[ProfileMediaService] Cover upload error: $e');
      throw MediaUploadError('কভার ছবি আপলোড ব্যর্থ হয়েছে: ${e.toString()}');
    }
  }

  /// Delete profile picture from Firebase Storage
  static Future<void> deleteProfilePhoto(String userId) async {
    try {
      final storage = FirebaseService.storage ?? FirebaseStorage.instance;
      final ref = storage.ref().child('users/$userId/profile.jpg');
      await ref.delete();
    } catch (e) {
      debugPrint('[ProfileMediaService] Delete profile photo notice: $e');
    }
  }

  /// Delete cover photo from Firebase Storage
  static Future<void> deleteCoverPhoto(String userId) async {
    try {
      final storage = FirebaseService.storage ?? FirebaseStorage.instance;
      final ref = storage.ref().child('users/$userId/cover.jpg');
      await ref.delete();
    } catch (e) {
      debugPrint('[ProfileMediaService] Delete cover photo notice: $e');
    }
  }

  /// Update user's Firestore document with profile & cover photo URLs
  /// Crucial rule: Only called after Storage upload succeeds!
  static Future<void> updateFirestoreUserPhotos({
    required String userId,
    required String? profilePhotoUrl,
    required String? coverPhotoUrl,
    required bool updateProfile,
    required bool updateCover,
  }) async {
    try {
      final firestore = FirebaseService.firestore ?? FirebaseFirestore.instance;
      final updates = <String, dynamic>{
        'updatedAt': DateTime.now().toIso8601String(),
      };
      if (updateProfile) {
        updates['profilePhotoUrl'] = profilePhotoUrl;
      }
      if (updateCover) {
        updates['coverPhotoUrl'] = coverPhotoUrl;
      }

      await firestore.collection('users').doc(userId).set(
        updates,
        SetOptions(merge: true),
      );
      debugPrint('[ProfileMediaService] Firestore user photos updated successfully.');
    } catch (e) {
      debugPrint('[ProfileMediaService] Firestore update error: $e');
      throw MediaUploadError('ডাটাবেজে ছবির তথ্য সংরক্ষণ ব্যর্থ হয়েছে: ${e.toString()}');
    }
  }
}
