import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../firebase_options.dart';
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

  /// Ensures GoogleSignIn instance is initialized once per app session on mobile.
  static Future<void> initialize({
    String? clientId,
    String? serverClientId,
  }) async {
    if (_isInitialized || kIsWeb) return;
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
      // 1. Offline / Dev Fallback when Firebase credentials are not yet configured in firebase_options.dart
      if (!DefaultFirebaseOptions.isConfigured) {
        debugPrint('[GoogleAuthService] Operating in Dev/Offline mode (Firebase placeholder credentials).');
        await Future.delayed(const Duration(milliseconds: 600));
        return const GoogleAuthResult(
          id: 'google_user_demo_01',
          email: 'google.user@tolate.bd',
          displayName: 'গুগল ব্যবহারকারী',
          photoUrl: null,
          isNewUser: false,
        );
      }

      // 2. Web flow using Firebase Auth Popup
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

      // 3. Android / iOS / Native platforms using google_sign_in
      await initialize();
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
          'Firebase কনসোলে Google Sign-In বা SHA-1 কনফিগারেশন যুক্ত করা প্রয়োজন। আপাতত মোবাইল নম্বর দিয়ে লগইন করতে পারেন।',
        );
      }
      throw AuthError('গুগল সাইন ইন সম্পন্ন করা সম্ভব হয়নি (${e.code.name})।');
    } on FirebaseAuthException catch (e) {
      debugPrint('[GoogleAuthService] FirebaseAuthException: ${e.code} ${e.message}');
      throw AuthError(_mapFirebaseError(e));
    } catch (e) {
      debugPrint('[GoogleAuthService] Unexpected error: $e');
      if (e is AppError) rethrow;
      throw AuthError('গুগল সাইন ইনে সমস্যা হয়েছে। অনুগ্রহ করে মোবাইল নম্বর দিয়ে চেষ্টা করুন।');
    }
  }

  /// Disconnects / signs out Google account session.
  static Future<void> signOut() async {
    try {
      if (!kIsWeb) {
        await GoogleSignIn.instance.signOut();
      }
    } catch (_) {}
  }

  static String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'popup-closed-by-user':
        return 'গুগল লগইন উইন্ডো বন্ধ করা হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';
      case 'popup-blocked':
        return 'ব্রাউজারের পপ-আপ ব্লকার উইন্ডোটি আটকে দিয়েছে। পপ-আপ অনুমোদন করে আবার চেষ্টা করুন।';
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
