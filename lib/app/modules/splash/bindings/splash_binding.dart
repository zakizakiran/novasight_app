import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(
          authRepository: Get.find<AuthRepository>()
      ),
    );
  }
}
