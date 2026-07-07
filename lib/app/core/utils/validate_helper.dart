import 'package:flutter/material.dart';

class ValidateHelper {
  // Live Validation (String) buat check input validawsi
  static FormFieldValidator<String> isPasswordValidate() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (value.length < 8) {
        return "Password minimal 8 karakter";
      }

      return null;
    };
  }

  static FormFieldValidator<String> isEmailValidate() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return null;
      }

      if (!value.contains("@") || !value.contains(".com")) {
        return "Email Address tidak valid";
      }

      return null;
    };
  }

  static FormFieldValidator<String> isNormalValidate(String title) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return "$title tidak boleh kosong";
      }

      return null;
    };
  }

  static FormFieldValidator<String> isPasswordConfirmationValidate(
      String Function() secondValue,
      ) {
    return (String? value) {
      if (value != secondValue()) {
        return "Kata sandi tidak sama dengan kata sandi baru";
      }

      return null;
    };
  }

  // Live Validation (bool) buat check

  static bool isPasswordValidateBool(String value) {
    return value.isNotEmpty && value.length >= 8;
  }

  static bool isEmailValidateBool(String value) {
    return value.isNotEmpty && value.contains("@") && value.contains(".com");
  }

  static bool isNormalValidateBool(String value) {
    return value.isNotEmpty;
  }

  static bool isPasswordConfirmationBool(
      String? value,
      String? secondValue,
      ) {
    return value != null &&
        value.isNotEmpty &&
        value == secondValue;
  }
}