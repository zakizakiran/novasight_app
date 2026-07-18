import 'package:get/get.dart';

import '../controllers/exam_teacher_detail_controller.dart';

class ExamTeacherDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamTeacherDetailController>(
      () => ExamTeacherDetailController(),
    );
  }
}
