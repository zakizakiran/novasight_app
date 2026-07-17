import 'package:get/get.dart';
import 'package:novasight_app/main.dart';

import '../../main_layout/controllers/main_layout_controller.dart';

class TeacherDashboardController extends GetxController {
  late final MainLayoutController mainController;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    mainController = Get.find<MainLayoutController>();
  }

  void onSeeAllExam() {
    mainController.changePage(MainBarTeacher.exam.index);
  }

  void onSeeAllModule() {
    mainController.changePage(MainBarTeacher.module.index);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
