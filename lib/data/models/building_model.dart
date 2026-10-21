/// Building entity representing an apartment complex, house, or commercial building.
class BuildingModel {
  final String id;
  final String ownerUserId;
  final String? managerUserId;
  final String? buildingName;
  final String division;
  final String district;
  final String upazilaThana;
  final String area;
  final String addressText;
  final double? latitude;
  final double? longitude;
  final bool hideExactCoordinates;
  final int totalFloors;
  final String buildingType; // e.g. Residential, Commercial, Mixed
  final List<String> commonAmenities; // Lift, Generator, Security Guard, CCTV, Parking, Rooftop Garden
  final List<String> photoUrls;
  final String? videoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const BuildingModel({
    required this.id,
    required this.ownerUserId,
    this.managerUserId,
    this.buildingName,
    required this.division,
    required this.district,
    required this.upazilaThana,
    required this.area,
    required this.addressText,
    this.latitude,
    this.longitude,
    this.hideExactCoordinates = true,
    required this.totalFloors,
    this.buildingType = 'Residential',
    this.commonAmenities = const [],
    this.photoUrls = const [],
    this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerUserId': ownerUserId,
      'managerUserId': managerUserId,
      'buildingName': buildingName,
      'division': division,
      'district': district,
      'upazilaThana': upazilaThana,
      'area': area,
      'addressText': addressText,
      'latitude': latitude,
      'longitude': longitude,
      'hideExactCoordinates': hideExactCoordinates,
      'totalFloors': totalFloors,
      'buildingType': buildingType,
      'commonAmenities': commonAmenities,
      'photoUrls': photoUrls,
      'videoUrl': videoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'] as String,
      ownerUserId: json['ownerUserId'] as String,
      managerUserId: json['managerUserId'] as String?,
      buildingName: json['buildingName'] as String?,
      division: json['division'] as String,
      district: json['district'] as String,
      upazilaThana: json['upazilaThana'] as String,
      area: json['area'] as String,
      addressText: json['addressText'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      hideExactCoordinates: json['hideExactCoordinates'] as bool? ?? true,
      totalFloors: (json['totalFloors'] as num?)?.toInt() ?? 1,
      buildingType: json['buildingType'] as String? ?? 'Residential',
      commonAmenities: (json['commonAmenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      photoUrls: (json['photoUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      videoUrl: json['videoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
