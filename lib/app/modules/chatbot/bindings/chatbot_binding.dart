import 'package:get/get.dart';
import 'package:lydera_app/app/data/repositories/chatbot_repository.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

import '../controllers/chatbot_controller.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatbotController>(
      () => ChatbotController(
        repository: Get.find<ChatbotRepository>(),
        classroomRepository: Get.find<ClassroomRepository>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
