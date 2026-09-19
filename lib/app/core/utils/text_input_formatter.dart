import 'package:flutter/services.dart';

class ClassCodeFormatter extends TextInputFormatter {
  final int maxLength;

  ClassCodeFormatter({this.maxLength = 7});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Hilangkan semua karakter non-alphanumeric (spasi, tanda strip/dash, dll.) dan ubah ke uppercase
    String clean =
        newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toUpperCase();

    if (clean.length > maxLength) {
      clean = clean.substring(0, maxLength);
    }

    return TextEditingValue(
      text: clean,
      selection: TextSelection.collapsed(
        offset: clean.length,
      ),
    );
  }
}