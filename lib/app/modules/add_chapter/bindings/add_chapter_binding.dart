import 'package:get/get.dart';

import '../controllers/add_chapter_controller.dart';

class AddChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddChapterController>(
      () => AddChapterController(),
    );
  }
}
