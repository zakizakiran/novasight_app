import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';

import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final ClassroomRepository repository;

  RegisterController({required this.repository});

  final codeController = TextEditingController();

  final Rx<bool> isValid = false.obs;
  final Rx<bool> isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void onChange(String value) {
    // Classroom code is 7 characters per API contract
    isValid.value =
        ValidateHelper.isNormalValidateBool(value) &&
        codeController.text.length >= 7;
  }

  Future<void> onRegister() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await repository.joinClassroom(
        code: codeController.text.trim(),
      );

      SnackbarHelper.showSuccess(
        title: "Berhasil Bergabung!",
        message: "Kamu telah berhasil bergabung ke kelas.",
      );

      Get.toNamed(Routes.SUCCESS_JOIN_CLASS);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(
        title: "Gagal Bergabung",
        message: e.message,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan tidak terduga.';
      SnackbarHelper.showError(
        title: "Gagal Bergabung",
        message: 'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
