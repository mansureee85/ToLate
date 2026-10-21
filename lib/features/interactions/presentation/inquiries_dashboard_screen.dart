import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/interaction_repository.dart';

class InquiriesDashboardScreen extends StatelessWidget {
  const InquiriesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final interactionRepo = context.watch<InteractionRepository>();
    final userId = auth.currentUser?.id ?? '';
    final inquiries = interactionRepo.getInquiriesForUser(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('অনুসন্ধান ও বার্তা (Inquiries)')),
      body: inquiries.isEmpty
          ? const AppEmptyState(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'কোনো অনুসন্ধান বার্তা নেই',
              message: 'আপনার প্রপার্টিতে কোনো আগ্রহী ভাড়াটিয়া বা ক্রেতা প্রশ্ন পাঠালে এখানে দেখতে পাবেন।',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: inquiries.length,
              itemBuilder: (context, index) {
                final inq = inquiries[index];
                return Card(
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.person, color: AppColors.primary),
                    ),
                    title: Text(inq.listingTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${inq.senderName}: "${inq.messageText}"'),
                        const SizedBox(height: 4),
                        Text(
                          'তারিখ: ${inq.createdAt.day}/${inq.createdAt.month}/${inq.createdAt.year}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    trailing: inq.isAnswered
                        ? const Icon(Icons.check_circle, color: AppColors.success, size: 20)
                        : const Icon(Icons.mark_chat_unread_outlined, color: AppColors.accent, size: 20),
                  ),
                );
              },
            ),
    );
  }
}
