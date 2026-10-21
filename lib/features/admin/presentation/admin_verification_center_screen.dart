import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/constants/property_enums.dart';

class AdminVerificationCenterScreen extends StatelessWidget {
  const AdminVerificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final verificationScopes = [
      {
        'badge': VerificationBadgeType.phoneVerified,
        'scope': 'মোবাইল ওটিপি যাচাইকরণ',
        'desc': 'ব্যবহারকারী এসএমএস ওটিপি দ্বারা নম্বরের নিয়ন্ত্রণ প্রমাণ করেছেন।',
        'automated': true,
      },
      {
        'badge': VerificationBadgeType.ownerIdentityChecked,
        'scope': 'মালিকের এনআইডি / পরিচয়পত্র যাচাই',
        'desc': 'জাতীয় পরিচয়পত্র বা পাসপোর্টের সাথে প্রোফাইলের নামের মিল যাচাই।',
        'automated': false,
      },
      {
        'badge': VerificationBadgeType.agentAuthorizedChecked,
        'scope': 'এজেন্টের চুক্তিপত্র ও অনুমতি',
        'desc': 'প্রকৃত মালিকের সাথে এজেন্টের চুক্তি ও প্রতিনিধির সনদ যাচাই।',
        'automated': false,
      },
      {
        'badge': VerificationBadgeType.locationChecked,
        'scope': 'লোকেশন ও হোল্ডিং ঠিকানা যাচাই',
        'desc': 'ইউটিলিটি বিল বা হোল্ডিং ট্যাক্স রসিদের সাথে ভৌগোলিক ঠিকানা পরীক্ষা।',
        'automated': false,
      },
      {
        'badge': VerificationBadgeType.propertyInspected,
        'scope': 'সরাসরি ইন-পার্সন পরিদর্শন',
        'desc': 'কোম্পানির প্রতিনিধি সরাসরি স্পটে উপস্থিত হয়ে ছবি ও সুযোগ-সুবিধা মেপেছেন।',
        'automated': false,
      },
      {
        'badge': VerificationBadgeType.titleDocumentsReviewed,
        'scope': 'দলিলপত্র ও স্বত্ব পর্যালোচনা',
        'desc': 'আইনি বিশেষজ্ঞদের মাধ্যমে জমির খতিয়ান বা ফ্ল্যাট রেজিস্ট্রি দলিল নিরীক্ষা।',
        'automated': false,
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ভেরিফিকেশন সেন্টার (Verification Center)')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.security_rounded, color: AppColors.primary, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('স্বচ্ছ যাচাইকরণ নীতিমালা', style: AppTextStyles.headingSmall),
                      const SizedBox(height: 4),
                      const Text(
                        'একটি একক সাধারণ "Verified" ব্যাজের পরিবর্তে প্রতিটি ব্যাজের আলাদা পরিধি ও প্রমাণপত্র নিরীক্ষিত রাখা হয়।',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('যাচাইকরণ বিভাগসমূহ', style: AppTextStyles.headingSmall),
          const SizedBox(height: 12),
          ...verificationScopes.map((scope) {
            final badge = scope['badge'] as VerificationBadgeType;
            final isAuto = scope['automated'] as bool;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: const Icon(Icons.verified, color: AppColors.verifiedBadge, size: 22),
                ),
                title: Text(badge.titleBn, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(scope['desc'] as String, style: AppTextStyles.bodySmall),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isAuto ? Colors.green.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isAuto ? 'অটোমেটেড (SMS Gateway)' : 'ম্যানুয়াল ভেরিফিকেশন টিম',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isAuto ? Colors.green.shade700 : Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            );
          }),
        ],
      ),
    );
  }
}

