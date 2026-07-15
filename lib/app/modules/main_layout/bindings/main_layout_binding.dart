import 'package:get/get.dart';
import 'package:novasight_app/app/modules/module/controllers/module_controller.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/modules/student-dashboard/controllers/student_dashboard_controller.dart';

import 'package:novasight_app/app/modules/exam/controllers/exam_controller.dart';
import '../controllers/main_layout_controller.dart';

class MainLayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(() => MainLayoutController());
    // Initialize child controllers if needed, though they can also be initialized in their own bindings
    // if we navigate to them, but since we are using IndexedStack we might need them here.
    // However, it's safer to lazyPut them here to ensure they exist when the tab is switched.
    Get.lazyPut<StudentDashboardController>(() => StudentDashboardController());
    Get.lazyPut<ModuleController>(
      () => ModuleController(repository: Get.find<ModuleRepository>()),
    );
    Get.lazyPut<ExamController>(() => ExamController());
  }
}
