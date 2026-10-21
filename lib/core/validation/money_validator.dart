import 'package:intl/intl.dart';

/// Validator and formatter for Bangladesh Taka (BDT ৳).
class MoneyValidator {
  static final NumberFormat _bdCurrencyFormat = NumberFormat('#,##,##0', 'en_US');

  static bool isValidAmount(String? text) {
    if (text == null || text.trim().isEmpty) return false;
    final clean = text.replaceAll(',', '').replaceAll('৳', '').trim();
    final value = double.tryParse(clean);
    return value != null && value >= 0;
  }

  static double? parseAmount(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    final clean = text.replaceAll(',', '').replaceAll('৳', '').trim();
    return double.tryParse(clean);
  }

  /// Formats amount into standard South Asian grouping (lakh/crore): ৳ 1,50,000
  static String formatBdt(num amount, {bool includeSymbol = true}) {
    final formatted = _bdCurrencyFormat.format(amount);
    return includeSymbol ? '৳ $formatted' : formatted;
  }

  /// Bangla digit conversion
  static String toBanglaDigits(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const bangla = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    var result = input;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], bangla[i]);
    }
    return result;
  }
}

