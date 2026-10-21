import 'package:uuid/uuid.dart';
import '../core/media/media_asset.dart';
import '../core/media/media_picker.dart';

/// Platform-agnostic interface for media picking (Camera, Gallery, File).
abstract class PlatformMediaPicker {
  Future<List<MediaAsset>> pickImages({
    required String uploaderUserId,
    bool allowMultiple = true,
  });

  Future<MediaAsset?> pickVideo({
    required String uploaderUserId,
  });

  Future<MediaAsset?> captureCameraImage({
    required String uploaderUserId,
  });
}

/// Factory selector returning the real platform adapter without dummy data.
class PlatformAdapterFactory {
  static PlatformMediaPicker getMediaPicker() {
    return RealPlatformMediaPicker();
  }
}

/// Real implementation connecting PlatformMediaPicker with MediaPicker adapters
class RealPlatformMediaPicker implements PlatformMediaPicker {
  final MediaPicker _delegate = getPlatformMediaPicker();

  @override
  Future<List<MediaAsset>> pickImages({
    required String uploaderUserId,
    bool allowMultiple = true,
  }) async {
    if (allowMultiple) {
      final pickedFiles = await _delegate.pickMultiImage();
      return pickedFiles.map((file) {
        return MediaAsset(
          id: const Uuid().v4(),
          uploaderUserId: uploaderUserId,
          mediaType: MediaType.image,
          localPath: file.path,
          publicUrl: null, // Will be set only after real upload to Firebase Storage
          fileSizeBytes: file.sizeBytes,
          moderationState: MediaModerationState.pendingUpload,
          createdAt: DateTime.now(),
        );
      }).toList();
    } else {
      final file = await _delegate.pickImage(source: MediaSourceType.gallery);
      if (file == null) return [];
      return [
        MediaAsset(
          id: const Uuid().v4(),
          uploaderUserId: uploaderUserId,
          mediaType: MediaType.image,
          localPath: file.path,
          publicUrl: null,
          fileSizeBytes: file.sizeBytes,
          moderationState: MediaModerationState.pendingUpload,
          createdAt: DateTime.now(),
        )
      ];
    }
  }

  @override
  Future<MediaAsset?> pickVideo({required String uploaderUserId}) async {
    final file = await _delegate.pickVideo(source: MediaSourceType.gallery);
    if (file == null) return null;

    return MediaAsset(
      id: const Uuid().v4(),
      uploaderUserId: uploaderUserId,
      mediaType: MediaType.video,
      localPath: file.path,
      publicUrl: null,
      fileSizeBytes: file.sizeBytes,
      moderationState: MediaModerationState.pendingUpload,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<MediaAsset?> captureCameraImage({required String uploaderUserId}) async {
    final file = await _delegate.pickImage(source: MediaSourceType.camera);
    if (file == null) return null;

    return MediaAsset(
      id: const Uuid().v4(),
      uploaderUserId: uploaderUserId,
      mediaType: MediaType.image,
      localPath: file.path,
      publicUrl: null,
      fileSizeBytes: file.sizeBytes,
      isLiveCameraCaptured: true,
      moderationState: MediaModerationState.pendingUpload,
      createdAt: DateTime.now(),
    );
  }
}
