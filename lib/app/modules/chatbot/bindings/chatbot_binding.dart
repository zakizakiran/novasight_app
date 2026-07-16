import 'package:get/get.dart';
import 'package:novasight_app/app/data/repositories/chatbot_repository.dart';

import '../controllers/chatbot_controller.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatbotRepository>(() => ChatbotRepository());
    Get.lazyPut<ChatbotController>(
      () => ChatbotController(repository: Get.find()),
    );
  }
}
