import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

import '../../main_layout/controllers/main_layout_controller.dart';

class TeacherDashboardController extends GetxController {
  final ClassroomRepository classroomRepository;
  final TeacherRepository? teacherRepository;
  final StorageService storageService;

  TeacherDashboardController({
    ClassroomRepository? classroomRepository,
    TeacherRepository? teacherRepository,
    StorageService? storageService,
  })  : classroomRepository =
            classroomRepository ?? Get.find<ClassroomRepository>(),
        teacherRepository = teacherRepository ??
            (Get.isRegistered<TeacherRepository>()
                ? Get.find<TeacherRepository>()
                : null),
        storageService = storageService ?? Get.find<StorageService>();

  MainLayoutController? mainController;

  final RxString classCode = ''.obs;
  final RxString className = ''.obs;
  final RxString classSubtitle = ''.obs;
  final RxString teacherName = ''.obs;
  final RxBool isLoadingClassroom = false.obs;
  final RxList<ClassroomResponseModel> classrooms =
      <ClassroomResponseModel>[].obs;
  final Rxn<ClassroomResponseModel> selectedClassroom =
      Rxn<ClassroomResponseModel>();

  // Dashboard Reactive States (Adheres to Section 5 of flutter-implementation-requirements.md)
  final RxBool isLoadingDashboard = false.obs;
  final RxString dashboardErrorMessage = ''.obs;
  final Rxn<TeacherDashboardModel> dashboardData =
      Rxn<TeacherDashboardModel>();

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

        selectedClassroom.value = selected;
        classCode.value = selected.code;
        className.value = selected.name;
        classSubtitle.value =
            '${selected.classroomType.name} - Kelas ${selected.grade}';

        await storageService.writeClassCode(selected.code);
        await storageService.writeClassName(selected.name);

        await fetchDashboard(classroomId: selected.id);
      } else {
        dashboardErrorMessage.value = 'Belum ada kelas yang dibuat.';
      }
    } catch (_) {
      // Keep cached values if fetch fails
    } finally {
      isLoadingClassroom.value = false;
    }
  }

  Future<void> fetchDashboard({required int classroomId}) async {
    if (teacherRepository == null) return;
    try {
      isLoadingDashboard.value = true;
      dashboardErrorMessage.value = '';
      final result = await teacherRepository!.getDashboard(
        classroomId: classroomId,
      );
      dashboardData.value = result;

      if (result.classroomInfo != null) {
        if (result.classroomInfo!.code != null &&
            result.classroomInfo!.code!.isNotEmpty) {
          classCode.value = result.classroomInfo!.code!;
        }
        classSubtitle.value =
            '${result.classroomInfo!.classroomType} - Kelas ${result.classroomInfo!.gradeClass}';
      }
      if (result.teacherEmail.isNotEmpty) {
        teacherName.value = result.teacherEmail;
      }
    } on ApiException catch (e) {
      dashboardErrorMessage.value = e.message;
    } catch (e) {
      dashboardErrorMessage.value =
          'Terjadi kesalahan saat memuat dashboard: ${e.toString()}';
    } finally {
      isLoadingDashboard.value = false;
    }
  }

  Future<void> refreshDashboard() async {
    await fetchClassrooms();
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
