import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';

/// Top branding header for auth flows.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBadge;

  const AuthHeader({
    super.key,
    this.title = 'স্বাগতম ToLate-এ',
    this.subtitle = 'আপনার কাঙ্ক্ষিত বাসা, ফ্ল্যাট বা মেস সহজে খুঁজে পেতে অথবা বিজ্ঞাপন দিতে সাইন ইন করুন।',
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBadge) ...[
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.home_work_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          style: AppTextStyles.headingMedium,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }
}
