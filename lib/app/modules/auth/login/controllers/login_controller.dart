import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthRepository repository;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  LoginController({required this.repository});

  final Rx<bool> isValid = false.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<String> tokenData = Rxn<String>();
  final Rx<UserRoles> selectedRole = UserRoles.guru.obs;

  void onSelectedRole(UserRoles role) {
    selectedRole.value = role;
  }

  void onChange(String _) {
    isValid.value =
        ValidateHelper.isEmailValidateBool(emailController.text) &&
        ValidateHelper.isPasswordValidateBool(passwordController.text);
  }

  Future<void> onLogin() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = await repository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value,
      );
      tokenData.value = token;

      final String name = repository.storageService.getUserName() ??
          (selectedRole.value == UserRoles.siswa ? 'Siswa' : 'Guru');

      SnackbarHelper.showSuccess(
        title: "Login Berhasil!",
        message: "Selamat datang, $name 👋",
      );

      Get.offAllNamed(
        Routes.SPLASH,
        arguments: selectedRole.value,
      );
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(
        title: "Login Gagal",
        message: e.message,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan tidak terduga.';
      SnackbarHelper.showError(
        title: "Login Gagal",
        message: 'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
