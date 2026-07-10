import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';

import '../controllers/module_detail_controller.dart';

class ModuleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleDetailController>(
      () => ModuleDetailController(
          repository: Get.find<ModuleRepository>()
      ),
    );
  }
}
