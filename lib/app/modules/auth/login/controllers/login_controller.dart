import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  final Rx<bool> isValid = false.obs;
  final Rx<bool> isLoading = false.obs;
  final Rx<UserRoles> selectedRole = UserRoles.guru.obs;

  void onSelectedRole(UserRoles role){
    selectedRole.value = role;
  }

  void onLoading(){
    isLoading.value = !isLoading.value;
  }

  void onChange(String _){
    isValid.value =
        ValidateHelper.isEmailValidateBool(emailController.text) &&
        ValidateHelper.isPasswordValidateBool(passwordController.text);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
