import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/main.dart';

import '../../main_layout/controllers/main_layout_controller.dart';

class TeacherDashboardController extends GetxController {
  final ClassroomRepository classroomRepository;
  final StorageService storageService;

  TeacherDashboardController({
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : classroomRepository =
            classroomRepository ?? Get.find<ClassroomRepository>(),
        storageService = storageService ?? Get.find<StorageService>();

  MainLayoutController? mainController;

  final RxString classCode = ''.obs;
  final RxString className = ''.obs;
  final RxString classSubtitle = ''.obs;
  final RxString teacherName = ''.obs;
  final RxBool isLoadingClassroom = false.obs;
  final RxList<ClassroomResponseModel> classrooms =
      <ClassroomResponseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<MainLayoutController>()) {
      mainController = Get.find<MainLayoutController>();
    }
    _loadInitialCache();
    fetchClassrooms();
  }

  void _loadInitialCache() {
    final cachedCode = storageService.getClassCode();
    if (cachedCode != null && cachedCode.isNotEmpty) {
      classCode.value = cachedCode;
    }
    final cachedName = storageService.getClassName();
    if (cachedName != null && cachedName.isNotEmpty) {
      className.value = cachedName;
    }
    final user = storageService.getUserName();
    if (user != null && user.isNotEmpty) {
      teacherName.value = user;
    }
  }

  Future<void> fetchClassrooms() async {
    try {
      isLoadingClassroom.value = true;
      final result = await classroomRepository.getClassrooms();
      classrooms.value = result;

      if (result.isNotEmpty) {
        // If there is a cached class code, prioritize it, otherwise take the latest
        final cachedCode = storageService.getClassCode();
        final selected = result.firstWhereOrNull((c) => c.code == cachedCode) ??
            result.last;

        classCode.value = selected.code;
        className.value = selected.name;
        classSubtitle.value =
            '${selected.classroomType.name} - Kelas ${selected.grade}';

        await storageService.writeClassCode(selected.code);
        await storageService.writeClassName(selected.name);
      }
    } catch (_) {
      // Keep cached values if fetch fails
    } finally {
      isLoadingClassroom.value = false;
    }
  }

  Future<void> onCopyClassCode() async {
    if (classCode.value.isEmpty) {
      SnackbarHelper.showError(
        title: 'Tidak Ada Kode',
        message: 'Belum ada kode kelas yang tersedia untuk disalin.',
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: classCode.value));
    SnackbarHelper.showSuccess(
      title: 'Berhasil',
      message: 'Kode kelas ${classCode.value} berhasil disalin.',
    );
  }

  void onSeeAllExam() {
    mainController?.changePage(MainBarTeacher.exam.index);
  }

  void onSeeAllModule() {
    mainController?.changePage(MainBarTeacher.module.index);
  }
}
