import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/models/interaction_models.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/interaction_repository.dart';

class ViewingRequestsScreen extends StatelessWidget {
  const ViewingRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final interactionRepo = context.watch<InteractionRepository>();
    final userId = auth.currentUser?.id ?? '';
    final requests = interactionRepo.getViewingRequestsForUser(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('ভিজিটের অনুরোধসমূহ (Viewing Requests)')),
      body: requests.isEmpty
          ? const AppEmptyState(
              icon: Icons.calendar_month_outlined,
              title: 'কোনো শিডিউল অনুরোধ নেই',
              message: 'বাসা পরিদর্শনের জন্য কেউ অনুরোধ পাঠালে বা আপনার পাঠানো অনুরোধ এখানে দেখতে পাবেন।',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];
                final isOwner = req.ownerUserId == userId;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                req.listingTitle,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                req.status.labelBn,
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('অনুরোধকারী: ${req.tenantName}'),
                        Text(
                          'প্রস্তাবিত সময়: ${req.proposedDateTime.day}/${req.proposedDateTime.month}/${req.proposedDateTime.year}',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                        if (req.tenantNote != null && req.tenantNote!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('নোট: "${req.tenantNote}"', style: AppTextStyles.bodySmall),
                        ],
                        if (isOwner && req.status == ViewingRequestStatus.requested) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  interactionRepo.updateViewingStatus(
                                    requestId: req.id,
                                    newStatus: ViewingRequestStatus.declined,
                                  );
                                },
                                child: const Text('প্রত্যাখ্যান'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  interactionRepo.updateViewingStatus(
                                    requestId: req.id,
                                    newStatus: ViewingRequestStatus.accepted,
                                  );
                                },
                                child: const Text('অনুমোদন করুন'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

