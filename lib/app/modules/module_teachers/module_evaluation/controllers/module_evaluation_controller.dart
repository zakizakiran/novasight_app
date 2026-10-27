import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/args/main_bar_args.dart';
import 'package:lydera_app/app/core/args/module_result_args.dart';
import 'package:lydera_app/app/core/utils/user_roles.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../data/model/module_teacher_model.dart';
import '../../../../routes/app_pages.dart';
import '../../create_module/controllers/create_module_controller.dart';
import 'package:lydera_app/app/modules/main_layout/controllers/main_layout_controller.dart';
import 'package:lydera_app/app/modules/module_teachers/module_teacher/controllers/module_teacher_controller.dart';

class ModuleEvaluationController extends GetxController {
  final TextEditingController adviceController = TextEditingController();
  final TextEditingController textEditController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final textFormKey = GlobalKey<FormState>();
  final TeacherRepository? teacherRepository;
  final RxList<ModuleChunk> selectedChunks = <ModuleChunk>[].obs;
  late final Rx<ModuleTeacherModel> moduleTeacherModel;
  int? chapterId;
  String? annotationPath;

  final Rx<bool> isLoading = false.obs;
  final Rx<bool> isValid = false.obs;
  final Rx<bool> isTextValid = false.obs;

  bool get isTextSelected =>
      selectedChunks.isNotEmpty && selectedChunks.every((c) => c is TextChunk);

  bool get isImageSelected =>
      selectedChunks.isNotEmpty && selectedChunks.every((c) => c is ImageChunk);

  bool get canSelectAllSpecial =>
      moduleTeacherModel.value.listChunks.whereType<ImageChunk>().isNotEmpty;

  bool get isAllSpecialSelected {
    final specials =
        moduleTeacherModel.value.listChunks.whereType<ImageChunk>().toList();
    return specials.isNotEmpty &&
        selectedChunks.length == specials.length &&
        specials.every((s) => selectedChunks.contains(s));
  }

  void toggleSelectAllSpecial() {
    if (isLoading.value) return;
    final specials =
        moduleTeacherModel.value.listChunks.whereType<ImageChunk>().toList();
    if (specials.isEmpty) return;

    if (isAllSpecialSelected) {
      selectedChunks.clear();
    } else {
      selectedChunks.clear();
      selectedChunks.addAll(specials);
    }
    onChange("");
  }

  ModuleEvaluationController({
    this.teacherRepository,
  });

  bool _isCancelled = false;

  void onSelectChunk(ModuleChunk value) {
    if (isLoading.value) return;

    final isAlreadySelected = selectedChunks.contains(value);
    if (isAlreadySelected) {
      selectedChunks.remove(value);
      onChange("");
      return;
    }

    // Single-type selection rule:
    // If selecting a different type than current selections, clear previous type
    if (selectedChunks.isNotEmpty) {
      final isCurrentText = selectedChunks.first is TextChunk;
      final isNewText = value is TextChunk;
      if (isCurrentText != isNewText) {
        selectedChunks.clear();
      }
    }

    if (value is TextChunk) {
      // Direct text edit operates on one text block at a time
      selectedChunks.clear();
      selectedChunks.add(value);
      prepareTextEdit();
    } else {
      // Image blocks can be multi-selected for bulk AI regeneration
      selectedChunks.add(value);
    }
    onChange("");
  }

  void prepareTextEdit() {
    if (selectedChunks.isEmpty || selectedChunks.first is! TextChunk) return;
    final chunk = selectedChunks.first as TextChunk;
    final initialText =
        (chunk.annotation != null && chunk.annotation!.isNotEmpty)
            ? chunk.annotation!
            : chunk.text;
    textEditController.text = initialText;
    isTextValid.value = textEditController.text.trim().isNotEmpty;
  }

  void onTextChange(String v) {
    isTextValid.value = v.trim().isNotEmpty;
  }

  void onSaveDirectText() {
    if (selectedChunks.isEmpty || selectedChunks.first is! TextChunk) return;
    final chunk = selectedChunks.first as TextChunk;
    final newText = textEditController.text.trim();
    if (newText.isEmpty) return;

    final current = moduleTeacherModel.value;
    final updatedList = current.listChunks.map((c) {
      if (c.id == chunk.id) {
        return c.copyWith(annotation: newText);
      }
      return c;
    }).toList();

    moduleTeacherModel.value = current.copyWith(listChunks: updatedList);
    selectedChunks.clear();
    textEditController.clear();

    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    SnackbarHelper.showSuccess(
      title: "Anotasi Teks Disimpan!",
      message: "Perubahan anotasi berhasil disimpan.",
    );
  }

  void onChange(String v) {
    isValid.value =
        adviceController.text.isNotEmpty && selectedChunks.value.isNotEmpty;
  }

  Future<void> onSendAdvice() async {
    _isCancelled = false;
    final feedback = adviceController.text.trim();
    if (feedback.isEmpty || selectedChunks.isEmpty) return;

    isLoading.value = true;
    try {
      final imageBlockIds = selectedChunks
          .whereType<ImageChunk>()
          .map((c) => c.id)
          .toList();

      if (teacherRepository != null && imageBlockIds.isNotEmpty) {
        final results = await teacherRepository!.bulkRegenerateSpecial(
          blockIds: imageBlockIds,
          feedback: feedback,
        );

        if (_isCancelled) return;

        final current = moduleTeacherModel.value;
        final updatedList = current.listChunks.map((c) {
          final match = results.firstWhereOrNull((r) => r.blockId == c.id);
          if (match != null) {
            return c.copyWith(annotation: match.readableText);
          }
          return c;
        }).toList();

        moduleTeacherModel.value = current.copyWith(listChunks: updatedList);
      }

      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      selectedChunks.clear();
      adviceController.clear();
      SnackbarHelper.showSuccess(
        title: "Anotasi Berhasil Diperbarui!",
        message: "Anotasi AI untuk gambar sudah diperbarui.",
      );
    } catch (e) {
      debugPrint('Error bulk regenerating special blocks: $e');
      SnackbarHelper.showError(
        title: "Gagal Merevisi Anotasi",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    if (Get.arguments is ModuleResultArgs) {
      final args = Get.arguments as ModuleResultArgs;
      moduleTeacherModel = args.module.obs;
      chapterId = args.chapterId;
      annotationPath = args.annotationPath;
    } else if (Get.arguments is ModuleTeacherModel) {
      moduleTeacherModel = (Get.arguments as ModuleTeacherModel).obs;
    }
    super.onInit();
  }

  @override
  void onClose() {
    adviceController.dispose();
    textEditController.dispose();
    super.onClose();
  }

  void onEvaluate() {}

  void cancelLoadingProcess() {
    _isCancelled = true;
    isLoading.value = false;
  }

  Future<void> onSaveModule() async {
    isLoading.value = true;
    try {
      if (chapterId != null &&
          annotationPath != null &&
          annotationPath!.isNotEmpty &&
          teacherRepository != null) {
        try {
          await teacherRepository!.confirmChapter(
            chapterId: chapterId!,
            annotationPath: annotationPath!,
          );
        } catch (e) {
          debugPrint('confirmChapter onSave notice (already confirmed): $e');
        }
      }

      if (Get.isRegistered<CreateModuleController>()) {
        final createCtrl = Get.find<CreateModuleController>();
        createCtrl.markChapterAsReviewed(chapterId);
      }

      SnackbarHelper.showSuccess(
        title: "Bab Berhasil Disimpan!",
        message: "Anotasi bab berhasil dikonfirmasi dan disimpan.",
      );

      // Return back to Potong Chapter screen
      if (Get.isRegistered<CreateModuleController>()) {
        Get.until((route) => route.settings.name == Routes.CREATE_MODULE);
      } else {
        if (Get.isRegistered<MainLayoutController>()) {
          Get.find<MainLayoutController>().changePage(1);
        }
        if (Get.isRegistered<ModuleTeacherController>()) {
          Get.find<ModuleTeacherController>().onLoad();
        }
        Get.offNamedUntil(
          Routes.MAIN_LAYOUT,
          arguments: const MainBarArgs(role: UserRoles.guru, index: 1),
          (route) => route.settings.name == Routes.MAIN_LAYOUT,
        );
      }
    } catch (e) {
      debugPrint('Error confirming chapter: $e');
      SnackbarHelper.showError(
        title: "Gagal Menyimpan Bab",
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
