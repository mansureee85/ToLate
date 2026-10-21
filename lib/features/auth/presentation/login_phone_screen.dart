import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/validation/phone_validator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginPhoneScreen extends StatefulWidget {
  const LoginPhoneScreen({super.key});

  @override
  State<LoginPhoneScreen> createState() => _LoginPhoneScreenState();
}

class _LoginPhoneScreenState extends State<LoginPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _termsAccepted = true;
  String? _errorMessage;

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'অনুগ্রহ করে সেবা শর্তাবলীতে সম্মতি জানান।');
      return;
    }

    setState(() => _errorMessage = null);
    final authRepo = context.read<AuthRepository>();

    try {
      await authRepo.requestOtp(_phoneController.text.trim());
      if (mounted) {
        context.push(RouteNames.otpVerify);
      }
    } catch (e) {
      setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authRepo = context.watch<AuthRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('লগইন বা সাইন আপ'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                Text(
                  'আপনার মোবাইল নম্বর দিন',
                  style: AppTextStyles.headingMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'আমরা আপনার নম্বরে ৬ ডিজিটের ভেরিফিকেশন ওটিপি (OTP) পাঠাবো।',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 28),
                AppTextField(
                  controller: _phoneController,
                  label: 'মোবাইল নম্বর',
                  hint: '017XXXXXXXX বা 17XXXXXXXX',
                  keyboardType: TextInputType.phone,
                  prefix: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: const Text(
                      '+880',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'মোবাইল নম্বর দেওয়া আবশ্যক';
                    }
                    if (!PhoneValidator.isValidBdPhone(value)) {
                      return 'সঠিক ১১ বা ১০ ডিজিটের বাংলাদেশি নম্বর দিন';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          'আমি ToLate এর সেবা শর্তাবলী (Terms of Service) ও গোপনীয়তা নীতিমালার সাথে একমত।',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: AppColors.error, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'ওটিপি পাঠান (Send OTP)',
                    isLoading: authRepo.isLoading,
                    onPressed: _handleSendOtp,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () => context.push(RouteNames.adminLogin),
                    child: const Text(
                      'এডমিন পোর্টাল এক্সেস (Staff Only)',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
