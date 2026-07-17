import 'package:get/get.dart';

import '../controllers/exam_review_controller.dart';

class ExamReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExamReviewController>(
      () => ExamReviewController(),
    );
  }
}
