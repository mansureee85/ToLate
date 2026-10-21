import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../app/route_names.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/repositories/property_repository.dart';
import '../../feed/presentation/widgets/property_feed_card.dart';

class SavedSearchesScreen extends StatelessWidget {
  const SavedSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final propertyRepo = context.watch<PropertyRepository>();
    final favorites = propertyRepo.favoriteListings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('পছন্দের তালিকা (Saved Properties)'),
      ),
      body: favorites.isEmpty
          ? AppEmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'পছন্দের তালিকায় কোনো প্রপার্টি নেই',
              message: 'হোম ফিড অথবা সার্চ রেজাল্ট থেকে আপনার পছন্দের ফ্ল্যাটে হার্ট আইকন চাপুন।',
              actionLabel: 'বিজ্ঞাপন খুঁজুন',
              onAction: () => context.go(RouteNames.home),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return PropertyFeedCard(
                  listing: item,
                  isFavorite: true,
                  onFavoriteToggle: () => propertyRepo.toggleFavorite(item.id),
                  onTap: () => context.push('/property/${item.id}'),
                );
              },
            ),
    );
  }
}

