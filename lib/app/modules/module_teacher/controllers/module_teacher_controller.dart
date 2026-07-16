import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';

import '../../../core/utils/ui_state.dart';

class ModuleTeacherController extends GetxController {
  final TextEditingController searchController =  TextEditingController();
  final Rx<ModuleTeacherStatus> selectedStatus = ModuleTeacherStatus.all.obs;
  final RxList<ModuleTeacherModel> listModuleTeacher = listDummyModuleTeacher.obs;

  final ModuleTeacherRepository _repository;

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  ModuleTeacherController({
    required this._repository,
  });

  RxList<ModuleTeacherModel> get modules => _repository.modules;

  List<ModuleTeacherModel> get filteredModules {
    return switch (selectedStatus.value) {
      ModuleTeacherStatus.all => modules.toList(),

      ModuleTeacherStatus.draft ||
      ModuleTeacherStatus.publish =>
          modules.where((m) => m.status == selectedStatus.value).toList(),
    };
  }

  Future<void> onLoad() async {
    state.value = const UiStateLoading();

    final result = await _repository.getModules();

    result.match(
          (failure) => state.value = UiStateFailure(failure.message),
          (_) => state.value = const UiStateSuccess(null),
    );
  }
  void onChange(String _){}

  void onSelectedStatus(ModuleTeacherStatus status){
    selectedStatus.value = status;
  }
  void onDeleteModule(ModuleTeacherModel module){
    Get.back();
  }
  @override
  void onInit() {
    super.onInit();
    onLoad();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
