import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository _repository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginController({required this._repository});

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

  Future<void> onLogin() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    await _repository.storageService.writeUserRole(selectedRole.value);
    await _repository.storageService.writePassword(passwordController.text);
    isLoading.value = false;
    Get.offAllNamed(
        Routes.SPLASH,
      arguments: selectedRole.value
    );
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
