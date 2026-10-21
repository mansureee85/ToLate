import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_loading.dart';
import '../../../data/repositories/property_repository.dart';
import 'feed_filters_sheet.dart';
import 'widgets/category_chips_bar.dart';
import 'widgets/property_feed_card.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  PropertyIntent? _selectedCategory;
  PropertySearchFilter _filter = const PropertySearchFilter();

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FeedFiltersSheet(
        initialFilter: _filter,
        onApply: (newFilter) {
          setState(() => _filter = newFilter);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final propertyRepo = context.watch<PropertyRepository>();

    // Apply combined category chip and dynamic sheet filter
    final effectiveFilter = PropertySearchFilter(
      intent: _selectedCategory ?? _filter.intent,
      minPrice: _filter.minPrice,
      maxPrice: _filter.maxPrice,
      minBedrooms: _filter.minBedrooms,
      minBathrooms: _filter.minBathrooms,
      requiredAmenities: _filter.requiredAmenities,
    );

    final listings = propertyRepo.searchListings(effectiveFilter);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.apartment_rounded, color: AppColors.primary, size: 28),
            const SizedBox(width: 8),
            Text(
              'ToLate',
              style: AppTextStyles.headingMedium.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'ফিল্টার করুন',
            onPressed: _openFilters,
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'নোটিফিকেশন',
            onPressed: () => context.push(RouteNames.notifications),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Search Bar trigger
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () => context.push(RouteNames.searchWizard),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'কোথায় বাসা বা ফ্ল্যাট খুঁজছেন? স্মার্ট সার্চ করুন...',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                    const Icon(Icons.mic_none_rounded, color: AppColors.accent, size: 20),
                  ],
                ),
              ),
            ),
          ),

          // Category Chips Bar
          CategoryChipsBar(
            selectedIntent: _selectedCategory,
            onIntentSelected: (intent) => setState(() => _selectedCategory = intent),
          ),
          const SizedBox(height: 8),

          // Main Feed List or Real Truthful Empty State
          Expanded(
            child: propertyRepo.isLoading
                ? const AppLoading(message: 'বিজ্ঞাপন লোড হচ্ছে...')
                : listings.isEmpty
                    ? AppEmptyState(
                        icon: Icons.holiday_village_outlined,
                        title: 'এখনও কোনো বিজ্ঞাপন পাওয়া যায়নি',
                        message: _selectedCategory != null
                            ? 'এই ক্যাটাগরিতে বর্তমানে কোনো প্রকাশিত বিজ্ঞাপন নেই।'
                            : 'আপনার এলাকায় নতুন বাসা বা ফ্ল্যাট খুঁজতে সার্চ অপশন ব্যবহার করুন অথবা প্রথম বিজ্ঞাপনটি পোস্ট করুন।',
                        actionLabel: 'স্মার্ট সার্চ শুরু করুন',
                        onAction: () => context.push(RouteNames.searchWizard),
                        secondaryActionLabel: 'নতুন বিজ্ঞাপন দিন',
                        onSecondaryAction: () => context.push(RouteNames.postProperty),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          // Real refresh
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: listings.length,
                          itemBuilder: (context, index) {
                            final listing = listings[index];
                            final isFav = propertyRepo.isFavorite(listing.id);

                            return PropertyFeedCard(
                              listing: listing,
                              isFavorite: isFav,
                              onFavoriteToggle: () => propertyRepo.toggleFavorite(listing.id),
                              onTap: () => context.push('/property/${listing.id}'),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
