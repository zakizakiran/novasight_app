import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';

import '../controllers/module_evaluation_controller.dart';

class ModuleEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleEvaluationController>(
      () => ModuleEvaluationController(
        repository: Get.find<ModuleTeacherRepository>()
      ),
    );
  }
}
