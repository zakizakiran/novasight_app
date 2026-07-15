import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ClassCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String input  = newValue.text.replaceAll(RegExp(r'[\s-]'), '');

    final letters = StringBuffer();
    final numbers = StringBuffer();

    for (final ch in input.characters) {
      if (letters.length < 3 && RegExp(r'[A-Za-z]').hasMatch(ch)) {
        letters.write(ch.toUpperCase());
      } else if (letters.length >= 3 && RegExp(r'\d').hasMatch(ch) && numbers.length < 4) {
        numbers.write(ch);
      }
    }

    String formatted = "";

    for (int i = 0; i < letters.length; i++) {
      formatted += letters.toString()[i];
    }

    if (numbers.isNotEmpty) {
      formatted += "-$numbers";
    }



    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: formatted.length,
      ),
    );
  }
}