import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';

import '../controllers/module_result_annotation_controller.dart';

class ModuleResultAnnotationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleResultAnnotationController>(
      () => ModuleResultAnnotationController(
        repository: Get.find<ModuleTeacherRepository>()
      ),
    );
  }
}
