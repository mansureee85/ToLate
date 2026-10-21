import 'app_error.dart';

/// Centralized mapper from raw exceptions to localized human-readable messages.
class ErrorMapper {
  static String mapToMessage(dynamic error, {bool isBangla = true}) {
    if (error is AppError) {
      return error.message;
    }
    if (error is String) {
      return error;
    }
    return isBangla
        ? 'একটি অপ্রত্যাশিত সমস্যা দেখা দিয়েছে। পুনরায় চেষ্টা করুন।'
        : 'An unexpected error occurred. Please try again.';
  }
}

