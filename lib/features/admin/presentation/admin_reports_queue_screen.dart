import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/repositories/interaction_repository.dart';

class AdminReportsQueueScreen extends StatelessWidget {
  const AdminReportsQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final interactionRepo = context.watch<InteractionRepository>();
    final reports = interactionRepo.reports;

    return Scaffold(
      appBar: AppBar(title: const Text('অভিযোগ ও রিপোর্ট কিউ (Report Queue)')),
      body: reports.isEmpty
          ? const AppEmptyState(
              icon: Icons.shield_outlined,
              title: 'কোনো পেন্ডিং অভিযোগ নেই',
              message: 'ব্যবহারকারীরা কোনো বিজ্ঞাপনের বিরুদ্ধে রিপোর্ট করলে তদন্তের জন্য এখানে জমা হবে।',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                report.category.labelBn,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'টার্গেট: ${report.targetType} (#${report.targetId.substring(0, report.targetId.length > 8 ? 8 : report.targetId.length)})',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text('অভিযোগের বিবরণ:', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        const SizedBox(height: 4),
                        Text(report.description, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('অভিযোগটি খারিজ করা হয়েছে।')),
                                );
                              },
                              child: const Text('খারিজ'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('বিজ্ঞাপন স্থগিত ও মালিককে নোটিশ পাঠানো হয়েছে।')),
                                );
                              },
                              child: const Text('বিজ্ঞাপন স্থগিত করুন'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

