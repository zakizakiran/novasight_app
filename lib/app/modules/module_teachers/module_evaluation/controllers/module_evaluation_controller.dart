import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../data/model/module_teacher_model.dart';
import '../../../../data/repositories/module_teacher_repository.dart';
import '../../../../routes/app_pages.dart';

class ModuleEvaluationController extends GetxController {
  final TextEditingController adviceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final ModuleTeacherRepository _repository;
  final RxList<ModuleChunk> selectedChunks = <ModuleChunk>[].obs;
  late final Rx<ModuleTeacherModel> moduleTeacherModel;

  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isValid = false.obs;
  ModuleEvaluationController({required this._repository});
  bool _isCancelled = false;

  void onSelectChunk(ModuleChunk value){
    if (isLoading.value) return;
    final bool condition = selectedChunks.contains(value);
    !condition ? selectedChunks.add(value) : selectedChunks.remove(value);
    onChange("");
  }

  void onChange(String v){
    isValid.value = adviceController.text.isNotEmpty && selectedChunks.value.isNotEmpty;
  }

  Future<void> onSendAdvice() async{
    _isCancelled = false;
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 2700));
    if (_isCancelled) {
      return;
    }
    moduleTeacherModel.value = _repository.onAddAdvice(moduleTeacherModel.value, selectedChunks.map((c) => c.id).toList());
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    SnackbarHelper.showSuccess(title: "Anotasi Berhasil Diperbarui!", message: "Anotasi AI sudah siap digunakan");
    isLoading.value = false;
  }

  @override
  void onInit() {
    moduleTeacherModel = (Get.arguments as ModuleTeacherModel).obs;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    adviceController.dispose();
    super.onClose();
  }

  void onEvaluate(){

  }

  void cancelLoadingProcess() {
    _isCancelled = true;
    isLoading.value = false;
  }

  void onSaveModule(){
    SnackbarHelper.showSuccess(title: "Modul Berhasil Disimpan!", message: "Modul sudah siap diakses");
    _repository.onAddModule(moduleTeacherModel.value);
    Get.offNamedUntil(
      Routes.MODULE_TEACHER,
          (route) => route.settings.name == Routes.MODULE_TEACHER,
    );
  }
}
