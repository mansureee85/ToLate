import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/repositories/admin_repository.dart';

class AdminAuditLogScreen extends StatelessWidget {
  const AdminAuditLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final adminRepo = context.watch<AdminRepository>();
    final logs = adminRepo.auditLogs;

    return Scaffold(
      appBar: AppBar(title: const Text('সিকিউরিটি অডিট লগ (Audit Log)')),
      body: logs.isEmpty
          ? const AppEmptyState(
              icon: Icons.history_edu_rounded,
              title: 'কোনো প্রশাসনিক অডিট লগ নেই',
              message: 'এডমিন কর্তৃক বিজ্ঞাপন অনুমোদন, বাতিল, ব্যাজ প্রদান বা পরিবর্তন এখানে অমোচনীয়ভাবে লিপিবদ্ধ হবে।',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.security, size: 20, color: AppColors.primary),
                    ),
                    title: Text(log.action, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('টার্গেট: ${log.targetType} (${log.targetId}) | এডমিন: ${log.actorUserId}'),
                        Text('কারণ/নোট: "${log.reason}"', style: const TextStyle(fontStyle: FontStyle.italic)),
                        Text('সময়: ${log.timestamp}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
