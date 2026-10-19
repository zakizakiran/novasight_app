import 'package:get/get.dart';

import '../controllers/exam_teacher_student_progress_controller.dart';

class ExamTeacherStudentProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamTeacherStudentProgressController>(
      () => ExamTeacherStudentProgressController(),
    );
  }
}
