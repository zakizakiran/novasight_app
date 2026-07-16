import 'package:get/get.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';

class ModuleTeacherService {
  final RxList<ModuleTeacherModel> modules = <ModuleTeacherModel>[].obs;
  Future<List<ModuleTeacherModel>> getModules() async {
    try{
      return modules.value = listDummyModuleTeacher;
    }catch(e){
      rethrow;
    }
  }

  Future<ModuleTeacherModel> getModuleById(int id) async {
    try{
      return modules.where((m) => m.id == id).first;
    }catch(e){
      rethrow;
    }
  }

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

  ModuleTeacherModel onAddAdvice(ModuleTeacherModel module, List<int> idChunks) {
    List<ModuleChunk> updatedChunks = module.listChunks.map((oldChunk) {
      final isSelected = idChunks.contains(oldChunk.id);
      if (!isSelected) {
        return oldChunk;
      }

      final matchingNewChunk = newestAnnotation.firstWhereOrNull(
            (newChunk) => newChunk.id == oldChunk.id,
      );

      if (matchingNewChunk != null) {
        String? newAnnotationText = (matchingNewChunk).annotation;

        return oldChunk.copyWith(annotation: newAnnotationText);
      }

      return oldChunk;
    }).toList();

    return module.copyWith(listChunks: updatedChunks);
  }
}