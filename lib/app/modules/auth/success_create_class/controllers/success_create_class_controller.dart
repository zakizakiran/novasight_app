import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class SuccessCreateClassController extends GetxController {
  final Rx<String> code = "N S G - 4 8 2 1".obs;
  final count = 0.obs;

  Future<void> onCopyCode() async {
    await Clipboard.setData(
      ClipboardData(text: code.value),
    );

    Get.closeAllSnackbars();
    Get.snackbar(
      "Berhasil",
      duration: const Duration(milliseconds: 1300),
      "Kode kelas berhasil disalin",
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      margin: const EdgeInsets.only(
          bottom: Dimens.spacePadding,
          left: Dimens.spacePadding,
          right: Dimens.spacePadding
      )
    );
  }

  void onManageClass(){
    Get.offAllNamed(Routes.SPLASH);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
