import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/module_result_args.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/routes/app_pages.dart';
import '../../create_module/controllers/create_module_controller.dart';

class ModuleResultAnnotationController extends GetxController {
  final TeacherRepository? teacherRepository;
  late final ModuleTeacherModel moduleTeacherModel;
  int? chapterId;
  String? annotationPath;
  final RxBool isLoading = false.obs;

  ModuleResultAnnotationController({
    this.teacherRepository,
  });

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ModuleResultArgs) {
      final args = Get.arguments as ModuleResultArgs;
      moduleTeacherModel = args.module;
      chapterId = args.chapterId;
      annotationPath = args.annotationPath;
    }
    debugPrint("Module Teacher di Result : ${moduleTeacherModel.name}");
  }

  void onEvaluate() {
    Get.toNamed(
      Routes.MODULE_EVALUATION,
      arguments: ModuleResultArgs(
        module: moduleTeacherModel,
        canPop: true,
        chapterId: chapterId,
        annotationPath: annotationPath,
      ),
    );
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
        message: "Hasil anotasi bab berhasil dikonfirmasi dan disimpan.",
      );

      // Return back to Potong Chapter screen
      if (Get.isRegistered<CreateModuleController>()) {
        Get.until((route) => route.settings.name == Routes.CREATE_MODULE);
      } else {
        Get.offNamedUntil(
          Routes.MODULE_TEACHER,
          (route) => route.settings.name == Routes.MODULE_TEACHER,
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
