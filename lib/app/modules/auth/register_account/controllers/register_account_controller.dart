import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class RegisterAccountController extends GetxController {
  final AuthRepository repository;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  RegisterAccountController({required this.repository});

  final Rx<UserRoles> selectedRole = UserRoles.guru.obs;

  final Rx<bool> isValid = false.obs;
  final Rx<bool> isValidFullName = false.obs;
  final Rx<bool> isValidEmail = false.obs;
  final Rx<bool> isValidPassword = false.obs;
  final Rx<bool> isValidConfirmationPassword = false.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<dynamic> registeredData = Rxn<dynamic>();

  void onSelectedRole(UserRoles role) {
    selectedRole.value = role;
  }

  void onChange(String _) {
    isValidEmail.value =
        ValidateHelper.isEmailValidateBool(emailController.text) &&
        emailController.text.isNotEmpty;
    isValidFullName.value =
        ValidateHelper.isNormalValidateBool(fullNameController.text) &&
        fullNameController.text.isNotEmpty;
    isValidPassword.value =
        ValidateHelper.isPasswordValidateBool(passwordController.text) &&
        passwordController.text.isNotEmpty;
    isValidConfirmationPassword.value =
        ValidateHelper.isPasswordConfirmationBool(
          passwordController.text,
          confirmPasswordController.text,
        ) &&
        confirmPasswordController.text.isNotEmpty;

    isValid.value =
        isValidEmail.value &&
        isValidFullName.value &&
        isValidPassword.value &&
        isValidConfirmationPassword.value;
  }

  Future<void> onRegister() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final fullName = fullNameController.text.trim();

      if (selectedRole.value == UserRoles.guru) {
        final teacher = await repository.registerTeacher(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          fullName: fullName,
        );
        registeredData.value = teacher;
      } else {
        final student = await repository.registerStudent(
          email: email,
          password: password,
          confirmPassword: confirmPassword,
          fullName: fullName,
        );
        registeredData.value = student;
      }

      // Auto-login to obtain Bearer token for subsequent classroom setup
      bool autoLoginSuccess = false;
      try {
        await repository.login(
          email: email,
          password: password,
          role: selectedRole.value,
        );
        autoLoginSuccess = true;
      } catch (_) {
        autoLoginSuccess = false;
      }

      if (autoLoginSuccess) {
        SnackbarHelper.showSuccess(
          title: "Registrasi Berhasil!",
          message: "Akun berhasil dibuat. Selamat bergabung!",
        );

        final String route = selectedRole.value == UserRoles.guru
            ? Routes.CREATE_CLASS
            : Routes.REGISTER_CLASS;
        Get.offNamed(route);
      } else {
        SnackbarHelper.showSuccess(
          title: "Registrasi Berhasil!",
          message: "Akun berhasil dibuat. Silakan masuk dengan akun Anda.",
        );
        Get.offNamed(Routes.LOGIN);
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(
        title: "Registrasi Gagal",
        message: e.message,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan tidak terduga.';
      SnackbarHelper.showError(
        title: "Registrasi Gagal",
        message: 'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
