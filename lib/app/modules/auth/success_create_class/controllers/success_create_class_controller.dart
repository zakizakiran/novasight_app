import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class SuccessCreateClassController extends GetxController {
  final Rx<String> code = "".obs;
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is String) {
      code.value = Get.arguments as String;
    } else if (code.value.isEmpty) {
      code.value = "N S G - 4 8 2 1";
    }
  }

  Future<void> onCopyCode() async {
    await Clipboard.setData(
      ClipboardData(text: code.value),
    );

    SnackbarHelper.showSuccess(
      title: "Berhasil",
      message: "Kode kelas berhasil disalin",
    );
  }

  void onManageClass() {
    Get.offAllNamed(
      Routes.SPLASH,
      arguments: UserRoles.guru,
    );
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
