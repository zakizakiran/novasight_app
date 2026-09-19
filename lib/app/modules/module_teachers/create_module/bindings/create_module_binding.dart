import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

import '../controllers/create_module_controller.dart';

class CreateModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateModuleController>(
      () => CreateModuleController(
        teacherRepository: Get.isRegistered<TeacherRepository>()
            ? Get.find<TeacherRepository>()
            : null,
        classroomRepository: Get.isRegistered<ClassroomRepository>()
            ? Get.find<ClassroomRepository>()
            : null,
        storageService: Get.isRegistered<StorageService>()
            ? Get.find<StorageService>()
            : null,
      ),
    );
  }
}
