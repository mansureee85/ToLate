/// Common reusable input validators.
class InputValidators {
  static String? requiredField(String? value, {String message = 'এই তথ্যটি পূরণ করা আবশ্যক'}) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? message}) {
    if (value == null || value.trim().length < min) {
      return message ?? 'কমপক্ষে $min টি অক্ষর লিখুন';
    }
    return null;
  }

  static String? positiveNumber(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'সংখ্যা লিখুন';
    }
    final numValue = num.tryParse(value.trim());
    if (numValue == null || numValue <= 0) {
      return message ?? 'সঠিক ধনাত্মক সংখ্যা দিন';
    }
    return null;
  }

  static String? emailOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'সঠিক ইমেইল এড্রেস প্রদান করুন';
    }
    return null;
  }
}

