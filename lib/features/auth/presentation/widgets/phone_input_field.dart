import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../core/validation/phone_validator.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Modular input field specifically calibrated for Bangladesh mobile numbers (+880).
class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: 'মোবাইল নম্বর',
      hint: '017XXXXXXXX বা 17XXXXXXXX',
      keyboardType: TextInputType.phone,
      onChanged: onChanged,
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
    );
  }
}

