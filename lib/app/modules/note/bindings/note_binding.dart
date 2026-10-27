import 'package:get/get.dart';

import '../../../data/repositories/note_repository.dart';
import '../../exam_active/controllers/exam_active_controller.dart';
import '../controllers/note_controller.dart';

class NoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NoteController>(
          () => NoteController(
        noteRepository: Get.find<NoteRepository>(),
        examActiveController: Get.find<ExamActiveController>(),
      ),
    );
  }
}
