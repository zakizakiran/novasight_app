import 'package:get/get.dart';

import '../controllers/exam_active_controller.dart';

class ExamActiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamActiveController>(
      () => ExamActiveController(),
    );
  }
}
