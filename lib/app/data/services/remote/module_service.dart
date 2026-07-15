import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:novasight_app/app/data/model/module_model.dart';

class ModuleService {
  final RxList<ModuleModel> modules = <ModuleModel>[].obs;
  Future<List<ModuleModel>> getModules() async {
    try{
      return modules.value = listModule;
    }catch(e){
      rethrow;
    }
  }

  Future<ModuleModel> getModuleById(int id) async {
    try{
      return modules.where((m) => m.id == id).first;
    }catch(e){
      rethrow;
    }
  }

  void onUpdateSubject(int subjectId){
    final updatedModules = modules.map((module) {
      final subjects = module.subjects.map((subject) {
        if(subject.id == subjectId){
          return subject.copyWith(isDone: true);
        }else{
          return subject;
        }
      }).toList();

      return module.copyWith(
          subjects: subjects
      );
    }).toList();
    modules.value = updatedModules;
  }
}