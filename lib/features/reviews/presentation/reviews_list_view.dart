import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_text_styles.dart';
import '../../../data/models/review_model.dart';
import '../../../data/repositories/review_repository.dart';

class ReviewsListView extends StatelessWidget {
  final String? buildingId;
  final String? unitId;

  const ReviewsListView({
    super.key,
    this.buildingId,
    this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    final reviewRepo = context.watch<ReviewRepository>();
    final reviews = reviewRepo.getReviewsForProperty(
      buildingId: buildingId,
      unitId: unitId,
    );

    if (reviews.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.rate_review_outlined, color: AppColors.textMuted, size: 36),
              SizedBox(height: 8),
              Text(
                'এই প্রপার্টির জন্য এখনও কোনো রিভিউ জমা পড়েনি।',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: reviews.map((review) => _buildReviewCard(review)).toList(),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info & verification badge
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  radius: 18,
                  child: Text(
                    review.authorDisplayName.isNotEmpty ? review.authorDisplayName[0] : 'U',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.authorDisplayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('ভাড়া থাকার সময়কাল: ${review.tenancyDurationMonths} মাস', style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: review.verificationStatus == ReviewVerificationStatus.verified
                        ? AppColors.primaryLight
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    review.verificationStatus.labelBn,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: review.verificationStatus == ReviewVerificationStatus.verified
                          ? AppColors.primary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Dimensional ratings breakdown
            Wrap(
              spacing: 12,
              children: [
                _ratingTag('মালিকের আচরণ', review.landlordRating),
                _ratingTag('ফ্ল্যাটের অবস্থা', review.propertyRating),
                _ratingTag('এলাকার পরিবেশ', review.neighborhoodRating),
              ],
            ),
            const SizedBox(height: 10),

            // Written review
            Text(review.writtenReview, style: AppTextStyles.bodyMedium),

            // Optional Review Photos (Photos only!)
            if (review.photoUrls.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 60,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: review.photoUrls.map((url) {
                    return Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            // Owner reply if exists
            if (review.ownerReply != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8),
                  border: const Border(left: BorderSide(color: AppColors.primary, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'মালিকের জবাব (${review.ownerReply!.ownerName}):',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                    ),
                    const SizedBox(height: 4),
                    Text(review.ownerReply!.replyText, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _ratingTag(String label, double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, size: 14, color: Colors.amber),
        const SizedBox(width: 2),
        Text(
          '$label: ${rating.toStringAsFixed(1)}',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
