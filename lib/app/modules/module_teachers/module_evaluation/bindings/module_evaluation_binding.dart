import 'package:get/get.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';

import '../controllers/module_evaluation_controller.dart';

class ModuleEvaluationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleEvaluationController>(
      () => ModuleEvaluationController(
        teacherRepository: Get.isRegistered<TeacherRepository>()
            ? Get.find<TeacherRepository>()
            : null,
      ),
    );
  }
}
