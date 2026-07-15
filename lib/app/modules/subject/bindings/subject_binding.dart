import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';

import '../controllers/subject_controller.dart';

class SubjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubjectController>(
      () => SubjectController(
        repository: Get.find<ModuleRepository>()
      ),
    );
  }
}
