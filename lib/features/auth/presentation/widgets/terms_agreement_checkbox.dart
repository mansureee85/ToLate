import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';

/// Terms of Service and Privacy Policy acceptance checkbox.
class TermsAgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsAgreementCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.primary,
          onChanged: onChanged,
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
    );
  }
}

