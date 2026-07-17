import 'package:get/get.dart';
import 'package:novasight_app/app/modules/exam-teachers/controllers/exam_teachers_controller.dart';
import 'package:novasight_app/app/modules/module/controllers/module_controller.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/controllers/module_teacher_controller.dart';
import 'package:novasight_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:novasight_app/app/modules/student-dashboard/controllers/student_dashboard_controller.dart';

import 'package:novasight_app/app/modules/exam/controllers/exam_controller.dart';
import 'package:novasight_app/app/modules/chatbot/controllers/chatbot_controller.dart';
import 'package:novasight_app/app/data/repositories/chatbot_repository.dart';
import 'package:novasight_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';
import '../../../data/repositories/auth_repository.dart';
import '../controllers/main_layout_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(() => MainLayoutController());
    // Initialize child controllers if needed, though they can also be initialized in their own bindings
    // if we navigate to them, but since we are using IndexedStack we might need them here.
    // However, it's safer to lazyPut them here to ensure they exist when the tab is switched.
    Get.lazyPut<StudentDashboardController>(() => StudentDashboardController());
    Get.lazyPut<TeacherDashboardController>(() => TeacherDashboardController());
    Get.lazyPut<ModuleController>(
      () => ModuleController(repository: Get.find<ModuleRepository>()),
    );
    Get.lazyPut<ProfileController>(
          () => ProfileController(
              repository: Get.find<AuthRepository>()
          ),
    );
    Get.lazyPut<ExamController>(() => ExamController());
    
    Get.lazyPut<ChatbotRepository>(() => ChatbotRepository());
    Get.lazyPut<ChatbotController>(() => ChatbotController(repository: Get.find()));
    Get.lazyPut<ModuleTeacherController>(() => ModuleTeacherController(repository: Get.find()));
    Get.lazyPut<ExamTeachersController>(() => ExamTeachersController());
  }
}
