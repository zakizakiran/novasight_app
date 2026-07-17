import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        repository: Get.find<AuthRepository>()
      ),
    );
  }
}
