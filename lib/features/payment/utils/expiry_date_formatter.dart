import 'package:flutter/services.dart';
// expiry_date_formatter.dart
class ExpiryDateFormatter extends TextInputFormatter {
  static String format(String rawDigits) {
    String clean = rawDigits.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 4) clean = clean.substring(0, 4);

    if (clean.length >= 2) {
      return '${clean.substring(0, 2)}/${clean.substring(2)}';
    }
    return clean;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String formatted = format(newValue.text);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}