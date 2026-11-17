import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/core/utils/snackbar_helper.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/auth/create_class/controllers/create_class_controller.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/views/widgets/add_class_bottom_sheet.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/views/widgets/change_class_bottom_sheet.dart';

import '../../../core/utils/show_modal_bottom_sheet_helper.dart';
import '../../main_layout/controllers/main_layout_controller.dart';

class TeacherDashboardController extends CreateClassController {
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
        storageService = storageService ?? Get.find<StorageService>(),
        super(repository: classroomRepository ?? Get.find<ClassroomRepository>());

  MainLayoutController? mainController;

  final RxString classCode = ''.obs;
  final RxString className = ''.obs;
  final RxString classSubtitle = ''.obs;
  final RxString teacherName = ''.obs;
  final RxBool isLoadingClassroom = false.obs;
  final RxList<ClassroomResponseModel> classrooms = <ClassroomResponseModel>[].obs;
  final Rxn<ClassroomResponseModel> selectedClassroom = Rxn<ClassroomResponseModel>();

  // Dashboard Reactive States (Adheres to Section 5 of flutter-implementation-requirements.md)
  final RxBool isLoadingDashboard = false.obs;
  final RxString dashboardErrorMessage = ''.obs;
  final Rxn<TeacherDashboardModel> dashboardData = Rxn<TeacherDashboardModel>();

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

  Future<void> onSelectedClassroom(ClassroomResponseModel classroom) async {
    if (selectedClassroom.value?.id == classroom.id) return;

    selectedClassroom.value = classroom;
    classCode.value = classroom.code;
    className.value = classroom.name;
    classSubtitle.value = '${classroom.classroomType.name} • Kelas ${classroom.grade}';

    await Future.wait([
      storageService.writeClassId(classroom.id),
      storageService.writeClassCode(classroom.code),
      storageService.writeClassName(classroom.name),
    ]);

    if (selectedClassroom.value?.id != classroom.id) return;

    await fetchDashboard(classroomId: classroom.id);
  }

  Future<void> onDeleteClassroom(ClassroomResponseModel classroom) async {
    try {
      isLoadingClassroom.value = true;

      await classroomRepository.deleteByIdClassrooms(classroom.id);

      classrooms.removeWhere((c) => c.id == classroom.id);

      if (selectedClassroom.value?.id == classroom.id) {
        if (classrooms.isNotEmpty) {
          final nextClass = classrooms.first;
          await onSelectedClassroom(nextClass);
        } else {
          selectedClassroom.value = null;
          classCode.value = '';
          className.value = '';
          classSubtitle.value = '';
          dashboardData.value = null;

          await Future.wait([
            storageService.writeClassId(0),
            storageService.writeClassCode(''),
            storageService.writeClassName(''),
          ]);
        }
      }

      SnackbarHelper.showSuccess(
        title: "Kelas Berhasil Dihapus",
        message: "Kelas \"${classroom.name}\" telah dihapus.",
      );
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Menghapus Kelas",
        message: e.message,
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Menghapus Kelas",
        message: "Terjadi kesalahan saat menghapus kelas.",
      );
    } finally {
      isLoadingClassroom.value = false;
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

      // Discard stale response if the user switched to another classroom
      if (selectedClassroom.value != null &&
          selectedClassroom.value!.id != classroomId) {
        return;
      }

      dashboardData.value = result;

      if (result.classroomInfo != null) {
        if (result.classroomInfo!.code != null &&
            result.classroomInfo!.code!.isNotEmpty) {
          classCode.value = result.classroomInfo!.code!;
        }
        classSubtitle.value =
        '${result.classroomInfo!.classroomType} • Kelas ${result.classroomInfo!.gradeClass}';
      }
      if (result.teacherEmail.isNotEmpty) {
        teacherName.value = result.teacherEmail;
      }
    } on ApiException catch (e) {
      if (selectedClassroom.value == null ||
          selectedClassroom.value!.id == classroomId) {
        dashboardErrorMessage.value = e.message;
      }
    } catch (e) {
      if (selectedClassroom.value == null ||
          selectedClassroom.value!.id == classroomId) {
        dashboardErrorMessage.value =
        'Terjadi kesalahan saat memuat dashboard: ${e.toString()}';
      }
    } finally {
      if (selectedClassroom.value == null ||
          selectedClassroom.value!.id == classroomId) {
        isLoadingDashboard.value = false;
      }
    }
  }

  Future<void> refreshDashboard() async {
    await fetchClassrooms();
  }

  void showModuleAddClassModal(BuildContext context) {
    super.loadInitialData();
    ShowModalBottomSheetHelper.showCustomBottomSheet(
      const AddClassBottomSheet(),
    );
  }

  void showModuleSelectClassModal(BuildContext context) {
    ShowModalBottomSheetHelper.showCustomBottomSheet(
      const ChangeClassBottomSheet(),
    );
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

  @override
  Future<void> onCreateClass() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }
    if (!isValid.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdClass = await repository.createClassroom(
        name: nameClass.text.trim(),
        classroomTypeId: selectedClassroomType.value!.id,
        schoolId: selectedSchool.value!.id,
        grade: selectedGrade.value!,
      );

      try {
        if (Get.isRegistered<StorageService>()) {
          final storage = Get.find<StorageService>();
          await storage.writeClassCode(createdClass.code);
          await storage.writeClassName(createdClass.name);
        }
      } catch (_) {}

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }
      SnackbarHelper.showSuccess(
        title: "Kelas Berhasil Dibuat!",
        message: "Kelas baru telah berhasil dibuat.",
      );

    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(
        title: "Gagal Membuat Kelas",
        message: e.message,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan tidak terduga.';
      SnackbarHelper.showError(
        title: "Gagal Membuat Kelas",
        message: 'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
