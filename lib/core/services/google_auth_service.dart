import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../errors/app_error.dart';

/// Structured result of a Google authentication session.
class GoogleAuthResult {
  final User? firebaseUser;
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool isNewUser;

  const GoogleAuthResult({
    this.firebaseUser,
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.isNewUser = false,
  });
}

/// Modular service managing Google Authentication lifecycle and tokens.
class GoogleAuthService {
  static bool _isInitialized = false;

  /// Ensures GoogleSignIn instance is initialized once per app session.
  static Future<void> initialize({
    String? clientId,
    String? serverClientId,
  }) async {
    if (_isInitialized) return;
    try {
      await GoogleSignIn.instance.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('[GoogleAuthService] Initialize notice: $e');
    }
  }

  /// Triggers Google Sign In flow and signs into Firebase Auth.
  static Future<GoogleAuthResult?> signIn() async {
    try {
      await initialize();

      if (kIsWeb) {
        final auth = FirebaseAuth.instance;
        final googleProvider = GoogleAuthProvider();
        final userCredential = await auth.signInWithPopup(googleProvider);
        final user = userCredential.user;
        if (user == null) return null;

        return GoogleAuthResult(
          firebaseUser: user,
          id: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoUrl: user.photoURL,
          isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
        );
      }

      // Android / iOS / Native platforms
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;

      final auth = FirebaseAuth.instance;
      UserCredential userCredential;

      if (idToken != null && idToken.isNotEmpty) {
        final credential = GoogleAuthProvider.credential(idToken: idToken);
        userCredential = await auth.signInWithCredential(credential);
      } else {
        throw const AuthError('গুগল অথেন্টিকেশন টোকেন পাওয়া যায়নি।');
      }

      final user = userCredential.user;
      return GoogleAuthResult(
        firebaseUser: user,
        id: user?.uid ?? account.id,
        email: user?.email ?? account.email,
        displayName: user?.displayName ?? account.displayName,
        photoUrl: user?.photoURL ?? account.photoUrl,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      );
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null; // Graceful user cancellation
      }
      debugPrint('[GoogleAuthService] GoogleSignInException: ${e.code} ${e.description}');
      if (e.code == GoogleSignInExceptionCode.clientConfigurationError ||
          e.code == GoogleSignInExceptionCode.providerConfigurationError) {
        throw const AuthError(
          'Firebase কনসোলে Google Sign-In বা SHA-1 কনফিগারেশন যোগ করা প্রয়োজন। আপাতত মোবাইল নম্বর দিয়ে লগইন করতে পারেন।',
        );
      }
      throw AuthError('গুগল সাইন ইন সম্পন্ন করা সম্ভব হয়নি (${e.code.name})।');
    } on FirebaseAuthException catch (e) {
      debugPrint('[GoogleAuthService] FirebaseAuthException: ${e.code} ${e.message}');
      throw AuthError(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('[GoogleAuthService] Unexpected error: $e');
      if (e is AppError) rethrow;
      throw AuthError('গুগল সাইন ইনে ত্রুটি হয়েছে। অনুগ্রহ করে মোবাইল নম্বর দিয়ে চেষ্টা করুন।');
    }
  }

  /// Disconnects / signs out Google account session.
  static Future<void> signOut() async {
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  static String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'এই ইমেইল দিয়ে অন্য মাধ্যমে আগেই অ্যাকাউন্ট খোলা হয়েছে।';
      case 'invalid-credential':
        return 'অননুমোদিত গুগল ক্রেডেনশিয়াল। অনুগ্রহ করে আবার চেষ্টা করুন।';
      case 'user-disabled':
        return 'আপনার অ্যাকাউন্টটি স্থগিত করা হয়েছে। এডমিনের সাথে যোগাযোগ করুন।';
      case 'network-request-failed':
        return 'ইন্টারনেট সংযোগ চেক করে পুনরায় চেষ্টা করুন।';
      default:
        return e.message ?? 'গুগল সাইন ইন ব্যর্থ হয়েছে।';
    }
  }
}

