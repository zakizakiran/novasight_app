import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../login/controllers/login_controller.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // OTP
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();
  final step = ForgotPasswordStep.email.obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isValid = false.obs;


  @override
  void onReady() {
    step.value = (Get.arguments as ForgotPasswordStep?) ?? ForgotPasswordStep.email;
    super.onReady();
  }

  void nextStep() {
    isValid.value = false;
    switch (step.value) {
      case ForgotPasswordStep.email:
        step.value = ForgotPasswordStep.otp;
        break;
      case ForgotPasswordStep.otp:
        step.value = ForgotPasswordStep.resetPassword;
        break;
      case ForgotPasswordStep.resetPassword:
        onResetPassword();
        break;
    }
  }

  void onOtpCompleted(String value) {
    onChange(value);

    // Optional:
    // onOtpConfirm();
  }

  void onChange(String _) {
    final bool isResetPassword = ValidateHelper.isPasswordConfirmationBool(passwordController.text, confirmPasswordController.text);
    final bool isCondition = switch (step.value) {
      ForgotPasswordStep.email =>
      emailController.text.isNotEmpty && ValidateHelper.isEmailValidateBool(emailController.text),

      ForgotPasswordStep.otp =>
      otpController.text.length == 6,

      ForgotPasswordStep.resetPassword =>
      passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty && isResetPassword,
    };
    isValid.value = isCondition;
  }

  void onSubmitEmail() {}

  void onOtpConfirm() {}

  void onResetPassword() {
    Get.back();
  }

  @override
  void onClose() {
    print("LoginController disposed: ${hashCode}");
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();

    otpController.dispose();
    otpFocusNode.dispose();

    super.onClose();
  }
}

enum ForgotPasswordStep {
  email(1, "Kirim OTP", "Lengkapi Email"),
  otp(2, "Konfirmasi OTP", "Isi OTP yang telah dikirim"),
  resetPassword(3, "Reset Kata Sandi", "Buat kata sandi baru");

  const ForgotPasswordStep(
      this.step,
      this.title,
      this.description,
      );
  final int step;
  final String title;
  final String description;
}
