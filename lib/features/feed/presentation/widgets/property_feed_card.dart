import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../../../core/validation/money_validator.dart';
import '../../../../data/models/property_listing_model.dart';

/// Reusable Property Feed Card.
class PropertyFeedCard extends StatelessWidget {
  final PropertyListingModel listing;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;
  final VoidCallback? onShare;

  const PropertyFeedCard({
    super.key,
    required this.listing,
    required this.onTap,
    required this.onFavoriteToggle,
    this.isFavorite = false,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = listing.photoUrls.isNotEmpty
        ? listing.photoUrls.first
        : 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Media header
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    photoUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surfaceVariant,
                      child: const Center(
                        child: Icon(Icons.apartment_rounded, size: 48, color: AppColors.textMuted),
                      ),
                    ),
                  ),
                ),
                // Purpose tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      listing.propertyIntent.displayNameBn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Video indicator if available
                if (listing.videoUrl != null)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.videocam, size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('ভিডিও আছে', style: TextStyle(color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.85),
                    radius: 18,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : AppColors.textPrimary,
                        size: 20,
                      ),
                      onPressed: onFavoriteToggle,
                    ),
                  ),
                ),
              ],
            ),

            // Details section
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and negotiation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${MoneyValidator.formatBdt(listing.price)} ${listing.propertyIntent.isRental ? '/মাস' : ''}',
                        style: AppTextStyles.price,
                      ),
                      if (listing.isPriceNegotiable)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.accentLight,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'আলোচনা সাপেক্ষ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    listing.title,
                    style: AppTextStyles.headingSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 15, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${listing.area}, ${listing.upazilaThana}, ${listing.district}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Key specs chips (Beds, Baths, SqFt)
                  if (listing.bedrooms > 0 || listing.bathrooms > 0 || listing.areaSqFt > 0) ...[
                    Row(
                      children: [
                        if (listing.bedrooms > 0) ...[
                          _specItem(Icons.bed_outlined, '${listing.bedrooms} বেড'),
                          const SizedBox(width: 12),
                        ],
                        if (listing.bathrooms > 0) ...[
                          _specItem(Icons.bathtub_outlined, '${listing.bathrooms} বাথ'),
                          const SizedBox(width: 12),
                        ],
                        if (listing.areaSqFt > 0) ...[
                          _specItem(Icons.square_foot_outlined, '${listing.areaSqFt.toInt()} স্কয়ার ফিট'),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],

                  const Divider(height: 16),

                  // Verification badges & Confirm freshness
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (listing.verificationBadges.isNotEmpty)
                        Row(
                          children: [
                            const Icon(Icons.verified_rounded, size: 16, color: AppColors.verifiedBadge),
                            const SizedBox(width: 4),
                            Text(
                              listing.verificationBadges.first.titleBn,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.verifiedBadge,
                              ),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'সাধারণ বিজ্ঞাপন',
                          style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                        ),

                      Text(
                        'যাচাইকৃত: ${_formatConfirmDate(listing.lastConfirmedAt)}',
                        style: AppTextStyles.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _specItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  String _formatConfirmDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
