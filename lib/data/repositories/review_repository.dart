import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../core/errors/app_error.dart';
import '../models/review_model.dart';

/// Repository for Tenant Reviews and Verification.
class ReviewRepository extends ChangeNotifier {
  final List<ReviewModel> _reviews = [];

  List<ReviewModel> get reviews => List.unmodifiable(_reviews);

  List<ReviewModel> getReviewsForProperty({String? buildingId, String? unitId}) {
    return _reviews.where((r) {
      if (unitId != null && r.unitId == unitId) return true;
      if (buildingId != null && r.buildingId == buildingId) return true;
      return false;
    }).toList();
  }

  /// Submits a new tenant review.
  /// RULE: strictly rejects videos.
  Future<ReviewModel> submitReview({
    required String authorUserId,
    required String authorDisplayName,
    String? authorAvatarUrl,
    String? buildingId,
    String? unitId,
    String? landlordUserId,
    required double landlordRating,
    required double propertyRating,
    required double neighborhoodRating,
    required String writtenReview,
    List<String> photoUrls = const [],
    int tenancyDurationMonths = 12,
    String? moveOutReason,
    bool wouldRentAgain = true,
  }) async {
    if (writtenReview.trim().length < 10) {
      throw const ValidationError('অনুগ্রহ করে কমপক্ষে ১০ অক্ষরের রিভিউ লিখুন।');
    }

    final review = ReviewModel(
      id: const Uuid().v4(),
      authorUserId: authorUserId,
      authorDisplayName: authorDisplayName,
      authorAvatarUrl: authorAvatarUrl,
      buildingId: buildingId,
      unitId: unitId,
      landlordUserId: landlordUserId,
      landlordRating: landlordRating,
      propertyRating: propertyRating,
      neighborhoodRating: neighborhoodRating,
      writtenReview: writtenReview.trim(),
      photoUrls: photoUrls,
      tenancyDurationMonths: tenancyDurationMonths,
      moveOutReason: moveOutReason,
      wouldRentAgain: wouldRentAgain,
      verificationStatus: ReviewVerificationStatus.unverified,
      createdAt: DateTime.now(),
    );

    _reviews.add(review);
    notifyListeners();
    return review;
  }

  /// Landlord/Owner reply to a review.
  Future<void> replyToReview({
    required String reviewId,
    required String ownerUserId,
    required String ownerName,
    required String replyText,
  }) async {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final reply = OwnerReviewReply(
        ownerUserId: ownerUserId,
        ownerName: ownerName,
        replyText: replyText.trim(),
        repliedAt: DateTime.now(),
      );

      final old = _reviews[index];
      _reviews[index] = ReviewModel(
        id: old.id,
        authorUserId: old.authorUserId,
        authorDisplayName: old.authorDisplayName,
        authorAvatarUrl: old.authorAvatarUrl,
        buildingId: old.buildingId,
        unitId: old.unitId,
        landlordUserId: old.landlordUserId,
        landlordRating: old.landlordRating,
        propertyRating: old.propertyRating,
        neighborhoodRating: old.neighborhoodRating,
        writtenReview: old.writtenReview,
        photoUrls: old.photoUrls,
        tenancyDurationMonths: old.tenancyDurationMonths,
        moveOutReason: old.moveOutReason,
        wouldRentAgain: old.wouldRentAgain,
        verificationStatus: old.verificationStatus,
        ownerReply: reply,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }

  /// Admin workflow to verify tenancy proof.
  Future<void> updateReviewVerification({
    required String reviewId,
    required ReviewVerificationStatus status,
  }) async {
    final index = _reviews.indexWhere((r) => r.id == reviewId);
    if (index != -1) {
      final old = _reviews[index];
      _reviews[index] = ReviewModel(
        id: old.id,
        authorUserId: old.authorUserId,
        authorDisplayName: old.authorDisplayName,
        authorAvatarUrl: old.authorAvatarUrl,
        buildingId: old.buildingId,
        unitId: old.unitId,
        landlordUserId: old.landlordUserId,
        landlordRating: old.landlordRating,
        propertyRating: old.propertyRating,
        neighborhoodRating: old.neighborhoodRating,
        writtenReview: old.writtenReview,
        photoUrls: old.photoUrls,
        tenancyDurationMonths: old.tenancyDurationMonths,
        moveOutReason: old.moveOutReason,
        wouldRentAgain: old.wouldRentAgain,
        verificationStatus: status,
        ownerReply: old.ownerReply,
        createdAt: old.createdAt,
      );
      notifyListeners();
    }
  }
}
