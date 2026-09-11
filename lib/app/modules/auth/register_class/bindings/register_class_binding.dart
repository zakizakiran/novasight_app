import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';

import '../controllers/register_class_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(
        repository: Get.find<ClassroomRepository>(),
      ),
    );
  }
}

