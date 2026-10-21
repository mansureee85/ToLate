import 'package:flutter/material.dart';
import '../../../core/widgets/app_empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('বিজ্ঞপ্তি (Notifications)')),
      body: const AppEmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'কোনো নতুন বিজ্ঞপ্তি নেই',
        message: 'বিজ্ঞাপন অনুমোদন, অনুসন্ধান বার্তা ও মূল্যের আপডেট সংক্রান্ত তথ্য এখানে পাবেন।',
      ),
    );
  }
}

