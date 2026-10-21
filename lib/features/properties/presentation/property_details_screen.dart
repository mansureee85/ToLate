import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/validation/money_validator.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/models/property_listing_model.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/interaction_repository.dart';
import '../../../data/repositories/property_repository.dart';
import '../../moderation/presentation/report_dialog.dart';
import '../../reviews/presentation/reviews_list_view.dart';
import '../../reviews/presentation/write_review_sheet.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final String listingId;

  const PropertyDetailsScreen({
    super.key,
    required this.listingId,
  });

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  int _currentPhotoIndex = 0;

  void _openInquiryDialog(PropertyListingModel listing) {
    final authRepo = context.read<AuthRepository>();
    if (!authRepo.isAuthenticated) {
      context.push(RouteNames.loginPhone);
      return;
    }

    final messageCtrl = TextEditingController(
      text: 'আসসালামু আলাইকুম, আমি এই প্রপার্টি সম্পর্কে বিস্তারিত জানতে আগ্রহী।',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('মালিককে বার্তা পাঠান (Inquiry)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: messageCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'আপনার প্রশ্ন বা বার্তা লিখুন...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = authRepo.currentUser!;
              await context.read<InteractionRepository>().sendInquiry(
                    listingId: listing.id,
                    listingTitle: listing.title,
                    senderUserId: user.id,
                    senderName: user.displayName ?? 'ব্যবহারকারী',
                    recipientOwnerUserId: listing.ownerUserId,
                    messageText: messageCtrl.text.trim(),
                  );
              if (mounted) {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('আপনার অনুসন্ধান বার্তা সফলভাবে পাঠানো হয়েছে!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('পাঠান'),
          ),
        ],
      ),
    );
  }

  void _openViewingDialog(PropertyListingModel listing) {
    final authRepo = context.read<AuthRepository>();
    if (!authRepo.isAuthenticated) {
      context.push(RouteNames.loginPhone);
      return;
    }

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('সরাসরি পরিদর্শনের অনুরোধ (Request Viewing)'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('আপনি কোন দিন বাসাটি দেখতে চান?'),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                label: Text(
                  'তারিখ: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (picked != null) {
                    setDialogState(() => selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(
                  labelText: 'বিশেষ কোনো মন্তব্য (ঐচ্ছিক)',
                  hintText: 'যেমন: বিকেল ৪টার পর আসলে ভালো হয়',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('বাতিল'),
            ),
            ElevatedButton(
              onPressed: () async {
                final user = authRepo.currentUser!;
                await context.read<InteractionRepository>().requestViewing(
                      listingId: listing.id,
                      listingTitle: listing.title,
                      tenantUserId: user.id,
                      tenantName: user.displayName ?? 'ভাড়াটিয়া',
                      ownerUserId: listing.ownerUserId,
                      proposedDateTime: selectedDate,
                      tenantNote: noteCtrl.text.trim(),
                    );
                if (mounted) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('পরিদর্শনের অনুরোধ পাঠানো হয়েছে। মালিক অনুমোদন দিলে নিশ্চিত হবেন।'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              child: const Text('অনুরোধ পাঠান'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeExplanation(VerificationBadgeType badge) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.verified_rounded, color: AppColors.verifiedBadge),
            const SizedBox(width: 8),
            Expanded(child: Text(badge.titleBn)),
          ],
        ),
        content: Text(
          'ব্যাজের ধরন: ${badge.titleEn}\n\n'
          'এই ব্যাজটি নিশ্চিত করে যে প্রপার্টির এই নির্দিষ্ট অংশটি সিস্টেম দ্বারা যাচাই করা হয়েছে। তবে কোনো অবস্থাতেই এটি আইনি স্বত্বাধিকার বা জালিয়াতি-মুক্তির শতভাগ গ্যারান্টি প্রদান করে না। চুক্তি সম্পাদনের পূর্বে নিজে যাচাই করুন।',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('বুঝেছি'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyRepo = context.watch<PropertyRepository>();
    final listing = propertyRepo.getListingById(widget.listingId);

    if (listing == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('প্রপার্টি বিস্তারিত')),
        body: const AppEmptyState(
          icon: Icons.search_off_rounded,
          title: 'বিজ্ঞাপনটি খুঁজে পাওয়া যায়নি',
          message: 'সম্ভবত বিজ্ঞাপনটি মুছে ফেলা হয়েছে বা স্থগিত রয়েছে।',
        ),
      );
    }

    final photos = listing.photoUrls.isNotEmpty
        ? listing.photoUrls
        : ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800'];

    return Scaffold(
      appBar: AppBar(
        title: Text(listing.propertyIntent.displayNameBn),
        actions: [
          IconButton(
            icon: Icon(
              propertyRepo.isFavorite(listing.id) ? Icons.favorite : Icons.favorite_border,
              color: propertyRepo.isFavorite(listing.id) ? Colors.red : null,
            ),
            tooltip: 'পছন্দের তালিকায় রাখুন',
            onPressed: () => propertyRepo.toggleFavorite(listing.id),
          ),
          IconButton(
            icon: const Icon(Icons.report_problem_outlined),
            tooltip: 'অভিযোগ করুন',
            onPressed: () => ReportDialog.show(
              context,
              targetType: 'listing',
              targetId: listing.id,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: AppButton(
                label: 'পরিদর্শন অনুরোধ',
                icon: Icons.calendar_month_outlined,
                isOutlined: true,
                onPressed: () => _openViewingDialog(listing),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppButton(
                label: 'মালিককে বার্তা',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () => _openInquiryDialog(listing),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Carousel
            Stack(
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: photos.length,
                    onPageChanged: (i) => setState(() => _currentPhotoIndex = i),
                    itemBuilder: (ctx, i) => Image.network(
                      photos[i],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(child: Icon(Icons.apartment_rounded, size: 64)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_currentPhotoIndex + 1} / ${photos.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),

            // Main Info
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${MoneyValidator.formatBdt(listing.price)} ${listing.propertyIntent.isRental ? '/মাস' : ''}',
                        style: AppTextStyles.price.copyWith(fontSize: 24),
                      ),
                      if (listing.isPriceNegotiable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'আলোচনা সাপেক্ষ',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Text(listing.title, style: AppTextStyles.headingMedium),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${listing.area}, ${listing.upazilaThana}, ${listing.district}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Verification badges with interactive explanation
                  if (listing.verificationBadges.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      children: listing.verificationBadges.map((badge) {
                        return ActionChip(
                          avatar: const Icon(Icons.verified, size: 16, color: AppColors.verifiedBadge),
                          label: Text(badge.titleBn),
                          onPressed: () => _showBadgeExplanation(badge),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Specs Grid
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _specBlock(Icons.bed_outlined, '${listing.bedrooms}', 'বেডরুম'),
                        _specBlock(Icons.bathtub_outlined, '${listing.bathrooms}', 'বাথরুম'),
                        _specBlock(Icons.balcony_outlined, '${listing.balconies}', 'বারান্দা'),
                        _specBlock(Icons.square_foot_outlined, '${listing.areaSqFt.toInt()}', 'স্কয়ার ফিট'),
                        if (listing.floorNumber != null)
                          _specBlock(Icons.stairs_outlined, '${listing.floorNumber} তলা', 'ফ্লোর'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text('বিস্তারিত বিবরণ', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 8),
                  Text(listing.description, style: AppTextStyles.bodyLarge),
                  const SizedBox(height: 20),

                  // Amenities
                  if (listing.amenities.isNotEmpty) ...[
                    Text('সুযোগ-সুবিধা সমূহ', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: listing.amenities.map((a) {
                        return Chip(
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                          label: Text(a, style: AppTextStyles.bodySmall),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Walkthrough Video Section
                  if (listing.videoUrl != null) ...[
                    Text('প্রপার্টি ওয়াকথ্রু ভিডিও', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 8),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.play_circle_fill_rounded, size: 54, color: Colors.white),
                            SizedBox(height: 8),
                            Text('ভিডিও প্লে করতে চাপুন', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  const Divider(),
                  const SizedBox(height: 12),

                  // Tenant Reviews Section (Photos only, strictly NO video)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ভাড়াটিয়া রিভিউ ও অভিজ্ঞতা', style: AppTextStyles.headingSmall),
                      TextButton.icon(
                        icon: const Icon(Icons.rate_review_outlined, size: 16),
                        label: const Text('রিভিউ দিন'),
                        onPressed: () {
                          final auth = context.read<AuthRepository>();
                          if (!auth.isAuthenticated) {
                            context.push(RouteNames.loginPhone);
                            return;
                          }
                          WriteReviewSheet.show(
                            context,
                            buildingId: listing.buildingId,
                            unitId: listing.unitId,
                            landlordUserId: listing.ownerUserId,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ReviewsListView(
                    buildingId: listing.buildingId,
                    unitId: listing.unitId,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specBlock(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: AppTextStyles.bodySmall),
      ],
    );
  }
}
