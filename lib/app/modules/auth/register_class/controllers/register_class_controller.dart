import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';

import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final codeController = TextEditingController();

  final Rx<bool> isValid = false.obs;
  final Rx<bool> isLoading = false.obs;

  void onChange(String value){
    isValid.value = ValidateHelper.isNormalValidateBool(value) && codeController.text.length > 7;
  }

  Future<void> onRegister() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1800));
    isLoading.value = false;
    Get.toNamed(Routes.SUCCESS_JOIN_CLASS);
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

}
