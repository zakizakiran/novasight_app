import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';
import '../../../../core/utils/ui_state.dart';


class ModuleTeacherController extends GetxController {
  final TextEditingController searchController = TextEditingController();

  final Rx<ModuleTeacherStatus> selectedStatus =
      ModuleTeacherStatus.all.obs;

  final searchQuery = ''.obs;

  final RxList<ModuleTeacherModel> filteredModules =
      <ModuleTeacherModel>[].obs;

  late Worker _searchWorker;
  late Worker _modulesWorker;

  final ModuleTeacherRepository _repository;

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );


  ModuleTeacherController({
    required this._repository,
  });


  RxList<ModuleTeacherModel> get modules => _repository.modules;


  Future<void> onLoad() async {
    state.value = const UiStateLoading();

    final result = await _repository.getModules();

    result.match(
          (failure) {
        state.value = UiStateFailure(failure.message);
      },
          (_) {
        _filterModules();
        state.value = const UiStateSuccess(null);
      },
    );
  }

  void onChange(String value) {
    searchQuery.value = value;
  }

  void onSelectedStatus(ModuleTeacherStatus status) {
    selectedStatus.value = status;
    _filterModules();
  }

  void _filterModules() {
    final query = searchQuery.value.toLowerCase().trim();

    final result = modules.where((module) {

      final matchSearch =
          query.isEmpty ||
              module.name.toLowerCase().contains(query);


      final matchStatus =
          selectedStatus.value == ModuleTeacherStatus.all ||
              module.status == selectedStatus.value;


      return matchSearch && matchStatus;

    }).toList();


    filteredModules.assignAll(result);
  }


  void onDeleteModule(ModuleTeacherModel module) {
    _repository.onRemoveModule(module);
    Get.back();
  }

  void onPublishModule(ModuleTeacherModel module){
    _repository.onPublishModule(module);
  }


  @override
  void onInit() {
    super.onInit();
    onLoad();
    _searchWorker = debounce(
      searchQuery,
          (_) => _filterModules(),
      time: const Duration(milliseconds: 400),
    );

    _modulesWorker = ever<List<ModuleTeacherModel>>(modules, (_) => _filterModules());
  }


  @override
  void onClose() {
    searchController.dispose();
    _searchWorker.dispose();
    _modulesWorker.dispose();
    super.onClose();
  }
}
