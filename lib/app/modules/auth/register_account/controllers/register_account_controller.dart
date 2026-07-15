import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../../../core/utils/validate_helper.dart';

class RegisterAccountController extends GetxController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final Rx<bool> isValid = false.obs;
  final Rx<bool> isValidFullName = false.obs;
  final Rx<bool> isValidEmail = false.obs;
  final Rx<bool> isValidPassword = false.obs;
  final Rx<bool> isValidConfirmationPassword = false.obs;
  final Rx<bool> isLoading = false.obs;

  final count = 0.obs;

  void onChange(String _){
    isValidEmail.value = ValidateHelper.isEmailValidateBool(emailController.text) && emailController.text.isNotEmpty;
    isValidFullName.value = ValidateHelper.isNormalValidateBool(fullNameController.text) && fullNameController.text.isNotEmpty;
    isValidPassword.value = ValidateHelper.isPasswordValidateBool(passwordController.text) && passwordController.text.isNotEmpty;
    isValidConfirmationPassword.value = ValidateHelper.isPasswordConfirmationBool(passwordController.text, confirmPasswordController.text) && confirmPasswordController.text.isNotEmpty;

    isValid.value =
            isValidEmail.value &&
            isValidFullName.value &&
            isValidPassword.value &&
            isValidConfirmationPassword.value;
  }

  void onRegister(){
    Get.offNamed(Routes.CREATE_CLASS);
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void increment() => count.value++;
}
