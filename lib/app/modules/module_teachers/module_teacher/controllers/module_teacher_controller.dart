import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/dialog_helper.dart';
import 'package:novasight_app/app/core/utils/show_modal_bottom_sheet_helper.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import '../views/widgets/chapter_detail_bottom_sheet.dart';
import '../views/widgets/module_detail_bottom_sheet.dart';

class ModuleTeacherController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ModuleTeacherController({
    TeacherRepository? teacherRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : teacherRepository = teacherRepository ??
            (Get.isRegistered<TeacherRepository>()
                ? Get.find<TeacherRepository>()
                : null),
        classroomRepository = classroomRepository ??
            (Get.isRegistered<ClassroomRepository>()
                ? Get.find<ClassroomRepository>()
                : null),
        storageService = storageService ??
            (Get.isRegistered<StorageService>()
                ? Get.find<StorageService>()
                : null);

  final TextEditingController searchController = TextEditingController();

  // Reactive State Variables (Adheres to Section 5 of flutter-implementation-requirements.md)
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<TeacherModuleModel> teacherModules = <TeacherModuleModel>[].obs;

  final Rx<TeacherModuleStatus> selectedStatus = TeacherModuleStatus.semua.obs;
  final RxString searchQuery = ''.obs;

  final RxBool isPublishing = false.obs;
  final RxInt publishingModuleId = 0.obs;

  final RxBool isDeleting = false.obs;
  final RxInt deletingModuleId = 0.obs;

  // Detail & Chapter Inspection States
  final RxBool isLoadingDetail = false.obs;
  final Rxn<TeacherModuleDetailModel> selectedModuleDetail =
      Rxn<TeacherModuleDetailModel>();

  final RxBool isLoadingChapter = false.obs;
  final Rxn<TeacherChapterDetailModel> selectedChapterDetail =
      Rxn<TeacherChapterDetailModel>();

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  late Worker _searchWorker;

  bool get isUsingApi => teacherRepository != null;

  @override
  void onInit() {
    super.onInit();
    onLoad();

    _searchWorker = debounce(
      searchQuery,
      (_) => onLoad(),
      time: const Duration(milliseconds: 400),
    );
  }

  int? _cachedClassroomId;
  final List<TeacherModuleModel> _masterModules = [];

  Future<int?> _resolveClassroomId({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedClassroomId != null) return _cachedClassroomId;
    if (classroomRepository == null) return null;
    final list = await classroomRepository!.getClassrooms();
    if (list.isEmpty) return null;
    final cachedCode = storageService?.getClassCode();
    final selected =
        list.firstWhereOrNull((c) => c.code == cachedCode) ?? list.first;
    _cachedClassroomId = selected.id;
    return selected.id;
  }

  void _sortNewestFirst(List<TeacherModuleModel> list) {
    list.sort((a, b) {
      final cmp = b.createdAt.compareTo(a.createdAt);
      if (cmp != 0) return cmp;
      return 0;
    });
  }

  void _applyLocalFilterAndSort() {
    if (_masterModules.isEmpty) return;

    List<TeacherModuleModel> filtered = List.from(_masterModules);

    if (selectedStatus.value != TeacherModuleStatus.semua) {
      filtered = filtered.where((m) {
        final st = (m.status ?? '').toLowerCase();
        return st == selectedStatus.value.value.toLowerCase();
      }).toList();
    }

    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((m) {
        return m.title.toLowerCase().contains(query);
      }).toList();
    }

    _sortNewestFirst(filtered);
    teacherModules.assignAll(filtered);
  }

  Future<void> onLoad({bool showLoading = true}) async {
    if (showLoading && teacherModules.isEmpty) {
      state.value = const UiStateLoading();
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      if (teacherRepository != null) {
        final classroomId = await _resolveClassroomId();

        if (classroomId != null) {
          final result = await teacherRepository!.getModules(
            classroomId: classroomId,
            search: searchQuery.value.trim().isEmpty
                ? null
                : searchQuery.value.trim(),
            status: selectedStatus.value,
          );

          _sortNewestFirst(result);
          teacherModules.value = result;

          if (selectedStatus.value == TeacherModuleStatus.semua &&
              searchQuery.value.trim().isEmpty) {
            _masterModules.clear();
            _masterModules.addAll(result);
          } else {
            for (final m in result) {
              final idx = _masterModules.indexWhere((item) => item.id == m.id);
              if (idx != -1) {
                _masterModules[idx] = m;
              } else {
                _masterModules.add(m);
              }
            }
          }

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

  void onChange(String value) {
    searchQuery.value = value;
    if (_masterModules.isNotEmpty) {
      _applyLocalFilterAndSort();
    }
  }

  void onSelectedStatus(TeacherModuleStatus status) {
    selectedStatus.value = status;
    _applyLocalFilterAndSort();
    onLoad(showLoading: false);
  }

  /// Aksi Publish Modul: POST /api/modules/publish/{module_id}
  Future<void> onPublishModule(TeacherModuleModel module) async {
    if (module.status?.toLowerCase() == 'publish') return;

    try {
      isPublishing.value = true;
      publishingModuleId.value = module.id;

      if (teacherRepository != null) {
        final success = await teacherRepository!.publishModule(module.id);
        if (success) {
          final index = teacherModules.indexWhere((m) => m.id == module.id);
          if (index != -1) {
            final updated = TeacherModuleModel(
              id: module.id,
              title: module.title,
              faseId: module.faseId,
              createdAt: module.createdAt,
              status: 'publish',
            );
            teacherModules[index] = updated;
            teacherModules.refresh();

            final mIndex = _masterModules.indexWhere((m) => m.id == module.id);
            if (mIndex != -1) {
              _masterModules[mIndex] = updated;
            }
          }

          if (selectedModuleDetail.value != null &&
              selectedModuleDetail.value!.id == module.id) {
            selectedModuleDetail.value = TeacherModuleDetailModel(
              id: selectedModuleDetail.value!.id,
              title: selectedModuleDetail.value!.title,
              faseId: selectedModuleDetail.value!.faseId,
              createdAt: selectedModuleDetail.value!.createdAt,
              status: 'publish',
              chapters: selectedModuleDetail.value!.chapters,
            );
          }

          SnackbarHelper.showSuccess(
            title: "Modul Berhasil Dipublikasikan!",
            message: "Siswa sekarang dapat mengakses modul ini.",
          );
        }
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Mempublikasikan Modul",
        message: e.message,
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Mempublikasikan Modul",
        message: e.toString(),
      );
    } finally {
      isPublishing.value = false;
      publishingModuleId.value = 0;
    }
  }

  /// Aksi Delete Modul: DELETE /api/teachers/modules/{module_id}?classroom_id={classroom_id}
  Future<void> onDeleteModule(TeacherModuleModel module) async {
    try {
      isDeleting.value = true;
      deletingModuleId.value = module.id;

      if (teacherRepository != null) {
        final classroomId = await _resolveClassroomId();
        if (classroomId == null) {
          SnackbarHelper.showError(
            title: "Gagal Menghapus Modul",
            message: "Kelas aktif tidak ditemukan.",
          );
          return;
        }

        final success = await teacherRepository!.deleteModule(
          moduleId: module.id,
          classroomId: classroomId,
        );

        if (success) {
          teacherModules.removeWhere((m) => m.id == module.id);
          _masterModules.removeWhere((m) => m.id == module.id);
          teacherModules.refresh();

          if (selectedModuleDetail.value != null &&
              selectedModuleDetail.value!.id == module.id) {
            selectedModuleDetail.value = null;
          }

          SnackbarHelper.showSuccess(
            title: "Modul Berhasil Dihapus",
            message: "Modul \"${module.title}\" telah berhasil dihapus.",
          );
        }
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Menghapus Modul",
        message: e.message,
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Menghapus Modul",
        message: e.toString(),
      );
    } finally {
      isDeleting.value = false;
      deletingModuleId.value = 0;
    }
  }

  /// Dialog konfirmasi hapus modul
  void confirmDeleteModule(BuildContext context, TeacherModuleModel module) {
    DialogHelper.show(
      title: "Hapus Modul",
      description:
          'Anda yakin ingin menghapus "${module.title}"? Seluruh bab dan anotasi di dalamnya akan terhapus secara permanen.',
      colorDescription: ColorConstant.textDarkGreyColor,
      icon: SvgPicture.asset(
        SvgConstant.iconTrashConfirmation,
        width: Dimens.iconBigSize,
        height: Dimens.iconBigSize,
      ),
      actions: CommonButtonWidget(
        buttonName: "Konfirmasi",
        buttonColor: ColorConstant.redColor,
        onPressed: () {
          Get.back();
          onDeleteModule(module);
        },
      ),
    );
  }

  /// Aksi Detail Modul: GET /api/teachers/modules/{module_id}
  Future<TeacherModuleDetailModel?> fetchModuleDetail(int moduleId) async {
    if (teacherRepository == null) return null;
    isLoadingDetail.value = true;
    selectedModuleDetail.value = null;

    try {
      final classroomId = await _resolveClassroomId();
      if (classroomId == null) return null;

      final detail = await teacherRepository!.getModuleDetail(
        moduleId: moduleId,
        classroomId: classroomId,
      );
      selectedModuleDetail.value = detail;
      return detail;
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Memuat Detail Modul",
        message: e.message,
      );
      return null;
    } catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Memuat Detail Modul",
        message: e.toString(),
      );
      return null;
    } finally {
      isLoadingDetail.value = false;
    }
  }

  /// Aksi Detail Chapter: GET /api/teachers/chapters/{chapter_id}
  Future<TeacherChapterDetailModel?> fetchChapterDetail(int chapterId) async {
    if (teacherRepository == null) return null;
    isLoadingChapter.value = true;
    selectedChapterDetail.value = null;

    try {
      final detail = await teacherRepository!.getChapterDetail(
        chapterId: chapterId,
      );
      selectedChapterDetail.value = detail;
      return detail;
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Memuat Detail Bab",
        message: e.message,
      );
      return null;
    } catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Memuat Detail Bab",
        message: e.toString(),
      );
      return null;
    } finally {
      isLoadingChapter.value = false;
    }
  }

  void showModuleDetailModal(BuildContext context, TeacherModuleModel module) {
    fetchModuleDetail(module.id);
    ShowModalBottomSheetHelper.showCustomBottomSheet(
      ModuleDetailBottomSheet(module: module),
    );
  }

  void showChapterDetailModal(BuildContext context, int chapterId) {
    fetchChapterDetail(chapterId);
    ShowModalBottomSheetHelper.showCustomBottomSheet(
      ChapterDetailBottomSheet(chapterId: chapterId),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    _searchWorker.dispose();
    super.onClose();
  }
}
