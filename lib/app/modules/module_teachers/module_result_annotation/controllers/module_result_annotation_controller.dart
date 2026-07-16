import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ModuleResultAnnotationController extends GetxController {
  final ModuleTeacherRepository _repository;
  late final ModuleTeacherModel moduleTeacherModel;

  ModuleResultAnnotationController({required this._repository});

  @override
  void onInit() {
    super.onInit();
    moduleTeacherModel = Get.arguments as ModuleTeacherModel;
    debugPrint("Module Teacher di Result : ${moduleTeacherModel.name}");
  }

  void onEvaluate(){

  }

  void onSaveModule(){
    SnackbarHelper.showSuccess(title: "Modul Berhasil Disimpan!", message: "Modul sudah siap diakses");
    _repository.onAddModule();
    Get.offNamedUntil(
      Routes.MODULE_TEACHER,
          (route) => route.settings.name == Routes.MODULE_TEACHER,
    );
  }
}
