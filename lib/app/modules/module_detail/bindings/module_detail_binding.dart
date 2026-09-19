import 'package:get/get.dart';

import '../controllers/module_detail_controller.dart';

class ModuleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleDetailController>(() => ModuleDetailController());
  }
}
