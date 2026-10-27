import 'package:get/get.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';

import '../controllers/create_class_controller.dart';

class CreateClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateClassController>(
      () => CreateClassController(
        repository: Get.find<ClassroomRepository>(),
      ),
    );
  }
}
