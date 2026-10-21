import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/validation/phone_validator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/auth_repository.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  Timer? _countdownTimer;
  int _secondsRemaining = AppConstants.otpResendCooldownSeconds;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    _countdownTimer?.cancel();
    setState(() => _secondsRemaining = AppConstants.otpResendCooldownSeconds);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleVerify() async {
    final code = _otpController.text.trim();
    if (code.length != AppConstants.otpLength) {
      setState(() => _errorMessage = '৬ ডিজিটের ওটিপি লিখুন (পরীক্ষার জন্য: 123456)');
      return;
    }

    setState(() => _errorMessage = null);
    final authRepo = context.read<AuthRepository>();

    try {
      await authRepo.verifyOtp(code);
      if (mounted) {
        context.go(RouteNames.roleSelection);
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    }
  }

  Future<void> _handleResend() async {
    final authRepo = context.read<AuthRepository>();
    if (_secondsRemaining > 0 || authRepo.pendingPhoneNumber == null) return;

    try {
      await authRepo.requestOtp(authRepo.pendingPhoneNumber!);
      _startCooldown();
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = context.watch<AuthRepository>();
    final phone = authRepo.pendingPhoneNumber ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('ওটিপি ভেরিফিকেশন'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'ভেরিফিকেশন কোড লিখুন',
                style: AppTextStyles.headingMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${PhoneValidator.formatForDisplay(phone)} নম্বরে প্রেরিত ৬ ডিজিটের কোডটি লিখুন।',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 28),
              AppTextField(
                controller: _otpController,
                label: 'ওটিপি কোড (OTP)',
                hint: '123456',
                keyboardType: TextInputType.number,
                helperText: 'টেস্টিং কোড: 123456',
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 13),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'যাচাই করুন (Verify & Continue)',
                  isLoading: authRepo.isLoading,
                  onPressed: _handleVerify,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: _secondsRemaining > 0
                    ? Text(
                        'পুনরায় কোড পাঠাতে অপেক্ষা করুন: $_secondsRemaining সেকেন্ড',
                        style: AppTextStyles.bodySmall,
                      )
                    : TextButton(
                        onPressed: _handleResend,
                        child: const Text('কোড পাননি? পুনরায় কোড পাঠান'),
                      ),
              ),
              const SizedBox(height: 36),
              // Legal transparency disclaimer mandated by spec
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: AppColors.textMuted),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'তথ্য সতর্কতা: ওটিপি ভেরিফিকেশন কেবল ফোন নম্বরের নিয়ন্ত্রণ প্রমাণ করে, এটি জাতীয় পরিচয় বা প্রপার্টি মালিকানার কোনো আইনগত নিশ্চয়তা দেয় না।',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

