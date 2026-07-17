import 'package:get/get.dart';

class MainLayoutController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = Get.arguments as int? ?? 0;
    super.onInit();
  }

  void changePage(int index) {

    currentIndex.value = index;
  }
}

enum MainBarStudent{
  home,
  module,
  exam,
  chatbot,
  profile;
}
