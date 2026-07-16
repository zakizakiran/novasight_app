import 'package:get/get_rx/src/rx_types/rx_types.dart';
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

  void onAddModule() {
    modules.add(newModuleTeacher);
  }
}