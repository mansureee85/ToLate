/// Bangladesh Administrative Location models.

class LocationDivision {
  final String id;
  final String nameEn;
  final String nameBn;

  const LocationDivision({
    required this.id,
    required this.nameEn,
    required this.nameBn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nameEn': nameEn,
        'nameBn': nameBn,
      };

  factory LocationDivision.fromJson(Map<String, dynamic> json) =>
      LocationDivision(
        id: json['id'] as String,
        nameEn: json['nameEn'] as String,
        nameBn: json['nameBn'] as String,
      );
}

class LocationDistrict {
  final String id;
  final String divisionId;
  final String nameEn;
  final String nameBn;

  const LocationDistrict({
    required this.id,
    required this.divisionId,
    required this.nameEn,
    required this.nameBn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'divisionId': divisionId,
        'nameEn': nameEn,
        'nameBn': nameBn,
      };

  factory LocationDistrict.fromJson(Map<String, dynamic> json) =>
      LocationDistrict(
        id: json['id'] as String,
        divisionId: json['divisionId'] as String,
        nameEn: json['nameEn'] as String,
        nameBn: json['nameBn'] as String,
      );
}

class LocationUpazilaThana {
  final String id;
  final String districtId;
  final String nameEn;
  final String nameBn;

  const LocationUpazilaThana({
    required this.id,
    required this.districtId,
    required this.nameEn,
    required this.nameBn,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'districtId': districtId,
        'nameEn': nameEn,
        'nameBn': nameBn,
      };

  factory LocationUpazilaThana.fromJson(Map<String, dynamic> json) =>
      LocationUpazilaThana(
        id: json['id'] as String,
        districtId: json['districtId'] as String,
        nameEn: json['nameEn'] as String,
        nameBn: json['nameBn'] as String,
      );
}

class CanonicalArea {
  final String id;
  final String upazilaThanaId;
  final String nameEn;
  final String nameBn;
  final List<String> aliases;

  const CanonicalArea({
    required this.id,
    required this.upazilaThanaId,
    required this.nameEn,
    required this.nameBn,
    this.aliases = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'upazilaThanaId': upazilaThanaId,
        'nameEn': nameEn,
        'nameBn': nameBn,
        'aliases': aliases,
      };

  factory CanonicalArea.fromJson(Map<String, dynamic> json) => CanonicalArea(
        id: json['id'] as String,
        upazilaThanaId: json['upazilaThanaId'] as String,
        nameEn: json['nameEn'] as String,
        nameBn: json['nameBn'] as String,
        aliases: (json['aliases'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
}

enum ProposedAreaStatus { pending, approved, rejected, merged }

/// Area proposed by user when locality was not found in database.
class ProposedArea {
  final String id;
  final String typedName;
  final String normalizedName;
  final String division;
  final String district;
  final String upazilaThana;
  final String submittedByUserId;
  final ProposedAreaStatus status;
  final String? moderatorUserId;
  final String? rejectionOrMergeReason;
  final DateTime createdAt;

  const ProposedArea({
    required this.id,
    required this.typedName,
    required this.normalizedName,
    required this.division,
    required this.district,
    required this.upazilaThana,
    required this.submittedByUserId,
    this.status = ProposedAreaStatus.pending,
    this.moderatorUserId,
    this.rejectionOrMergeReason,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'typedName': typedName,
        'normalizedName': normalizedName,
        'division': division,
        'district': district,
        'upazilaThana': upazilaThana,
        'submittedByUserId': submittedByUserId,
        'status': status.name,
        'moderatorUserId': moderatorUserId,
        'rejectionOrMergeReason': rejectionOrMergeReason,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ProposedArea.fromJson(Map<String, dynamic> json) => ProposedArea(
        id: json['id'] as String,
        typedName: json['typedName'] as String,
        normalizedName: json['normalizedName'] as String,
        division: json['division'] as String,
        district: json['district'] as String,
        upazilaThana: json['upazilaThana'] as String,
        submittedByUserId: json['submittedByUserId'] as String,
        status: ProposedAreaStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ProposedAreaStatus.pending,
        ),
        moderatorUserId: json['moderatorUserId'] as String?,
        rejectionOrMergeReason: json['rejectionOrMergeReason'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

