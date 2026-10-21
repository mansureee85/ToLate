import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/validation/phone_validator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/property_repository.dart';
import '../../feed/presentation/widgets/property_feed_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = context.watch<AuthRepository>();
    final propertyRepo = context.watch<PropertyRepository>();
    final user = authRepo.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('প্রোফাইল')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle_outlined, size: 72, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text('আপনার কোনো অ্যাকাউন্ট নেই বা লগইন করা নেই', style: AppTextStyles.headingSmall),
                const SizedBox(height: 8),
                Text('বিজ্ঞাপন পোস্ট ও বুকিংয়ের জন্য সাইন ইন করুন।', style: AppTextStyles.bodyMedium),
                const SizedBox(height: 24),
                AppButton(
                  label: 'লগইন / সাইন আপ করুন',
                  onPressed: () => context.push(RouteNames.loginPhone),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final myListings = propertyRepo.getListingsForOwner(user.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('আমার প্রোফাইল'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'সেটিংস ও গোপনীয়তা',
            onPressed: () => context.push(RouteNames.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Cover Photo & Avatar Header
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    image: user.coverPhotoUrl != null
                        ? DecorationImage(image: NetworkImage(user.coverPhotoUrl!), fit: BoxFit.cover)
                        : null,
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: 20,
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: AppColors.primary,
                      backgroundImage: user.profilePhotoUrl != null
                          ? NetworkImage(user.profilePhotoUrl!)
                          : null,
                      child: user.profilePhotoUrl == null
                          ? Text(
                              user.displayName != null && user.displayName!.isNotEmpty
                                  ? user.displayName![0]
                                  : 'U',
                              style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                            )
                          : null,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.9),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    icon: const Icon(Icons.edit, size: 14),
                    label: const Text('এডিট', style: TextStyle(fontSize: 12)),
                    onPressed: () => context.push(RouteNames.editProfile),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            // Profile info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(user.displayName ?? 'ব্যবহারকারী', style: AppTextStyles.headingMedium),
                      const SizedBox(width: 8),
                      if (user.isPhoneVerified)
                        const Tooltip(
                          message: 'ফোন নম্বর ভেরিফাইড',
                          child: Icon(Icons.verified, size: 18, color: AppColors.verifiedBadge),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (user.privacySettings.showPhoneNumber && user.phoneNumber != null)
                    Text(
                      PhoneValidator.formatForDisplay(user.phoneNumber),
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  if (user.bio != null) ...[
                    const SizedBox(height: 8),
                    Text(user.bio!, style: AppTextStyles.bodyMedium),
                  ],
                  const SizedBox(height: 12),

                  // Role Chips
                  Wrap(
                    spacing: 8,
                    children: user.roles.map((role) {
                      return Chip(
                        backgroundColor: AppColors.primaryLight,
                        label: Text(role.labelBn, style: const TextStyle(fontSize: 11, color: AppColors.primary)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Admin badge shortcut if authorized
                  if (user.isAdmin)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        border: Border.all(color: Colors.amber.shade400),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.admin_panel_settings, color: Colors.amber, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('এডমিন অধিকার সক্রিয় (${user.adminRole?.title})',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                const Text('মডারেশন ও ম্যানেজমেন্ট কন্ট্রোল', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                            onPressed: () => context.push(RouteNames.adminDashboard),
                            child: const Text('ড্যাশবোর্ড', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),

                  const Divider(),
                  const SizedBox(height: 8),

                  // User's listings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('আমার বিজ্ঞাপনসমূহ (${myListings.length})', style: AppTextStyles.headingSmall),
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('নতুন বিজ্ঞাপন'),
                        onPressed: () => context.push(RouteNames.postProperty),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (myListings.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'আপনি এখনও কোনো প্রপার্টি বিজ্ঞাপন পোস্ট করেননি।',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    )
                  else
                    ...myListings.map((listing) => PropertyFeedCard(
                          listing: listing,
                          isFavorite: propertyRepo.isFavorite(listing.id),
                          onFavoriteToggle: () => propertyRepo.toggleFavorite(listing.id),
                          onTap: () => context.push('/property/${listing.id}'),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
