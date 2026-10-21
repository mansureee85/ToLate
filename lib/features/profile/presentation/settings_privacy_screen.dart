import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/route_names.dart';
import '../../../core/widgets/app_confirm_dialog.dart';
import '../../../data/repositories/auth_repository.dart';

class SettingsPrivacyScreen extends StatelessWidget {
  const SettingsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = context.watch<AuthRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('সেটিংস ও নিরাপত্তা')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.language_rounded, color: AppColors.primary),
            title: const Text('ভাষা (Language)'),
            subtitle: const Text('বাংলা (Bangla)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ভাষা পরিবর্তন কনফিগারেশন শীঘ্রই উপলব্ধ হবে।')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications_outlined, color: AppColors.primary),
            title: const Text('নোটিফিকেশন পছন্দ'),
            subtitle: const Text('বিজ্ঞাপন ও ইনকোয়ারি নোটিফিকেশন চালু'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security_rounded, color: AppColors.primary),
            title: const Text('গোপনীয়তা ও ডেটা সুরক্ষা'),
            subtitle: const Text('ব্যক্তিগত তথ্য নিয়ন্ত্রণ করুন'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
            title: const Text('সাহায্য ও সাপোর্ট'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.primary),
            title: const Text('সেবা শর্তাবলী ও নীতিমালা (Terms & Privacy)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text('লগআউট (Log Out)', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            onTap: () async {
              final confirm = await AppConfirmDialog.show(
                context,
                title: 'লগআউট নিশ্চিতকরণ',
                message: 'আপনি কি নিশ্চিত যে আপনার সেশনটি বন্ধ করতে চান?',
                confirmLabel: 'লগআউট',
                isDestructive: true,
              );
              if (confirm && context.mounted) {
                await authRepo.logout();
                if (context.mounted) {
                  context.go(RouteNames.loginPhone);
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined, color: AppColors.textMuted),
            title: const Text('অ্যাকাউন্ট মুছে ফেলার অনুরোধ', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
            onTap: () {
              AppConfirmDialog.show(
                context,
                title: 'অ্যাকাউন্ট ডিলিট অনুরোধ',
                message: 'আপনার অ্যাকাউন্ট ও প্রপার্টি তথ্য অপসারণের অনুরোধ গৃহীত হবে এবং ৩ দিনের মধ্যে যাচাই করে মুছে ফেলা হবে।',
                confirmLabel: 'অনুরোধ পাঠান',
                isDestructive: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

