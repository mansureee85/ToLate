import 'package:flutter/foundation.dart';
import '../../platform/android/android_media_picker.dart';
import '../../platform/ios/ios_media_picker.dart';
import '../../platform/web/web_media_picker.dart';

/// Media Source: Camera or Photo Gallery
enum MediaSourceType { camera, gallery }

/// Unified Cross-Platform Picked Media File Representation
class PickedMediaFile {
  final String path;
  final String name;
  final Uint8List bytes;
  final int sizeBytes;
  final String mimeType;

  const PickedMediaFile({
    required this.path,
    required this.name,
    required this.bytes,
    required this.sizeBytes,
    required this.mimeType,
  });

  bool get isUnder5MB => sizeBytes <= 5 * 1024 * 1024;
}

/// Abstract Media Picker Interface implemented per platform
abstract class MediaPicker {
  /// Pick a single image from either Camera or Gallery
  Future<PickedMediaFile?> pickImage({
    required MediaSourceType source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  });

  /// Pick multiple images from Gallery
  Future<List<PickedMediaFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  });

  /// Pick or capture a video
  Future<PickedMediaFile?> pickVideo({
    required MediaSourceType source,
    Duration? maxDuration,
  });
}

/// Returns the platform-specific media picker adapter
MediaPicker getPlatformMediaPicker() {
  if (kIsWeb) {
    return WebMediaPicker();
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return AndroidMediaPicker();
    case TargetPlatform.iOS:
      return IosMediaPicker();
    default:
      return AndroidMediaPicker();
  }
}
