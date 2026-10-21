import '../errors/app_error.dart';
import 'media_asset.dart';
import 'media_limits.dart';

/// Validator for uploaded media assets.
class MediaValidation {
  /// Validates property advertisement media (allows photos and video)
  static void validatePropertyMedia({
    required MediaType type,
    required String fileName,
    required int fileSizeBytes,
    int? durationSeconds,
  }) {
    final ext = fileName.split('.').last.toLowerCase();

    if (type == MediaType.image) {
      if (!MediaLimits.allowedImageExtensions.contains(ext)) {
        throw MediaUploadError(
          'ছবিটি অনুমোদিত ফরম্যাটে নেই। কেবল JPG, PNG, WEBP গ্রহণযোগ্য।',
        );
      }
      if (fileSizeBytes > MediaLimits.maxImageSize) {
        throw const MediaUploadError('ছবির সাইজ সর্বোচ্চ ৫ মেগাবাইট হতে পারবে।');
      }
    } else if (type == MediaType.video) {
      if (!MediaLimits.allowedVideoExtensions.contains(ext)) {
        throw MediaUploadError(
          'ভিডিওটি অনুমোদিত ফরম্যাটে নেই। কেবল MP4, MOV, WEBM গ্রহণযোগ্য।',
        );
      }
      if (fileSizeBytes > MediaLimits.maxVideoSize) {
        throw const MediaUploadError('ভিডিওর সাইজ সর্বোচ্চ ৫০ মেগাবাইট হতে পারবে।');
      }
      if (durationSeconds != null && durationSeconds > MediaLimits.maxVideoDuration) {
        throw const MediaUploadError('ভিডিও সর্বোচ্চ ২ মিনিট দৈর্ঘ্যের হতে পারবে।');
      }
    }
  }

  /// Validates tenant review media.
  /// RULE: Review media strictly rejects video.
  static void validateReviewMedia({
    required MediaType type,
    required String fileName,
    required int fileSizeBytes,
  }) {
    if (type == MediaType.video) {
      throw const MediaUploadError(
        'রিভিউতে ভিডিও আপলোড অনুমোদিত নয়। কেবল ছবি যুক্ত করতে পারবেন।',
      );
    }
    validatePropertyMedia(
      type: MediaType.image,
      fileName: fileName,
      fileSizeBytes: fileSizeBytes,
    );
  }
}

