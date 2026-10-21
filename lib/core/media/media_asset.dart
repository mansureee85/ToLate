/// Media types supported by the marketplace.
enum MediaType {
  image,
  video;

  bool get isImage => this == MediaType.image;
  bool get isVideo => this == MediaType.video;
}

/// Verification / review state of media.
enum MediaModerationState {
  pendingUpload,
  uploading,
  uploaded,
  processing,
  pendingReview,
  approved,
  rejected;

  String get labelBn {
    switch (this) {
      case MediaModerationState.pendingUpload:
        return 'আপলোডের অপেক্ষায়';
      case MediaModerationState.uploading:
        return 'আপলোড হচ্ছে...';
      case MediaModerationState.uploaded:
        return 'আপলোড সম্পন্ন';
      case MediaModerationState.processing:
        return 'প্রক্রিয়াধীন';
      case MediaModerationState.pendingReview:
        return 'পর্যালোচনার অপেক্ষায়';
      case MediaModerationState.approved:
        return 'অনুমোদিত';
      case MediaModerationState.rejected:
        return 'বাতিলকৃত';
    }
  }
}

/// Model representing a media asset (photo or walkthrough video).
class MediaAsset {
  final String id;
  final String uploaderUserId;
  final String? buildingId;
  final String? unitId;
  final String? listingId;
  final MediaType mediaType;
  final String localPath;
  final String? remoteStoragePath;
  final String? publicUrl;
  final String? thumbnailUrl;
  final int fileSizeBytes;
  final int? durationSeconds;
  final String? caption;
  final MediaModerationState moderationState;
  final bool isLiveCameraCaptured;
  final DateTime createdAt;

  const MediaAsset({
    required this.id,
    required this.uploaderUserId,
    this.buildingId,
    this.unitId,
    this.listingId,
    required this.mediaType,
    required this.localPath,
    this.remoteStoragePath,
    this.publicUrl,
    this.thumbnailUrl,
    required this.fileSizeBytes,
    this.durationSeconds,
    this.caption,
    this.moderationState = MediaModerationState.pendingUpload,
    this.isLiveCameraCaptured = false,
    required this.createdAt,
  });

  MediaAsset copyWith({
    String? localPath,
    String? remoteStoragePath,
    String? publicUrl,
    String? thumbnailUrl,
    MediaModerationState? moderationState,
    String? caption,
  }) {
    return MediaAsset(
      id: id,
      uploaderUserId: uploaderUserId,
      buildingId: buildingId,
      unitId: unitId,
      listingId: listingId,
      mediaType: mediaType,
      localPath: localPath ?? this.localPath,
      remoteStoragePath: remoteStoragePath ?? this.remoteStoragePath,
      publicUrl: publicUrl ?? this.publicUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      fileSizeBytes: fileSizeBytes,
      durationSeconds: durationSeconds,
      caption: caption ?? this.caption,
      moderationState: moderationState ?? this.moderationState,
      isLiveCameraCaptured: isLiveCameraCaptured,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uploaderUserId': uploaderUserId,
      'buildingId': buildingId,
      'unitId': unitId,
      'listingId': listingId,
      'mediaType': mediaType.name,
      'localPath': localPath,
      'remoteStoragePath': remoteStoragePath,
      'publicUrl': publicUrl,
      'thumbnailUrl': thumbnailUrl,
      'fileSizeBytes': fileSizeBytes,
      'durationSeconds': durationSeconds,
      'caption': caption,
      'moderationState': moderationState.name,
      'isLiveCameraCaptured': isLiveCameraCaptured,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MediaAsset.fromJson(Map<String, dynamic> json) {
    return MediaAsset(
      id: json['id'] as String,
      uploaderUserId: json['uploaderUserId'] as String,
      buildingId: json['buildingId'] as String?,
      unitId: json['unitId'] as String?,
      listingId: json['listingId'] as String?,
      mediaType: MediaType.values.firstWhere(
        (e) => e.name == json['mediaType'],
        orElse: () => MediaType.image,
      ),
      localPath: json['localPath'] as String? ?? '',
      remoteStoragePath: json['remoteStoragePath'] as String?,
      publicUrl: json['publicUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      fileSizeBytes: (json['fileSizeBytes'] as num?)?.toInt() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
      caption: json['caption'] as String?,
      moderationState: MediaModerationState.values.firstWhere(
        (e) => e.name == json['moderationState'],
        orElse: () => MediaModerationState.pendingUpload,
      ),
      isLiveCameraCaptured: json['isLiveCameraCaptured'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
