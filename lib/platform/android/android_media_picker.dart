import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/errors/app_error.dart';
import '../../core/media/media_limits.dart';
import '../../core/media/media_picker.dart';

/// Android Platform Media Picker Adapter
/// Uses Android Intent with MediaStore and native Photo Picker
class AndroidMediaPicker implements MediaPicker {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<PickedMediaFile?> pickImage({
    required MediaSourceType source,
    double? maxWidth = 1920,
    double? maxHeight = 1080,
    int? imageQuality = 85,
  }) async {
    try {
      final imageSource = source == MediaSourceType.camera
          ? ImageSource.camera
          : ImageSource.gallery;

      final XFile? file = await _picker.pickImage(
        source: imageSource,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (file == null) return null;

      final bytes = await file.readAsBytes();
      if (bytes.length > MediaLimits.maxImageSize) {
        throw const ValidationError('ছবির সাইজ সর্বোচ্চ ৫ মেগাবাইট (5 MB) হতে পারবে।');
      }

      return PickedMediaFile(
        path: file.path,
        name: file.name,
        bytes: bytes,
        sizeBytes: bytes.length,
        mimeType: file.mimeType ?? 'image/jpeg',
      );
    } catch (e) {
      if (e is AppError) rethrow;
      debugPrint('[AndroidMediaPicker] Image selection error: $e');
      throw MediaUploadError('অ্যান্ড্রয়েডে ছবি নির্বাচন করতে সমস্যা হয়েছে: ${e.toString()}');
    }
  }

  @override
  Future<List<PickedMediaFile>> pickMultiImage({
    double? maxWidth = 1920,
    double? maxHeight = 1080,
    int? imageQuality = 85,
  }) async {
    try {
      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      final List<PickedMediaFile> results = [];
      for (final file in files) {
        final bytes = await file.readAsBytes();
        if (bytes.length <= MediaLimits.maxImageSize) {
          results.add(PickedMediaFile(
            path: file.path,
            name: file.name,
            bytes: bytes,
            sizeBytes: bytes.length,
            mimeType: file.mimeType ?? 'image/jpeg',
          ));
        }
      }
      return results;
    } catch (e) {
      debugPrint('[AndroidMediaPicker] Multi-image error: $e');
      return [];
    }
  }

  @override
  Future<PickedMediaFile?> pickVideo({
    required MediaSourceType source,
    Duration? maxDuration,
  }) async {
    try {
      final imageSource = source == MediaSourceType.camera
          ? ImageSource.camera
          : ImageSource.gallery;

      final XFile? file = await _picker.pickVideo(
        source: imageSource,
        maxDuration: maxDuration ?? const Duration(seconds: 120),
      );

      if (file == null) return null;

      final bytes = await file.readAsBytes();
      if (bytes.length > MediaLimits.maxVideoSize) {
        throw const ValidationError('ভিডিওর সাইজ সর্বোচ্চ ৫০ মেগাবাইট (50 MB) হতে পারবে।');
      }

      return PickedMediaFile(
        path: file.path,
        name: file.name,
        bytes: bytes,
        sizeBytes: bytes.length,
        mimeType: file.mimeType ?? 'video/mp4',
      );
    } catch (e) {
      if (e is AppError) rethrow;
      throw MediaUploadError('ভিডিও নির্বাচন ব্যর্থ হয়েছে: ${e.toString()}');
    }
  }
}
