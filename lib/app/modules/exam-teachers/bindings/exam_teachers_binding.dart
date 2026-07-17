import 'package:get/get.dart';

import '../controllers/exam_teachers_controller.dart';

class ExamTeachersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamTeachersController>(
      () => ExamTeachersController(),
    );
  }
}
