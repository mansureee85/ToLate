import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/route_names.dart';
import '../../../data/repositories/auth_repository.dart';

class AdminShellScreen extends StatelessWidget {
  final Widget child;

  const AdminShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthRepository>();
    final user = auth.currentUser;

    // RBAC Security Guard: Redirect if not logged in as Admin
    if (user == null || user.adminRole == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.adminLogin);
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 900;

    final navigationItems = [
      {'title': 'ওভারভিউ ড্যাশবোর্ড', 'icon': Icons.dashboard_rounded, 'route': RouteNames.adminDashboard},
      {'title': 'বিজ্ঞাপন মডারেশন', 'icon': Icons.rule_folder_rounded, 'route': RouteNames.adminListings},
      {'title': 'ভেরিফিকেশন সেন্টার', 'icon': Icons.verified_user_rounded, 'route': RouteNames.adminVerification},
      {'title': 'অভিযোগ ও রিপোর্ট কিউ', 'icon': Icons.flag_rounded, 'route': RouteNames.adminReports},
      {'title': 'লোকেশন ও এরিয়া ম্যানেজার', 'icon': Icons.location_city_rounded, 'route': RouteNames.adminLocations},
      {'title': 'সিকিউরিটি অডিট লগ', 'icon': Icons.history_edu_rounded, 'route': RouteNames.adminAudit},
    ];

    final sidebar = Container(
      width: 250,
      color: const Color(0xFF0F172A),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                const Icon(Icons.shield_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ToLate Admin',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        user.adminRole!.title,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: navigationItems.map((item) {
                final route = item['route'] as String;
                final isSelected = GoRouterState.of(context).matchedLocation.startsWith(route);

                return ListTile(
                  leading: Icon(item['icon'] as IconData, color: isSelected ? Colors.amber : Colors.white70),
                  title: Text(
                    item['title'] as String,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                  tileColor: isSelected ? const Color(0xFF334155) : null,
                  onTap: () => context.go(route),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white70,
                side: const BorderSide(color: Colors.white30),
              ),
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('লগআউট'),
              onPressed: () async {
                await auth.logout();
                if (context.mounted) context.go(RouteNames.home);
              },
            ),
          ),
        ],
      ),
    );

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            sidebar,
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      drawer: Drawer(child: sidebar),
      appBar: AppBar(
        title: const Text('ToLate Admin Panel'),
      ),
      body: child,
    );
  }
}
