import 'package:fpdart/fpdart.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:novasight_app/app/core/exceptions/failure.dart';
import 'package:novasight_app/app/data/models/module_model.dart';
import 'package:novasight_app/app/data/services/remote/module_service.dart';

class ModuleRepository {
  final ModuleService _service;
  ModuleRepository(this._service);

  RxList<ModuleModel> get modules => _service.modules;

}