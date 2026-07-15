import 'package:get/get.dart';

import '../controllers/success_join_class_controller.dart';

class SuccessJoinClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuccessJoinClassController>(
      () => SuccessJoinClassController(),
    );
  }
}
