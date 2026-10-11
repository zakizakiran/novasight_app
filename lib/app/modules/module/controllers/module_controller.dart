import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/models/module_model.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ModuleController extends GetxController {
  final StudentRepository? studentRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ModuleController({
    StudentRepository? studentRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : studentRepository = studentRepository ??
            (Get.isRegistered<StudentRepository>()
                ? Get.find<StudentRepository>()
                : null),
        classroomRepository = classroomRepository ??
            (Get.isRegistered<ClassroomRepository>()
                ? Get.find<ClassroomRepository>()
                : null),
        storageService = storageService ??
            (Get.isRegistered<StorageService>()
                ? Get.find<StorageService>()
                : null);

  final selectedStatus = ModuleStatus.all.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  // Real student modules from API
  final RxList<StudentModuleModel> studentModules = <StudentModuleModel>[].obs;


  bool get hasApiModules => studentModules.isNotEmpty;

  StudentModuleStatus _mapToStudentModuleStatus(ModuleStatus status) {
    switch (status) {
      case ModuleStatus.all:
        return StudentModuleStatus.semua;
      case ModuleStatus.notDone:
        return StudentModuleStatus.belumSelesai;
      case ModuleStatus.done:
        return StudentModuleStatus.selesai;
    }
  }

  Future<void> onLoad() async {
    state.value = const UiStateLoading();
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 1. Try loading from Student API if StudentRepository is available
      if (studentRepository != null) {
        int? classroomId;
        if (classroomRepository != null) {
          final list = await classroomRepository!.getClassrooms();
          if (list.isNotEmpty) {
            final cachedCode = storageService?.getClassCode();
            final selected = list.firstWhereOrNull((c) => c.code == cachedCode) ??
                list.first;
            classroomId = selected.id;
          }
        }

        if (classroomId != null) {
          final statusFilter = _mapToStudentModuleStatus(selectedStatus.value);
          final result = await studentRepository!.getModules(
            classroomId: classroomId,
            status: statusFilter,
          );
          studentModules.value = result;
          state.value = const UiStateSuccess(null);
          return;
        }
      }
      state.value = const UiStateSuccess(null);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      state.value = UiStateFailure(e.message);
    } catch (e) {
      errorMessage.value = e.toString();
      state.value = UiStateFailure(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onChangeStatus(ModuleStatus status) {
    selectedStatus.value = status;
    onLoad();
  }

  void updateModuleProgressLocally({
    required int moduleId,
    required int progressPercentage,
    required bool isDone,
  }) {
    final index = studentModules.indexWhere((m) => m.id == moduleId);
    if (index != -1) {
      final old = studentModules[index];
      final newProgress = old.progress != null
          ? old.progress!.copyWith(
              progressPercentage: progressPercentage,
              isDone: isDone,
            )
          : ModuleProgressModel(
              id: 0,
              studentId: 0,
              moduleId: moduleId,
              progressPercentage: progressPercentage,
              isDone: isDone,
            );
      studentModules[index] = old.copyWith(progress: newProgress);
      studentModules.refresh();
    }
  }

  Future<void> onDetailStudent(StudentModuleModel module) async {
    await Get.toNamed(
      Routes.MODULE_DETAIL,
      arguments: module.id,
    );
    await onLoad();
  }

  Future<void> onDetail(ModuleModel module) async {
    await Get.toNamed(
      Routes.MODULE_DETAIL,
      arguments: module.id,
    );
    await onLoad();
  }

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }
}
