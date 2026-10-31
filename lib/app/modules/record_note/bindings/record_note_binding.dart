import 'package:get/get.dart';

import '../controllers/record_note_controller.dart';

class RecordNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordNoteController>(
      () => RecordNoteController(),
    );
  }
}
