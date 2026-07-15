import 'package:get/get.dart';

import '../controllers/register_account_controller.dart';

class RegisterAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterAccountController>(
      () => RegisterAccountController(),
    );
  }
}
