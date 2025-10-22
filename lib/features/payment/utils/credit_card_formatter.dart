import 'package:flutter/services.dart';
// credit_card_formatter.dart
class CreditCardFormatter extends TextInputFormatter {
  static String format(String rawDigits) {
    String clean = rawDigits.replaceAll(RegExp(r'\D'), '');
    if (clean.length > 16) clean = clean.substring(0, 16);

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(clean[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String formatted = format(newValue.text);
    // ... (keep existing cursor logic)
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}