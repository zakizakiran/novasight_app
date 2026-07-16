import 'package:get/get.dart';

import '../controllers/generate_exam_controller.dart';

class GenerateExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateExamController>(
      () => GenerateExamController(),
    );
  }
}
