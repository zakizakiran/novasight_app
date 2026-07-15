import 'package:get/get.dart';

import '../controllers/create_class_controller.dart';

class CreateClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateClassController>(
      () => CreateClassController(),
    );
  }
}
