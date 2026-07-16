import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/data/services/remote/module_service.dart';
import 'package:novasight_app/app/data/services/remote/module_teacher_service.dart';

Future<void> initDepedencies() async {
  Get.put(StorageService(), permanent: true);
  Get.put(ModuleService(),permanent: true);
  Get.put(ModuleTeacherService(),permanent: true);

  Get.lazyPut<ModuleRepository>(
      () => ModuleRepository(
        Get.find<ModuleService>()
      )
  );

  Get.lazyPut<ModuleTeacherRepository>(
          () => ModuleTeacherRepository(
          Get.find<ModuleTeacherService>()
      )
  );

  Get.lazyPut<AuthRepository>(
      () => AuthRepository(
        storageService: Get.find<StorageService>()
      )
  );
}
