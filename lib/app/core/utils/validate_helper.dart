import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

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
      String secondValue,
      ) {
    return (String? value) {
      if (value != secondValue) {
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

//   Percantage
  static double passwordToPercentage(
      String value
      ){
    if(value.isEmpty){
      return 0.0;
    }
    if(value.length < 8){
      return 0.5;
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\[\]~`]').hasMatch(value) ||
        value.length >= 13) {
      return 1;
    }
    return 0.8;
  }

  static String passwordIndicator(double percentage) {
    if (percentage == 0) return "Kosong";
    if (percentage <= 0.5) return "Lemah";
    if (percentage < 1.0) return "Kuat";
    return "Sangat Kuat";
  }

  static Color passwordColorIndicator(double percentage) {
    if (percentage == 0) return ColorConstant.redColor;
    if (percentage <= 0.5) return ColorConstant.yellowColor;
    if (percentage < 1.0) return ColorConstant.green;
    return ColorConstant.green;
  }
}