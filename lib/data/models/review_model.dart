/// Verification status of a tenant review.
enum ReviewVerificationStatus {
  unverified,
  underReview,
  verified,
  rejected,
  disputed;

  String get labelEn {
    switch (this) {
      case ReviewVerificationStatus.unverified:
        return 'Unverified Review';
      case ReviewVerificationStatus.underReview:
        return 'Under Tenancy Review';
      case ReviewVerificationStatus.verified:
        return 'Verified Tenant Review';
      case ReviewVerificationStatus.rejected:
        return 'Rejected';
      case ReviewVerificationStatus.disputed:
        return 'Disputed by Owner';
    }
  }

  String get labelBn {
    switch (this) {
      case ReviewVerificationStatus.unverified:
        return 'যাচাইবিহীন রিভিউ';
      case ReviewVerificationStatus.underReview:
        return 'ভাড়াটিয়া যাচাই চলছে';
      case ReviewVerificationStatus.verified:
        return 'যাচাইকৃত ভাড়াটিয়া রিভিউ';
      case ReviewVerificationStatus.rejected:
        return 'প্রত্যাখ্যাত';
      case ReviewVerificationStatus.disputed:
        return 'আপত্তিকৃত';
    }
  }
}

/// Reply from landlord/owner to a tenant review.
class OwnerReviewReply {
  final String ownerUserId;
  final String ownerName;
  final String replyText;
  final DateTime repliedAt;

  const OwnerReviewReply({
    required this.ownerUserId,
    required this.ownerName,
    required this.replyText,
    required this.repliedAt,
  });

  Map<String, dynamic> toJson() => {
        'ownerUserId': ownerUserId,
        'ownerName': ownerName,
        'replyText': replyText,
        'repliedAt': repliedAt.toIso8601String(),
      };

  factory OwnerReviewReply.fromJson(Map<String, dynamic> json) =>
      OwnerReviewReply(
        ownerUserId: json['ownerUserId'] as String,
        ownerName: json['ownerName'] as String,
        replyText: json['replyText'] as String,
        repliedAt: DateTime.parse(json['repliedAt'] as String),
      );
}

/// Tenant Review model with multi-dimensional ratings.
/// NOTE: Reviews support photos only. Video is strictly disallowed.
class ReviewModel {
  final String id;
  final String authorUserId;
  final String authorDisplayName;
  final String? authorAvatarUrl;
  final String? buildingId;
  final String? unitId;
  final String? landlordUserId;

  // Separate dimensional ratings
  final double landlordRating;
  final double propertyRating;
  final double neighborhoodRating;

  final String writtenReview;
  final List<String> photoUrls; // Strictly photos only!
  final int tenancyDurationMonths;
  final String? moveOutReason;
  final bool wouldRentAgain;

  final ReviewVerificationStatus verificationStatus;
  final OwnerReviewReply? ownerReply;
  final DateTime createdAt;

  const ReviewModel({
    required this.id,
    required this.authorUserId,
    required this.authorDisplayName,
    this.authorAvatarUrl,
    this.buildingId,
    this.unitId,
    this.landlordUserId,
    required this.landlordRating,
    required this.propertyRating,
    required this.neighborhoodRating,
    required this.writtenReview,
    this.photoUrls = const [],
    this.tenancyDurationMonths = 12,
    this.moveOutReason,
    this.wouldRentAgain = true,
    this.verificationStatus = ReviewVerificationStatus.unverified,
    this.ownerReply,
    required this.createdAt,
  });

  double get overallRating =>
      (landlordRating + propertyRating + neighborhoodRating) / 3.0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'authorUserId': authorUserId,
        'authorDisplayName': authorDisplayName,
        'authorAvatarUrl': authorAvatarUrl,
        'buildingId': buildingId,
        'unitId': unitId,
        'landlordUserId': landlordUserId,
        'landlordRating': landlordRating,
        'propertyRating': propertyRating,
        'neighborhoodRating': neighborhoodRating,
        'writtenReview': writtenReview,
        'photoUrls': photoUrls,
        'tenancyDurationMonths': tenancyDurationMonths,
        'moveOutReason': moveOutReason,
        'wouldRentAgain': wouldRentAgain,
        'verificationStatus': verificationStatus.name,
        'ownerReply': ownerReply?.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        id: json['id'] as String,
        authorUserId: json['authorUserId'] as String,
        authorDisplayName: json['authorDisplayName'] as String,
        authorAvatarUrl: json['authorAvatarUrl'] as String?,
        buildingId: json['buildingId'] as String?,
        unitId: json['unitId'] as String?,
        landlordUserId: json['landlordUserId'] as String?,
        landlordRating: (json['landlordRating'] as num).toDouble(),
        propertyRating: (json['propertyRating'] as num).toDouble(),
        neighborhoodRating: (json['neighborhoodRating'] as num).toDouble(),
        writtenReview: json['writtenReview'] as String,
        photoUrls: (json['photoUrls'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        tenancyDurationMonths:
            (json['tenancyDurationMonths'] as num?)?.toInt() ?? 12,
        moveOutReason: json['moveOutReason'] as String?,
        wouldRentAgain: json['wouldRentAgain'] as bool? ?? true,
        verificationStatus: ReviewVerificationStatus.values.firstWhere(
          (e) => e.name == json['verificationStatus'],
          orElse: () => ReviewVerificationStatus.unverified,
        ),
        ownerReply: json['ownerReply'] != null
            ? OwnerReviewReply.fromJson(
                json['ownerReply'] as Map<String, dynamic>)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

