import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ModuleController extends GetxController {
  final ModuleRepository _repository;

  ModuleController({
    required this._repository,
  });

  final selectedStatus = ModuleStatus.all.obs;

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  RxList<ModuleModel> get modules => _repository.modules;

  List<ModuleModel> get filteredModules {
    return switch (selectedStatus.value) {
      ModuleStatus.all => modules.toList(),

      ModuleStatus.notDone =>
          modules.where((m) => m.toPercentageDone() != 100).toList(),

      ModuleStatus.done =>
          modules.where((m) => m.toPercentageDone() == 100).toList(),
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

  void onChangeStatus(ModuleStatus status) {
    selectedStatus.value = status;
  }

  void onDetail(ModuleModel module) {
    Get.toNamed(
      Routes.MODULE_DETAIL,
      arguments: module.id,
    );
  }

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }
}
