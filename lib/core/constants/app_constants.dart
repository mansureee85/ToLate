/// Core application constants for ToLate Bangladesh Property Marketplace.
class AppConstants {
  static const String appName = 'ToLate';
  static const String appTaglineEn = 'Find & Advertise Homes Across Bangladesh';
  static const String appTaglineBn = 'বাংলাদেশজুড়ে বাসা ভাড়া ও প্রপার্টির সহজ সমাধান';

  static const String currencySymbol = '৳';
  static const String currencyCode = 'BDT';

  // Default Bangladesh Phone prefix
  static const String defaultCountryCode = '+880';
  static const int bdPhoneLength = 10; // without leading 0, e.g. 1712345678

  // OTP constraints
  static const int otpLength = 6;
  static const int otpResendCooldownSeconds = 60;
  static const int maxOtpAttempts = 5;

  // Pagination
  static const int defaultPageSize = 20;

  // Media constraints
  static const int maxPropertyPhotos = 15;
  static const int maxBuildingPhotos = 10;
  static const int maxReviewPhotos = 5;
  static const int maxPropertyVideos = 1;
  static const int maxVideoDurationSeconds = 120; // 2 minutes
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5 MB
  static const int maxVideoSizeBytes = 50 * 1024 * 1024; // 50 MB
}

