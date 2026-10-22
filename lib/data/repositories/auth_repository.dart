import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/property_enums.dart';
import '../../core/errors/app_error.dart';
import '../../core/services/firebase_service.dart';
import '../../core/services/google_auth_service.dart';
import '../../core/validation/phone_validator.dart';
import '../models/user_model.dart';

/// Authentication and User Session Repository using Firebase Phone Auth.
class AuthRepository extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isPhoneLoading = false;
  String? _pendingPhoneNumber;
  String? _verificationId;
  int? _resendToken;
  DateTime? _lastOtpSentTime;
  int _otpAttempts = 0;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading || _isGoogleLoading || _isPhoneLoading;
  bool get isGoogleLoading => _isGoogleLoading;
  bool get isPhoneLoading => _isPhoneLoading;
  String? get pendingPhoneNumber => _pendingPhoneNumber;
  String? get verificationId => _verificationId;

  bool get canResendOtp {
    if (_lastOtpSentTime == null) return true;
    final diff = DateTime.now().difference(_lastOtpSentTime!).inSeconds;
    return diff >= AppConstants.otpResendCooldownSeconds;
  }

  int get resendCooldownRemainingSeconds {
    if (_lastOtpSentTime == null) return 0;
    final diff = DateTime.now().difference(_lastOtpSentTime!).inSeconds;
    final remain = AppConstants.otpResendCooldownSeconds - diff;
    return remain > 0 ? remain : 0;
  }

  /// Restores session on app startup
  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('auth_user_id');
      if (userId != null) {
        final displayName = prefs.getString('auth_display_name');
        final email = prefs.getString('auth_email');
        final phone = prefs.getString('auth_phone');
        final isVerified = prefs.getBool('auth_phone_verified') ?? false;
        final authProvider = prefs.getString('auth_provider') ?? 'phone';
        final profilePhoto = prefs.getString('auth_profile_photo');
        final coverPhoto = prefs.getString('auth_cover_photo');
        final bio = prefs.getString('auth_bio');
        final adminRoleStr = prefs.getString('auth_admin_role');

        _currentUser = UserModel(
          id: userId,
          displayName: displayName,
          email: email,
          phoneNumber: phone,
          isPhoneVerified: isVerified,
          authProvider: authProvider,
          profilePhotoUrl: profilePhoto,
          coverPhotoUrl: coverPhoto,
          bio: bio,
          roles: const [UserRole.tenant],
          adminRole: adminRoleStr != null
              ? AdminRole.values.firstWhere(
                  (r) => r.name == adminRoleStr,
                  orElse: () => AdminRole.listingModerator,
                )
              : null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (_) {
      // Clean fallback
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Request OTP to Bangladesh phone number via Firebase Phone Auth.
  Future<void> requestOtp(String rawPhone) async {
    if (!PhoneValidator.isValidBdPhone(rawPhone)) {
      throw const ValidationError('অনুগ্রহ করে সঠিক বাংলাদেশি মোবাইল নম্বর দিন।');
    }

    final normalized = PhoneValidator.normalizeBdPhone(rawPhone)!;

    if (!canResendOtp) {
      throw ValidationError(
        'দয়া করে ${resendCooldownRemainingSeconds} সেকেন্ড অপেক্ষা করে আবার চেষ্টা করুন।',
      );
    }

    _isPhoneLoading = true;
    notifyListeners();

    if (!FirebaseService.isConfigured) {
      _pendingPhoneNumber = normalized;
      _lastOtpSentTime = DateTime.now();
      _otpAttempts = 0;
      _verificationId = 'dev_session_$normalized';
      _isPhoneLoading = false;
      notifyListeners();
      return;
    }

    final completer = Completer<void>();

    try {
      final auth = FirebaseService.auth ?? FirebaseAuth.instance;
      _pendingPhoneNumber = normalized;
      _lastOtpSentTime = DateTime.now();
      _otpAttempts = 0;

      await auth.verifyPhoneNumber(
        phoneNumber: normalized,
        timeout: const Duration(seconds: 60),
        forceResendingToken: _resendToken,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await auth.signInWithCredential(credential);
            if (userCredential.user != null) {
              await _handleSuccessfulSignIn(userCredential.user!);
            }
          } catch (e) {
            debugPrint('[AuthRepository] Auto-verification sign-in notice: $e');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          _isPhoneLoading = false;
          notifyListeners();
          final errorMsg = _mapFirebasePhoneAuthError(e);
          if (!completer.isCompleted) {
            completer.completeError(AuthError(errorMsg));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          _isPhoneLoading = false;
          notifyListeners();
          if (!completer.isCompleted) {
            completer.complete();
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );

      return await completer.future;
    } catch (e) {
      _isPhoneLoading = false;
      notifyListeners();
      if (e is AppError) rethrow;
      throw AuthError('ওটিপি পাঠাতে সমস্যা হয়েছে: ${e.toString()}');
    } finally {
      _isPhoneLoading = false;
      notifyListeners();
    }
  }

  /// Verify OTP code using Firebase Phone Auth and establish user session.
  Future<UserModel> verifyOtp(String enteredOtp) async {
    if (_pendingPhoneNumber == null) {
      throw const AuthError('কোনো ফোন নম্বর যাচাইয়ের জন্য জমা দেওয়া হয়নি।');
    }

    if (enteredOtp.trim().length != AppConstants.otpLength) {
      throw const ValidationError('৬ ডিজিটের সঠিক ওটিপি (OTP) কোড দিন।');
    }

    if (_verificationId == null) {
      throw const AuthError('ভেরিফিকেশন সেশন পাওয়া যায়নি। অনুগ্রহ করে পুনরায় ওটিপি পাঠান।');
    }

    if (_otpAttempts >= AppConstants.maxOtpAttempts) {
      throw const AuthError('সর্বোচ্চ চেষ্টার সীমা অতিক্রম হয়েছে। নতুন ওটিপি অনুরোধ করুন।');
    }

    _otpAttempts++;
    _isPhoneLoading = true;
    notifyListeners();

    try {
      if (!FirebaseService.isConfigured) {
        if (enteredOtp.trim() != '123456') {
          throw const AuthError('ভুল ওটিপি কোড। ডেমো ওটিপি কোড ১২৩৪৫৬ দিন।');
        }

        final prefs = await SharedPreferences.getInstance();
        final uid = 'user_${_pendingPhoneNumber!.replaceAll('+', '')}';

        final user = UserModel(
          id: uid,
          displayName: prefs.getString('auth_display_name') ?? 'ব্যবহারকারী',
          phoneNumber: _pendingPhoneNumber,
          isPhoneVerified: true,
          authProvider: 'phone',
          roles: const [UserRole.tenant],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        _currentUser = user;
        await prefs.setString('auth_user_id', user.id);
        if (user.phoneNumber != null) {
          await prefs.setString('auth_phone', user.phoneNumber!);
        }
        await prefs.setBool('auth_phone_verified', true);
        await prefs.setString('auth_provider', 'phone');

        _pendingPhoneNumber = null;
        _verificationId = null;
        return user;
      }

      final auth = FirebaseService.auth ?? FirebaseAuth.instance;
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: enteredOtp.trim(),
      );

      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw const AuthError('ব্যবহারকারী যাচাইকরণ ব্যর্থ হয়েছে।');
      }

      final user = await _handleSuccessfulSignIn(firebaseUser);
      _pendingPhoneNumber = null;
      _verificationId = null;
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthError(_mapFirebasePhoneAuthError(e));
    } finally {
      _isPhoneLoading = false;
      notifyListeners();
    }
  }

  /// Internal session establishment and Firestore user syncing.
  Future<UserModel> _handleSuccessfulSignIn(User firebaseUser) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = firebaseUser.uid;
    final phone = firebaseUser.phoneNumber ?? _pendingPhoneNumber;

    UserModel? user;
    final firestore = FirebaseService.firestore;
    if (firestore != null && FirebaseService.isConfigured) {
      try {
        final doc = await firestore
            .collection('users')
            .doc(uid)
            .get()
            .timeout(const Duration(seconds: 3));
        if (doc.exists && doc.data() != null) {
          user = UserModel.fromJson(doc.data()!);
        }
      } catch (e) {
        debugPrint('[AuthRepository] Firestore user fetch notice: $e');
      }
    }

    user ??= UserModel(
      id: uid,
      displayName: prefs.getString('auth_display_name') ?? 'ইউজার',
      phoneNumber: phone,
      isPhoneVerified: true,
      roles: const [UserRole.tenant],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _currentUser = user;

    await prefs.setString('auth_user_id', user.id);
    if (user.phoneNumber != null) {
      await prefs.setString('auth_phone', user.phoneNumber!);
    }
    await prefs.setBool('auth_phone_verified', true);

    if (firestore != null && FirebaseService.isConfigured) {
      try {
        await firestore
            .collection('users')
            .doc(user.id)
            .set(user.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('[AuthRepository] Firestore user sync notice: $e');
      }
    }

    notifyListeners();
    return user;
  }

  String _mapFirebasePhoneAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-verification-code':
        return 'ভুল ওটিপি কোড। অনুগ্রহ করে সঠিক কোড দিন।';
      case 'session-expired':
        return 'ওটিপির মেয়াদ শেষ হয়ে গেছে। পুনরায় কোড পাঠানোর চেষ্টা করুন।';
      case 'invalid-phone-number':
        return 'মোবাইল নম্বরটি সঠিক ফরম্যাটে নেই।';
      case 'too-many-requests':
        return 'অতিরিক্ত চেষ্টা করা হয়েছে। অনুগ্রহ করে কিছুক্ষণ অপেক্ষা করুন।';
      case 'quota-exceeded':
        return 'এসএমএস কোটা শেষ হয়ে গেছে। অনুগ্রহ করে পরে চেষ্টা করুন।';
      case 'network-request-failed':
        return 'ইন্টারনেট সংযোগ চেক করুন এবং পুনরায় চেষ্টা করুন।';
      default:
        return e.message ?? 'মোবাইল ভেরিফিকেশন ব্যর্থ হয়েছে।';
    }
  }

  /// Update user profile details.
  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? profilePhotoUrl,
    String? coverPhotoUrl,
    List<UserRole>? roles,
    UserPrivacySettings? privacySettings,
  }) async {
    if (_currentUser == null) throw const AuthError('লগইন করা নেই।');

    _isLoading = true;
    notifyListeners();

    try {
      final updated = _currentUser!.copyWith(
        displayName: displayName ?? _currentUser!.displayName,
        bio: bio ?? _currentUser!.bio,
        profilePhotoUrl: profilePhotoUrl ?? _currentUser!.profilePhotoUrl,
        coverPhotoUrl: coverPhotoUrl ?? _currentUser!.coverPhotoUrl,
        roles: roles ?? _currentUser!.roles,
        privacySettings: privacySettings ?? _currentUser!.privacySettings,
        updatedAt: DateTime.now(),
      );

      final prefs = await SharedPreferences.getInstance();
      if (updated.displayName != null) {
        await prefs.setString('auth_display_name', updated.displayName!);
      }
      if (updated.profilePhotoUrl != null) {
        await prefs.setString('auth_profile_photo', updated.profilePhotoUrl!);
      }
      if (updated.coverPhotoUrl != null) {
        await prefs.setString('auth_cover_photo', updated.coverPhotoUrl!);
      }
      if (updated.bio != null) {
        await prefs.setString('auth_bio', updated.bio!);
      }

      // Sync updated profile to Firestore
      try {
        final firestore = FirebaseService.firestore;
        if (firestore != null && FirebaseService.isConfigured) {
          await firestore.collection('users').doc(updated.id).set(updated.toJson());
        }
      } catch (e) {
        debugPrint('[AuthRepository] Firestore profile update sync: $e');
      }

      _currentUser = updated;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Protected Admin Login.
  /// Rule: Super Admin / Admin roles are NEVER self-assignable by public users.
  Future<bool> adminLogin({
    required String adminEmail,
    required String adminPassword,
    required String securityKey,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Secure backend authorization simulation
      if (adminEmail == 'admin@tolate.bd' &&
          adminPassword == 'ToLateSecure2026!' &&
          securityKey == 'BD_ADMIN_AUTHORIZED') {
        _currentUser = UserModel(
          id: 'admin_sys_001',
          displayName: 'সুপার এডমিন (System)',
          phoneNumber: '+8801700000000',
          isPhoneVerified: true,
          adminRole: AdminRole.superAdmin,
          roles: const [UserRole.owner, UserRole.tenant],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_user_id', _currentUser!.id);
        await prefs.setString('auth_admin_role', AdminRole.superAdmin.name);
        notifyListeners();
        return true;
      } else {
        throw const AuthError('ভুল এডমিন ক্রেডেনশিয়াল বা অননুমোদিত এক্সেস।');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in or Sign up using Google Account.
  Future<UserModel?> signInWithGoogle() async {
    _isGoogleLoading = true;
    notifyListeners();

    try {
      final result = await GoogleAuthService.signIn();
      if (result == null) {
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      final uid = result.id;
      final firestore = FirebaseService.firestore;
      UserModel? user;

      if (firestore != null && FirebaseService.isConfigured) {
        try {
          final doc = await firestore
              .collection('users')
              .doc(uid)
              .get()
              .timeout(const Duration(seconds: 3));
          if (doc.exists && doc.data() != null) {
            user = UserModel.fromJson(doc.data()!);
          }
        } catch (e) {
          debugPrint('[AuthRepository] Firestore Google user lookup notice: $e');
        }
      }

      user ??= UserModel(
        id: uid,
        displayName: result.displayName ?? 'ইউজার',
        email: result.email,
        profilePhotoUrl: result.photoUrl,
        authProvider: 'google',
        isPhoneVerified: false,
        roles: const [UserRole.tenant],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _currentUser = user;

      await prefs.setString('auth_user_id', user.id);
      if (user.email != null) {
        await prefs.setString('auth_email', user.email!);
      }
      if (user.displayName != null) {
        await prefs.setString('auth_display_name', user.displayName!);
      }
      if (user.profilePhotoUrl != null) {
        await prefs.setString('auth_profile_photo', user.profilePhotoUrl!);
      }
      await prefs.setString('auth_provider', 'google');

      if (firestore != null && FirebaseService.isConfigured) {
        try {
          await firestore
              .collection('users')
              .doc(user.id)
              .set(user.toJson(), SetOptions(merge: true))
              .timeout(const Duration(seconds: 3));
        } catch (e) {
          debugPrint('[AuthRepository] Firestore Google user sync notice: $e');
        }
      }

      notifyListeners();
      return user;
    } finally {
      _isGoogleLoading = false;
      notifyListeners();
    }
  }

  /// Logout from active session.
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_admin_role');
    await prefs.remove('auth_email');
    await prefs.remove('auth_phone');
    await prefs.remove('auth_provider');

    try {
      await GoogleAuthService.signOut();
      final auth = FirebaseService.auth ?? FirebaseAuth.instance;
      await auth.signOut();
    } catch (_) {}

    notifyListeners();
  }
}

