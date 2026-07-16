import 'package:get/get.dart';

import '../controllers/module_result_annotation_controller.dart';

class ModuleResultAnnotationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleResultAnnotationController>(
      () => ModuleResultAnnotationController(),
    );
  }
}
