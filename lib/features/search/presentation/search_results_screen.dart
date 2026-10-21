import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/route_names.dart';
import '../../../core/constants/property_enums.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/models/property_listing_model.dart';
import '../../../data/repositories/property_repository.dart';
import '../../feed/presentation/widgets/property_feed_card.dart';

class SearchResultsScreen extends StatefulWidget {
  final Map<String, String> queryParameters;

  const SearchResultsScreen({
    super.key,
    required this.queryParameters,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  String _sortBy = 'newest'; // newest, priceAsc, priceDesc

  @override
  Widget build(BuildContext context) {
    final propertyRepo = context.watch<PropertyRepository>();

    final intentName = widget.queryParameters['intent'];
    final intent = intentName != null
        ? PropertyIntent.values.firstWhere(
            (e) => e.name == intentName,
            orElse: () => PropertyIntent.flatRent,
          )
        : null;

    final filter = PropertySearchFilter(
      intent: intent,
      division: widget.queryParameters['division'],
      district: widget.queryParameters['district'],
      upazilaThana: widget.queryParameters['upazila'],
      unionWard: widget.queryParameters['unionWard'],
      area: widget.queryParameters['area'],
      minPrice: double.tryParse(widget.queryParameters['minPrice'] ?? ''),
      maxPrice: double.tryParse(widget.queryParameters['maxPrice'] ?? ''),
      minBedrooms: int.tryParse(widget.queryParameters['bedrooms'] ?? ''),
    );

    List<PropertyListingModel> results = propertyRepo.searchListings(filter);

    // Sort
    if (_sortBy == 'priceAsc') {
      results.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'priceDesc') {
      results.sort((a, b) => b.price.compareTo(a.price));
    } else {
      results.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          results.isNotEmpty
              ? '${results.length} টি ফলাফল পাওয়া গেছে'
              : 'সার্চ ফলাফল (Search Results)',
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'সর্ট করুন',
            onSelected: (val) => setState(() => _sortBy = val),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'newest', child: Text('নতুন বিজ্ঞাপন আগে')),
              const PopupMenuItem(value: 'priceAsc', child: Text('কম ভাড়া/মূল্য আগে')),
              const PopupMenuItem(value: 'priceDesc', child: Text('বেশি ভাড়া/মূল্য আগে')),
            ],
          ),
        ],
      ),
      body: results.isEmpty
          ? AppEmptyState(
              icon: Icons.search_off_rounded,
              title: 'আপনার শর্ত অনুযায়ী কোনো প্রপার্টি মেলেনি',
              message:
                  'বাজেট বাড়াতে পারেন, নির্দিষ্ট এরিয়ার পরিবর্তে পুরো থানা নির্বাচন করতে পারেন অথবা অন্য ফিল্টার পরিবর্তন করে দেখতে পারেন।',
              actionLabel: 'সার্চ ফিল্টার পরিবর্তন করুন',
              onAction: () => Navigator.of(context).pop(),
              secondaryActionLabel: 'নতুন বিজ্ঞাপন পোস্ট করুন',
              onSecondaryAction: () => context.push(RouteNames.postProperty),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return PropertyFeedCard(
                  listing: item,
                  isFavorite: propertyRepo.isFavorite(item.id),
                  onFavoriteToggle: () => propertyRepo.toggleFavorite(item.id),
                  onTap: () => context.push('/property/${item.id}'),
                );
              },
            ),
    );
  }
}

