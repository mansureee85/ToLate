/// Categories for reporting abuse or fraud.
enum ReportCategory {
  fakePhoto,
  wrongPrice,
  wrongLocation,
  alreadyRentedOrSold,
  fraudScam,
  abusiveLanguage,
  privacyViolation,
  copyright,
  other;

  String get labelBn {
    switch (this) {
      case ReportCategory.fakePhoto:
        return 'ভুয়া বা অন্যের ছবি';
      case ReportCategory.wrongPrice:
        return 'ভুল অথবা অতিরিক্ত গোপন ভাড়া';
      case ReportCategory.wrongLocation:
        return 'ভুল লোকেশন বা ঠিকানা';
      case ReportCategory.alreadyRentedOrSold:
        return 'ইতোমধ্যে ভাড়া বা বিক্রি হয়ে গেছে';
      case ReportCategory.fraudScam:
        return 'প্রতারণা / অগ্রিম টাকা দাবি';
      case ReportCategory.abusiveLanguage:
        return 'অশোভন বা আপত্তিকর ভাষা';
      case ReportCategory.privacyViolation:
        return 'ব্যক্তিগত তথ্যের অপব্যবহার';
      case ReportCategory.copyright:
        return 'কপিরাইট লঙ্ঘন';
      case ReportCategory.other:
        return 'অন্যান্য কারণ';
    }
  }
}

enum ReportStatus { pending, underInvestigation, resolved, dismissed }

/// Fraud and content complaint report model.
class ReportModel {
  final String id;
  final String reporterUserId;
  final String targetType; // 'listing', 'comment', 'review', 'user'
  final String targetId;
  final ReportCategory category;
  final String description;
  final ReportStatus status;
  final String? moderatorUserId;
  final String? internalModeratorNotes;
  final DateTime createdAt;

  const ReportModel({
    required this.id,
    required this.reporterUserId,
    required this.targetType,
    required this.targetId,
    required this.category,
    required this.description,
    this.status = ReportStatus.pending,
    this.moderatorUserId,
    this.internalModeratorNotes,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'reporterUserId': reporterUserId,
        'targetType': targetType,
        'targetId': targetId,
        'category': category.name,
        'description': description,
        'status': status.name,
        'moderatorUserId': moderatorUserId,
        'internalModeratorNotes': internalModeratorNotes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        id: json['id'] as String,
        reporterUserId: json['reporterUserId'] as String,
        targetType: json['targetType'] as String,
        targetId: json['targetId'] as String,
        category: ReportCategory.values.firstWhere(
          (e) => e.name == json['category'],
          orElse: () => ReportCategory.other,
        ),
        description: json['description'] as String,
        status: ReportStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ReportStatus.pending,
        ),
        moderatorUserId: json['moderatorUserId'] as String?,
        internalModeratorNotes: json['internalModeratorNotes'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
