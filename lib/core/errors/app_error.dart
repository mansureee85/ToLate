/// Structured domain error hierarchy.
abstract class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppError(this.message, {this.code, this.details});

  @override
  String toString() => 'AppError[$code]: $message';
}

class NetworkError extends AppError {
  const NetworkError([String message = 'ইন্টারনেট সংযোগ বিচ্ছিন্ন। অনুগ্রহ করে নেটওয়ার্ক পরীক্ষা করুন।'])
      : super(message, code: 'NETWORK_ERROR');
}

class ValidationError extends AppError {
  const ValidationError(super.message, {super.details})
      : super(code: 'VALIDATION_ERROR');
}

class AuthError extends AppError {
  const AuthError(super.message, {super.code = 'AUTH_ERROR'});
}

class PermissionDeniedError extends AppError {
  const PermissionDeniedError([String message = 'আপনার এই কাজের অনুমতি নেই।'])
      : super(message, code: 'PERMISSION_DENIED');
}

class MediaUploadError extends AppError {
  const MediaUploadError(super.message, {super.code = 'MEDIA_ERROR'});
}

class ServerError extends AppError {
  const ServerError([String message = 'সার্ভারে সাময়িক সমস্যা হচ্ছে। কিছুক্ষণ পর আবার চেষ্টা করুন।'])
      : super(message, code: 'SERVER_ERROR');
}
