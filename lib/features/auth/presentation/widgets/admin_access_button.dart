import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';

/// Flat button for staff to navigate to admin login.
class AdminAccessButton extends StatelessWidget {
  final VoidCallback onPressed;

  const AdminAccessButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: const Text(
          'এডমিন পোর্টাল এক্সেস (Staff Only)',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

