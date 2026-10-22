import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/route_names.dart';
import '../../../core/errors/error_mapper.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/auth_repository.dart';
import 'widgets/admin_access_button.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_error_banner.dart';
import 'widgets/auth_header.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/phone_input_field.dart';
import 'widgets/terms_agreement_checkbox.dart';

/// Clean, modular Login & Sign-Up screen supporting Google & Phone OTP.
/// Fully responsive across mobile, tablet, and widescreen desktop.
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

  Future<void> _handleGoogleSignIn() async {
    if (!_termsAccepted) {
      setState(() => _errorMessage = 'অনুগ্রহ করে সেবা শর্তাবলীতে সম্মতি জানান।');
      return;
    }

    setState(() => _errorMessage = null);
    final authRepo = context.read<AuthRepository>();

    try {
      final user = await authRepo.signInWithGoogle();
      if (user != null && mounted) {
        if (user.roles.isNotEmpty && user.displayName != null && user.displayName != 'ইউজার') {
          context.go(RouteNames.home);
        } else {
          context.go(RouteNames.roleSelection);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
      }
    }
  }

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
      if (mounted) {
        setState(() => _errorMessage = ErrorMapper.mapToMessage(e));
      }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;

    return Scaffold(
      backgroundColor: isWide ? const Color(0xFFF3F4F6) : Colors.white,
      appBar: AppBar(
        title: const Text('লগইন বা সাইন আপ'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 24.0 : 20.0,
              vertical: isWide ? 36.0 : 16.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isWide ? 16 : 0),
                  border: isWide ? Border.all(color: AppColors.border, width: 1.2) : null,
                  boxShadow: isWide
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : null,
                ),
                padding: EdgeInsets.all(isWide ? 32.0 : 8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AuthHeader(),
                      const SizedBox(height: 24),
                      if (_errorMessage != null) ...[
                        AuthErrorBanner(message: _errorMessage!),
                        const SizedBox(height: 18),
                      ],
                      GoogleSignInButton(
                        isLoading: authRepo.isLoading,
                        onPressed: _handleGoogleSignIn,
                      ),
                      const SizedBox(height: 20),
                      const AuthDivider(),
                      const SizedBox(height: 20),
                      PhoneInputField(controller: _phoneController),
                      const SizedBox(height: 12),
                      TermsAgreementCheckbox(
                        value: _termsAccepted,
                        onChanged: (val) => setState(() => _termsAccepted = val ?? false),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: 'ওটিপি পাঠান (Send OTP)',
                        isLoading: authRepo.isLoading,
                        onPressed: _handleSendOtp,
                      ),
                      const SizedBox(height: 20),
                      AdminAccessButton(
                        onPressed: () => context.push(RouteNames.adminLogin),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
