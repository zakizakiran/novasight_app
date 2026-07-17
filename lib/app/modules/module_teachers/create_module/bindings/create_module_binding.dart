import 'package:get/get.dart';

import '../controllers/create_module_controller.dart';

class CreateModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateModuleController>(
      () => CreateModuleController(),
    );
  }
}
