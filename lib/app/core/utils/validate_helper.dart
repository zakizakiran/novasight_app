class ValidateHelper {
  //String
  static String? isPasswordValidate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    if (value.length >= 8) {
      return null; // Password is valid
    }
    return "Password minimal 8 karakter";
  }

  static String? isEmailValidate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.contains("@") && value.contains(".com")) {
      return null;
    }

    return "Email Address tidak valid";
  }

  static String? isNormalValidate(String value, String? title) {
    if (value.isEmpty) {
      return "${title}Tidak Boleh Kosong";
    }
    return null;
  }

  static String? isPasswordConfirmation(String? value, {String? secondValue}) {
    if (value != secondValue) {
      return "kata sandi tidak sama dengan kata sandi baru";
    }
    return null;
  }

  //Bool
  static bool isPasswordValidateBool(String value) {
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 8) {
      return false;
    }
    return true;
  }

  static bool isEmailValidateBool(String value) {
    if (value.isEmpty) {
      return true;
    }
    if (value.contains("@") && value.contains(".com")) {
      return true;
    }
    return false;
  }

  static bool isNormalValidateBool(
      String value,
      ) {
    if (value.isEmpty) {
      return false;
    }
    return true;
  }

  static bool isPasswordConfirmationBool(String? value, String? secondValue) {
    if (value?.isEmpty ?? true) {
      return false;
    }
    if (value != secondValue) {
      return false;
    }
    return true;
  }
}
