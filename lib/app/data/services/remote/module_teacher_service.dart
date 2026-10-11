import 'package:get/get.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';

class ModuleTeacherService {
  final RxList<ModuleTeacherModel> modules = <ModuleTeacherModel>[].obs;
  void onAddModule(ModuleTeacherModel module) {
    final existingIndex = modules.indexWhere((m) => m.id == module.id);

    if (existingIndex != -1) {
      modules[existingIndex] = module;
    } else {
      modules.add(module);
    }
  }

  void onRemoveModule(ModuleTeacherModel module){
    modules.remove(module);
  }

  void onPublishModule(ModuleTeacherModel module) {
    final index = modules.indexWhere((m) => m.id == module.id);

    if (index != -1) {
      modules[index] = modules[index].copyWith(
        status: ModuleTeacherStatus.publish,
      );
    }
  }

}