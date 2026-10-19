import 'package:get/get.dart';

import '../controllers/exam_teacher_student_progress_detail_controller.dart';

class ExamTeacherStudentProgressDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamTeacherStudentProgressDetailController>(
      () => ExamTeacherStudentProgressDetailController(),
    );
  }
}
