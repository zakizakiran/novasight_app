import 'package:fpdart/fpdart.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:novasight_app/app/core/exceptions/failure.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/data/services/remote/module_service.dart';

class ModuleRepository {
  final ModuleService _service;
  ModuleRepository(this._service);

  RxList<ModuleModel> get modules => _service.modules;

  Future<Either<Failure, List<ModuleModel>>> getModules() async {
    try{
      return Right(await _service.getModules());
    }on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<Failure, ModuleModel>> getModuleById(int id) async {
    try{
      return Right(await _service.getModuleById(id));
    }on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  void onDoneSubject(int subjectId){
    return _service.onUpdateSubject(subjectId);
  }
}