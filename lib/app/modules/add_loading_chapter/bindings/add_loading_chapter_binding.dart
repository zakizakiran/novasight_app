import 'package:get/get.dart';

import '../controllers/add_loading_chapter_controller.dart';

class AddLoadingChapterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLoadingChapterController>(
      () => AddLoadingChapterController(),
    );
  }
}
