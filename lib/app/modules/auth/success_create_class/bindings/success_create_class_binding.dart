import 'package:get/get.dart';

import '../controllers/success_create_class_controller.dart';

class SuccessCreateClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessCreateClassController>(
      () => SuccessCreateClassController(),
    );
  }
}
