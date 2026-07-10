import 'package:novasight_app/app/data/model/module_model.dart';

class ModuleService {
  Future<List<ModuleModel>> getModules() async {
    try{
      return listModule;
    }catch(e){
      rethrow;
    }
  }

  Future<ModuleModel> getModuleById(int id) async {
    try{
      return listModule.where((m) => m.id == id).first;
    }catch(e){
      rethrow;
    }
  }
}