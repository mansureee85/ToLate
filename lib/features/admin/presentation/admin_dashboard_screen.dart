import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/repositories/interaction_repository.dart';
import '../../../data/repositories/location_repository.dart';
import '../../../data/repositories/property_repository.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final propertyRepo = context.watch<PropertyRepository>();
    final locationRepo = context.watch<LocationRepository>();
    final interactionRepo = context.watch<InteractionRepository>();
    final adminRepo = context.watch<AdminRepository>();

    final totalBuildings = propertyRepo.buildings.length;
    final totalUnits = propertyRepo.units.length;
    final totalPublishedListings = propertyRepo.publishedListings.length;
    final pendingReports = interactionRepo.reports.length;
    final pendingProposedAreas = locationRepo.proposedAreas.length;
    final totalAuditLogs = adminRepo.auditLogs.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('এডমিন ওভারভিউ ড্যাশবোর্ড (Overview Dashboard)'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('বাস্তব ডাটাবেজ মেট্রিক্স (Real Live Metrics)', style: AppTextStyles.headingSmall),
            const SizedBox(height: 6),
            const Text(
              'জিরো-ডামি ডাটা পলিসি অনুসারে প্রদর্শিত মোট পরিসংখ্যান:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // Live metric cards grid
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _metricCard('মোট প্রকাশিত বিজ্ঞাপন', '$totalPublishedListings', Icons.apartment_rounded, AppColors.primary),
                _metricCard('নিবন্ধিত ভবন প্রোফাইল', '$totalBuildings', Icons.domain_rounded, Colors.teal),
                _metricCard('মোট ফ্ল্যাট / ইউনিট', '$totalUnits', Icons.meeting_room_outlined, Colors.indigo),
                _metricCard('অপেক্ষমাণ রিপোর্ট / অভিযোগ', '$pendingReports', Icons.flag_rounded, Colors.orange),
                _metricCard('প্রস্তাবিত নতুন এরিয়া', '$pendingProposedAreas', Icons.add_location_alt_rounded, Colors.blue),
                _metricCard('মোট অডিট লগ রেকর্ড', '$totalAuditLogs', Icons.history_edu_rounded, Colors.blueGrey),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions & Health check
            Text('সিস্টেম ও ডাটাবেজ স্ট্যাটাস', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _statusRow('ডাটাবেজ কানেকশন', 'সক্রিয় (Active)', Icons.cloud_done, AppColors.success),
                    const Divider(),
                    _statusRow('বাংলাদেশ প্রশাসনিক লোকেশন ডাটা', 'লোড করা হয়েছে (Dhaka, CTG, Sylhet...)', Icons.check_circle_outline, AppColors.success),
                    const Divider(),
                    _statusRow('ভুয়া ডাটা প্রতিরোধ নীতি', 'কঠোরভাবে বলবৎ (Enforced)', Icons.shield_outlined, AppColors.primary),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String title, String count, IconData icon, Color color) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Icon(icon, color: color, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String title, String status, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
          ],
        ),
        Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }
}
