import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/subject_args.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';

import '../../../data/model/subject_model.dart';
import '../../../routes/app_pages.dart';

class ModuleDetailController extends GetxController {
  final ModuleRepository _repository;

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  int id = Get.arguments as int;
  ModuleDetailController({required this._repository});
  ModuleModel get module => _repository.modules.firstWhere((m) => m.id == id);

  @override
  void onInit() {
    onLoad();
    super.onInit();

  }

  Future<void> onLoad() async {
    state.value = const UiStateLoading();
    final result = await _repository.getModuleById(id);

    result.match(
          (failure) => state.value = UiStateFailure(failure.message),
          (data) => state.value = UiStateSuccess(data),
    );
  }

  void onSubject(SubjectModel subject, int index){
    Get.toNamed(
        Routes.SUBJECT,
        arguments: SubjectArgs(subject: subject, index: index)
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
