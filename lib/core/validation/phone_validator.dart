/// Validator and normalizer for Bangladesh mobile phone numbers.
class PhoneValidator {
  // Regex for Bangladesh phone numbers:
  // Allows formats: 01712345678, +8801712345678, 8801712345678, or 1712345678
  static final RegExp _bdPhoneRegex = RegExp(r'^(?:\+?880|0)?(1[3-9]\d{8})$');

  static bool isValidBdPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return false;
    final clean = phone.replaceAll(RegExp(r'[\s\-]'), '');
    return _bdPhoneRegex.hasMatch(clean);
  }

  /// Normalizes to standard E.164 format: +8801XXXXXXXXX
  static String? normalizeBdPhone(String? phone) {
    if (phone == null) return null;
    final clean = phone.replaceAll(RegExp(r'[\s\-]'), '');
    final match = _bdPhoneRegex.firstMatch(clean);
    if (match != null && match.groupCount >= 1) {
      final nationalPart = match.group(1);
      return '+880$nationalPart';
    }
    return null;
  }

  /// Formats for display: 01712-345678
  static String formatForDisplay(String? phone) {
    if (phone == null) return '';
    final normalized = normalizeBdPhone(phone);
    if (normalized == null || normalized.length < 14) return phone;
    // +8801712345678 -> 01712-345678
    final raw11 = '0${normalized.substring(4)}';
    if (raw11.length == 11) {
      return '${raw11.substring(0, 5)}-${raw11.substring(5)}';
    }
    return normalized;
  }
}
