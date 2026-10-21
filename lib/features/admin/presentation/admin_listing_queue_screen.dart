import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/models/property_listing_model.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/property_repository.dart';

class AdminListingQueueScreen extends StatelessWidget {
  const AdminListingQueueScreen({super.key});

  void _promptRejection(BuildContext context, PropertyListingModel listing) {
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('বিজ্ঞাপন প্রত্যাখানের কারণ দিন'),
        content: TextField(
          controller: reasonCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'কেন প্রত্যাখ্যান করা হচ্ছে তা স্পষ্টভাবে লিখুন...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              final reason = reasonCtrl.text.trim();
              if (reason.isEmpty) return;
              final admin = context.read<AuthRepository>().currentUser!;
              await context.read<AdminRepository>().rejectListing(
                    admin: admin,
                    listingId: listing.id,
                    rejectionReason: reason,
                  );
              if (context.mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('বিজ্ঞাপন প্রত্যাখ্যান করা হয়েছে।')),
                );
              }
            },
            child: const Text('প্রত্যাখ্যান নিশ্চিত করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyRepo = context.watch<PropertyRepository>();
    final adminRepo = context.read<AdminRepository>();
    final adminUser = context.read<AuthRepository>().currentUser;

    final listings = propertyRepo.publishedListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('বিজ্ঞাপন মডারেশন কিউ (Listing Queue)'),
      ),
      body: listings.isEmpty
          ? const AppEmptyState(
              icon: Icons.check_circle_outline_rounded,
              title: 'কোনো অপেক্ষমাণ বিজ্ঞাপন নেই',
              message: 'ইউজাররা নতুন বিজ্ঞাপন জমা দিলে বা অভিযোগ উঠলে এখানে দেখা যাবে।',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              itemBuilder: (context, index) {
                final item = listings[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                item.propertyIntent.displayNameBn,
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'স্ট্যাটাস: ${item.status.labelBn}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(item.title, style: AppTextStyles.headingSmall),
                        const SizedBox(height: 4),
                        Text('${item.area}, ${item.upazilaThana}, ${item.district} | ৳ ${item.price.toInt()}'),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              icon: const Icon(Icons.block, size: 16, color: AppColors.error),
                              label: const Text('প্রত্যাখ্যান / ব্লক', style: TextStyle(color: AppColors.error)),
                              onPressed: () => _promptRejection(context, item),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.verified, size: 16),
                              label: const Text('ভেরিফিকেশন ব্যাজ দিন'),
                              onPressed: () {
                                if (adminUser != null) {
                                  adminRepo.assignVerificationBadge(
                                    admin: adminUser,
                                    listingId: item.id,
                                    badge: VerificationBadgeType.locationChecked,
                                    evidenceNote: 'মালিকের এনআইডি ও বিদ্যুৎ বিলের কপি যাচাই সম্পন্ন।',
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('লোকেশন যাচাইকরণ ব্যাজ যুক্ত করা হয়েছে!')),
                                  );
                                }
                              },
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

