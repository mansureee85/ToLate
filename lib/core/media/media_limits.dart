import '../constants/app_constants.dart';

/// Configurable media limits across entities.
class MediaLimits {
  static const int maxImageSize = AppConstants.maxImageSizeBytes; // 5 MB
  static const int maxVideoSize = AppConstants.maxVideoSizeBytes; // 50 MB
  static const int maxVideoDuration = AppConstants.maxVideoDurationSeconds; // 120s

  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const List<String> allowedVideoExtensions = ['mp4', 'mov', 'webm'];
}

