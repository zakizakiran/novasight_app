import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';

import '../controllers/module_controller.dart';

class ModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleController>(
      () => ModuleController(
        repository: Get.find<ModuleRepository>()
      ),
    );
  }
}
