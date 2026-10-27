import 'package:get/get.dart';
import 'package:lydera_app/app/data/repositories/auth_repository.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        repository: Get.find<AuthRepository>()
      ),
    );
  }
}
