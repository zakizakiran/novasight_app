import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ModuleController extends GetxController {
  final ModuleRepository _repository;
  ModuleController({required this._repository});

  final Rx<ModuleStatus> selectedStatus = ModuleStatus.all.obs;
  final state = Rx<UiState<List<ModuleModel>>>(
    const UiStateInitial<List<ModuleModel>>(),
  );

  Future<void> onLoad() async {
    state.value = const UiStateLoading();
    final result = await _repository.getModules();

    result.match(
          (failure) => state.value = UiStateFailure(failure.message),
          (data) => state.value = UiStateSuccess(data),
      );
  }
  
  void onDetail(ModuleModel module){
    Get.toNamed(
        Routes.MODULE_DETAIL,
      arguments: module
    );
  }

  void onChangeStatus(ModuleStatus status) {
    selectedStatus.value = status;

    final List<ModuleModel> newList = switch (status) {
      ModuleStatus.all => listModule,
      ModuleStatus.notDone =>
          listModule.where((m) => m.toPercentageDone() != 100).toList(),
      ModuleStatus.done =>
          listModule.where((m) => m.toPercentageDone() == 100).toList(),
    };

    state.value = UiStateSuccess(newList);
  }

  @override
  void onInit() {
    onLoad();
    super.onInit();
  }
}
