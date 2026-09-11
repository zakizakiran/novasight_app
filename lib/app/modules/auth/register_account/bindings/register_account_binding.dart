import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';

import '../controllers/register_account_controller.dart';

class RegisterAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterAccountController>(
      () => RegisterAccountController(
        repository: Get.find<AuthRepository>(),
      ),
    );
  }
}
