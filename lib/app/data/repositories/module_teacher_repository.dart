import 'package:fpdart/fpdart.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:novasight_app/app/core/exceptions/failure.dart';
import 'package:novasight_app/app/data/services/remote/module_teacher_service.dart';
import '../model/module_teacher_model.dart';

class ModuleTeacherRepository {
  final ModuleTeacherService _service;
  ModuleTeacherRepository(this._service);

  RxList<ModuleTeacherModel> get modules => _service.modules;

  Future<Either<Failure, List<ModuleTeacherModel>>> getModules() async {
    try{
      return Right(await _service.getModules());
    }on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<Failure, ModuleTeacherModel>> getModuleById(int id) async {
    try{
      return Right(await _service.getModuleById(id));
    }on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
  //
  void onAddModule(){
    return _service.onAddModule();
  }
}