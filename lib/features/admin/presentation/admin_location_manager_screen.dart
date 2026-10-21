import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../data/repositories/location_repository.dart';

class AdminLocationManagerScreen extends StatelessWidget {
  const AdminLocationManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationRepo = context.watch<LocationRepository>();
    final proposedAreas = locationRepo.proposedAreas;

    return Scaffold(
      appBar: AppBar(title: const Text('লোকেশন ও এরিয়া ম্যানেজার (Location Manager)')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('প্রস্তাবিত নতুন এরিয়াসমূহ (${proposedAreas.length})', style: AppTextStyles.headingSmall),
          const SizedBox(height: 6),
          const Text(
            'ইউজাররা সার্চ বা পোস্ট করার সময় ড্রপডাউনে না পেয়ে যেসব এরিয়া টাইপ করেছেন:',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          if (proposedAreas.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('কোনো পেন্ডিং প্রস্তাবিত এলাকা নেই। সব এলাকা ক্যানোনিকাল তালিকায় অন্তর্ভুক্ত।'),
              ),
            )
          else
            ...proposedAreas.map((prop) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(prop.typedName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              prop.status.name,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text('থানা: ${prop.upazilaThana}, জেলা: ${prop.district}, বিভাগ: ${prop.division}'),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('বাতিল / ডুপ্লিকেট'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              locationRepo.adminApproveProposedArea(
                                proposalId: prop.id,
                                upazilaThanaId: 'thana_dhanmondi',
                                approvedNameBn: prop.typedName,
                                approvedNameEn: prop.normalizedName,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('এরিয়া ক্যানোনিকাল ড্রপডাউনে যুক্ত হয়েছে!')),
                              );
                            },
                            child: const Text('অনুমোদন ও ড্রপডাউনে যুক্ত করুন'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),
          Text('বর্তমান স্বীকৃত প্রশাসনিক বিভাগসমূহ', style: AppTextStyles.headingSmall),
          const SizedBox(height: 10),
          ...locationRepo.divisions.map((d) => ListTile(
                dense: true,
                leading: const Icon(Icons.location_city, color: AppColors.primary),
                title: Text('${d.nameBn} (${d.nameEn})'),
                subtitle: const Text('সরকারি প্রশাসনিক ডাটাবেজ অনুসারে নিবন্ধিত'),
              )),
        ],
      ),
    );
  }
}
