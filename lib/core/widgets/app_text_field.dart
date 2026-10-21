import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// Standard form text field with validation, optional voice-to-text trigger, and clear styling.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool obscureText;
  final TextInputType keyboardType;
  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onVoicePressed;
  final bool isVoiceListening;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.onVoicePressed,
    this.isVoiceListening = false,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? effectiveSuffix = suffix;

    if (onVoicePressed != null) {
      final micButton = IconButton(
        icon: Icon(
          isVoiceListening ? Icons.mic : Icons.mic_none,
          color: isVoiceListening ? AppColors.accent : AppColors.primary,
        ),
        tooltip: 'কন্ঠস্বর দিয়ে লিখুন (Voice-to-Text)',
        onPressed: onVoicePressed,
      );

      if (effectiveSuffix != null) {
        effectiveSuffix = Row(
          mainAxisSize: MainAxisSize.min,
          children: [micButton, effectiveSuffix],
        );
      } else {
        effectiveSuffix = micButton;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            errorText: errorText,
            prefixIcon: prefix,
            suffixIcon: effectiveSuffix,
          ),
        ),
      ],
    );
  }
}

