import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

import '../controllers/teacher_dashboard_controller.dart';

class TeacherDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TeacherDashboardController>(
      () => TeacherDashboardController(
        classroomRepository: Get.find<ClassroomRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
