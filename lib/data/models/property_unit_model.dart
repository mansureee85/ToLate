import '../../core/constants/property_enums.dart';

/// Represents a distinct unit or flat within a building, or standalone unit.
class PropertyUnitModel {
  final String id;
  final String? buildingId;
  final String? unitNumber; // e.g. "Flat 4A"
  final int? floorNumber;
  final PropertyIntent propertyIntent;
  final int bedrooms;
  final int bathrooms;
  final int balconies;
  final double areaSqFt;
  final double rentOrSalePrice;
  final double? advanceDepositAmount;
  final double? serviceCharge;
  final List<String> unitAmenities; // e.g. Tiled floor, Gas supply, Geyser, Balcony, South facing
  final List<String> photoUrls;
  final String? videoUrl;
  final UnitAvailabilityStatus availabilityStatus;
  final DateTime availableFromDate;
  final String createdByUserId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PropertyUnitModel({
    required this.id,
    this.buildingId,
    this.unitNumber,
    this.floorNumber,
    required this.propertyIntent,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.balconies = 0,
    required this.areaSqFt,
    required this.rentOrSalePrice,
    this.advanceDepositAmount,
    this.serviceCharge,
    this.unitAmenities = const [],
    this.photoUrls = const [],
    this.videoUrl,
    this.availabilityStatus = UnitAvailabilityStatus.available,
    required this.availableFromDate,
    required this.createdByUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  PropertyUnitModel copyWith({
    String? unitNumber,
    int? floorNumber,
    UnitAvailabilityStatus? availabilityStatus,
    double? rentOrSalePrice,
    DateTime? availableFromDate,
    List<String>? photoUrls,
    String? videoUrl,
    DateTime? updatedAt,
  }) {
    return PropertyUnitModel(
      id: id,
      buildingId: buildingId,
      unitNumber: unitNumber ?? this.unitNumber,
      floorNumber: floorNumber ?? this.floorNumber,
      propertyIntent: propertyIntent,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      balconies: balconies,
      areaSqFt: areaSqFt,
      rentOrSalePrice: rentOrSalePrice ?? this.rentOrSalePrice,
      advanceDepositAmount: advanceDepositAmount,
      serviceCharge: serviceCharge,
      unitAmenities: unitAmenities,
      photoUrls: photoUrls ?? this.photoUrls,
      videoUrl: videoUrl ?? this.videoUrl,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availableFromDate: availableFromDate ?? this.availableFromDate,
      createdByUserId: createdByUserId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buildingId': buildingId,
      'unitNumber': unitNumber,
      'floorNumber': floorNumber,
      'propertyIntent': propertyIntent.name,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'balconies': balconies,
      'areaSqFt': areaSqFt,
      'rentOrSalePrice': rentOrSalePrice,
      'advanceDepositAmount': advanceDepositAmount,
      'serviceCharge': serviceCharge,
      'unitAmenities': unitAmenities,
      'photoUrls': photoUrls,
      'videoUrl': videoUrl,
      'availabilityStatus': availabilityStatus.name,
      'availableFromDate': availableFromDate.toIso8601String(),
      'createdByUserId': createdByUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory PropertyUnitModel.fromJson(Map<String, dynamic> json) {
    return PropertyUnitModel(
      id: json['id'] as String,
      buildingId: json['buildingId'] as String?,
      unitNumber: json['unitNumber'] as String?,
      floorNumber: (json['floorNumber'] as num?)?.toInt(),
      propertyIntent: PropertyIntent.values.firstWhere(
        (e) => e.name == json['propertyIntent'],
        orElse: () => PropertyIntent.flatRent,
      ),
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 1,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 1,
      balconies: (json['balconies'] as num?)?.toInt() ?? 0,
      areaSqFt: (json['areaSqFt'] as num?)?.toDouble() ?? 0.0,
      rentOrSalePrice: (json['rentOrSalePrice'] as num?)?.toDouble() ?? 0.0,
      advanceDepositAmount: (json['advanceDepositAmount'] as num?)?.toDouble(),
      serviceCharge: (json['serviceCharge'] as num?)?.toDouble(),
      unitAmenities: (json['unitAmenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: json['videoUrl'] as String?,
      availabilityStatus: UnitAvailabilityStatus.values.firstWhere(
        (e) => e.name == json['availabilityStatus'],
        orElse: () => UnitAvailabilityStatus.available,
      ),
      availableFromDate: DateTime.parse(json['availableFromDate'] as String),
      createdByUserId: json['createdByUserId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
