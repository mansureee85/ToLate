import '../../core/constants/property_enums.dart';

/// Comprehensive property listing model.
class PropertyListingModel {
  final String id;
  final String? buildingId;
  final String? unitId;
  final String ownerUserId;
  final String? agentUserId;
  final PropertyIntent propertyIntent;
  final String? otherCategoryName; // If intent == other

  // Content
  final String title;
  final String description;

  // Administrative Location
  final String division;
  final String district;
  final String upazilaThana;
  final String area;
  final String addressText;
  final double? latitude;
  final double? longitude;
  final bool hideExactLocation;

  // Pricing & Terms
  final double price; // Rent per month or Total Sale price
  final double? advanceDeposit;
  final double? serviceCharge;
  final bool isPriceNegotiable;

  // Specs
  final int bedrooms;
  final int bathrooms;
  final int balconies;
  final double areaSqFt;
  final int? floorNumber;
  final int? totalBuildingFloors;
  final LandMeasurementUnit? landUnit;
  final double? landQuantity;

  // Amenities
  final List<String> amenities;

  // Media
  final List<String> photoUrls;
  final String? videoUrl;

  // Status & Verification
  final ListingStatus status;
  final String? rejectionReason;
  final List<VerificationBadgeType> verificationBadges;

  // Freshness & Tracking (Real counts only)
  final int viewCount;
  final int inquiryCount;
  final int favoriteCount;
  final DateTime? publishedAt;
  final DateTime lastConfirmedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PropertyListingModel({
    required this.id,
    this.buildingId,
    this.unitId,
    required this.ownerUserId,
    this.agentUserId,
    required this.propertyIntent,
    this.otherCategoryName,
    required this.title,
    required this.description,
    required this.division,
    required this.district,
    required this.upazilaThana,
    required this.area,
    required this.addressText,
    this.latitude,
    this.longitude,
    this.hideExactLocation = true,
    required this.price,
    this.advanceDeposit,
    this.serviceCharge,
    this.isPriceNegotiable = false,
    this.bedrooms = 0,
    this.bathrooms = 0,
    this.balconies = 0,
    this.areaSqFt = 0.0,
    this.floorNumber,
    this.totalBuildingFloors,
    this.landUnit,
    this.landQuantity,
    this.amenities = const [],
    this.photoUrls = const [],
    this.videoUrl,
    this.status = ListingStatus.draft,
    this.rejectionReason,
    this.verificationBadges = const [],
    this.viewCount = 0,
    this.inquiryCount = 0,
    this.favoriteCount = 0,
    this.publishedAt,
    required this.lastConfirmedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPublished => status == ListingStatus.published;

  PropertyListingModel copyWith({
    String? title,
    String? description,
    ListingStatus? status,
    String? rejectionReason,
    List<VerificationBadgeType>? verificationBadges,
    int? viewCount,
    int? inquiryCount,
    int? favoriteCount,
    DateTime? publishedAt,
    DateTime? lastConfirmedAt,
    DateTime? updatedAt,
  }) {
    return PropertyListingModel(
      id: id,
      buildingId: buildingId,
      unitId: unitId,
      ownerUserId: ownerUserId,
      agentUserId: agentUserId,
      propertyIntent: propertyIntent,
      otherCategoryName: otherCategoryName,
      title: title ?? this.title,
      description: description ?? this.description,
      division: division,
      district: district,
      upazilaThana: upazilaThana,
      area: area,
      addressText: addressText,
      latitude: latitude,
      longitude: longitude,
      hideExactLocation: hideExactLocation,
      price: price,
      advanceDeposit: advanceDeposit,
      serviceCharge: serviceCharge,
      isPriceNegotiable: isPriceNegotiable,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      balconies: balconies,
      areaSqFt: areaSqFt,
      floorNumber: floorNumber,
      totalBuildingFloors: totalBuildingFloors,
      landUnit: landUnit,
      landQuantity: landQuantity,
      amenities: amenities,
      photoUrls: photoUrls,
      videoUrl: videoUrl,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      verificationBadges: verificationBadges ?? this.verificationBadges,
      viewCount: viewCount ?? this.viewCount,
      inquiryCount: inquiryCount ?? this.inquiryCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      publishedAt: publishedAt ?? this.publishedAt,
      lastConfirmedAt: lastConfirmedAt ?? this.lastConfirmedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buildingId': buildingId,
      'unitId': unitId,
      'ownerUserId': ownerUserId,
      'agentUserId': agentUserId,
      'propertyIntent': propertyIntent.name,
      'otherCategoryName': otherCategoryName,
      'title': title,
      'description': description,
      'division': division,
      'district': district,
      'upazilaThana': upazilaThana,
      'area': area,
      'addressText': addressText,
      'latitude': latitude,
      'longitude': longitude,
      'hideExactLocation': hideExactLocation,
      'price': price,
      'advanceDeposit': advanceDeposit,
      'serviceCharge': serviceCharge,
      'isPriceNegotiable': isPriceNegotiable,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'balconies': balconies,
      'areaSqFt': areaSqFt,
      'floorNumber': floorNumber,
      'totalBuildingFloors': totalBuildingFloors,
      'landUnit': landUnit?.name,
      'landQuantity': landQuantity,
      'amenities': amenities,
      'photoUrls': photoUrls,
      'videoUrl': videoUrl,
      'status': status.name,
      'rejectionReason': rejectionReason,
      'verificationBadges': verificationBadges.map((e) => e.name).toList(),
      'viewCount': viewCount,
      'inquiryCount': inquiryCount,
      'favoriteCount': favoriteCount,
      'publishedAt': publishedAt?.toIso8601String(),
      'lastConfirmedAt': lastConfirmedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PropertyListingModel.fromJson(Map<String, dynamic> json) {
    return PropertyListingModel(
      id: json['id'] as String,
      buildingId: json['buildingId'] as String?,
      unitId: json['unitId'] as String?,
      ownerUserId: json['ownerUserId'] as String,
      agentUserId: json['agentUserId'] as String?,
      propertyIntent: PropertyIntent.values.firstWhere(
        (e) => e.name == json['propertyIntent'],
        orElse: () => PropertyIntent.flatRent,
      ),
      otherCategoryName: json['otherCategoryName'] as String?,
      title: json['title'] as String,
      description: json['description'] as String,
      division: json['division'] as String,
      district: json['district'] as String,
      upazilaThana: json['upazilaThana'] as String,
      area: json['area'] as String,
      addressText: json['addressText'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      hideExactLocation: json['hideExactLocation'] as bool? ?? true,
      price: (json['price'] as num).toDouble(),
      advanceDeposit: (json['advanceDeposit'] as num?)?.toDouble(),
      serviceCharge: (json['serviceCharge'] as num?)?.toDouble(),
      isPriceNegotiable: json['isPriceNegotiable'] as bool? ?? false,
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      balconies: (json['balconies'] as num?)?.toInt() ?? 0,
      areaSqFt: (json['areaSqFt'] as num?)?.toDouble() ?? 0.0,
      floorNumber: (json['floorNumber'] as num?)?.toInt(),
      totalBuildingFloors: (json['totalBuildingFloors'] as num?)?.toInt(),
      landUnit: json['landUnit'] != null
          ? LandMeasurementUnit.values.firstWhere(
              (e) => e.name == json['landUnit'],
              orElse: () => LandMeasurementUnit.shotok,
            )
          : null,
      landQuantity: (json['landQuantity'] as num?)?.toDouble(),
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: json['videoUrl'] as String?,
      status: ListingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ListingStatus.draft,
      ),
      rejectionReason: json['rejectionReason'] as String?,
      verificationBadges: (json['verificationBadges'] as List<dynamic>?)
              ?.map((e) => VerificationBadgeType.values.firstWhere(
                    (b) => b.name == e,
                    orElse: () => VerificationBadgeType.phoneVerified,
                  ))
              .toList() ??
          [],
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      inquiryCount: (json['inquiryCount'] as num?)?.toInt() ?? 0,
      favoriteCount: (json['favoriteCount'] as num?)?.toInt() ?? 0,
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'] as String)
          : null,
      lastConfirmedAt: DateTime.parse(json['lastConfirmedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
