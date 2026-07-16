import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';

import '../controllers/module_teacher_controller.dart';

class ModuleTeacherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleTeacherController>(
          () => ModuleTeacherController(
          repository: Get.find<ModuleTeacherRepository>()
      ),
    );
  }
}
