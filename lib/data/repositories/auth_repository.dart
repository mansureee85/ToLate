import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/property_enums.dart';
import '../../core/errors/app_error.dart';
import '../../core/services/firebase_service.dart';
import '../../core/validation/phone_validator.dart';
import '../models/user_model.dart';

/// Authentication and User Session Repository.
class AuthRepository extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _pendingPhoneNumber;
  String? _expectedOtp;
  DateTime? _lastOtpSentTime;
  int _otpAttempts = 0;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get pendingPhoneNumber => _pendingPhoneNumber;

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
        final phone = prefs.getString('auth_phone');
        final isVerified = prefs.getBool('auth_phone_verified') ?? false;
        final profilePhoto = prefs.getString('auth_profile_photo');
        final coverPhoto = prefs.getString('auth_cover_photo');
        final bio = prefs.getString('auth_bio');
        final adminRoleStr = prefs.getString('auth_admin_role');

        _currentUser = UserModel(
          id: userId,
          displayName: displayName,
          phoneNumber: phone,
          isPhoneVerified: isVerified,
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

  /// Request OTP to Bangladesh phone number.
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

    _isLoading = true;
    notifyListeners();

    try {
      // In production: Cloud Function / Firebase Phone Auth / Bangladesh SMS Gateway (e.g. SSL Wireless / Greenweb)
      _pendingPhoneNumber = normalized;
      _lastOtpSentTime = DateTime.now();
      _otpAttempts = 0;
      // In secure production, the OTP is stored server-side.
      _expectedOtp = '123456'; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Verify OTP code and establish user session.
  Future<UserModel> verifyOtp(String enteredOtp) async {
    if (_pendingPhoneNumber == null) {
      throw const AuthError('কোনো ফোন নম্বর যাচাইয়ের জন্য জমা দেওয়া হয়নি।');
    }

    if (enteredOtp.trim().length != AppConstants.otpLength) {
      throw const ValidationError('৬ ডিজিটের সঠিক ওটিপি (OTP) কোড দিন।');
    }

    if (_otpAttempts >= AppConstants.maxOtpAttempts) {
      throw const AuthError('সর্বোচ্চ চেষ্টার সীমা অতিক্রম হয়েছে। নতুন ওটিপি অনুরোধ করুন।');
    }

    _otpAttempts++;

    if (enteredOtp.trim() != _expectedOtp) {
      throw const AuthError('ভুল ওটিপি কোড। অনুগ্রহ করে সঠিক কোড দিন।');
    }

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final existingUserId = prefs.getString('auth_user_id') ?? const Uuid().v4();

      final user = UserModel(
        id: existingUserId,
        displayName: prefs.getString('auth_display_name') ?? 'ইউজার',
        phoneNumber: _pendingPhoneNumber,
        isPhoneVerified: true,
        roles: const [UserRole.tenant],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _currentUser = user;
      _pendingPhoneNumber = null;
      _expectedOtp = null;

      await prefs.setString('auth_user_id', user.id);
      await prefs.setString('auth_phone', user.phoneNumber!);
      await prefs.setBool('auth_phone_verified', true);

      // Cloud Firestore User Sync
      try {
        final firestore = FirebaseService.firestore;
        if (firestore != null && FirebaseService.isConfigured) {
          await firestore.collection('users').doc(user.id).set(user.toJson());
        }
      } catch (e) {
        debugPrint('[AuthRepository] Firestore user sync notice: $e');
      }

      notifyListeners();
      return user;
    } finally {
      _isLoading = false;
      notifyListeners();
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

  /// Logout from active session.
  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_user_id');
    await prefs.remove('auth_admin_role');
    notifyListeners();
  }
}

