import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';

class ModuleDetailController extends GetxController {
  final ModuleRepository _repository;


  late final ModuleModel module;

  ModuleDetailController({required this._repository});

  @override
  void onInit() {
    super.onInit();
    module = Get.arguments as ModuleModel;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
