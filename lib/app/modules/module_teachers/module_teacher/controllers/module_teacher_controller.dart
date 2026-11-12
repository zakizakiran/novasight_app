import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/core/dimens.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/styles/svg/svg_constant.dart';
import 'package:lydera_app/app/core/utils/correction_controller.dart';
import 'package:lydera_app/app/core/utils/dialog_helper.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/core/utils/show_modal_bottom_sheet_helper.dart';
import 'package:lydera_app/app/core/utils/snackbar_helper.dart';
import 'package:lydera_app/app/core/utils/ui_state.dart';
import 'package:lydera_app/app/data/model/module_teacher_model.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import '../../../../data/models/job_response.dart';
import '../../../../data/models/student_model.dart';
import '../views/widgets/chapter_detail_bottom_sheet.dart';
import '../views/widgets/module_detail_bottom_sheet.dart';

class ModuleTeacherController extends GetxController implements CorrectionAIController, CorrectionNormalTextController, SelectChunkController {
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
  @override
  final TextEditingController adviceController = TextEditingController();
  @override
  final TextEditingController textEditController = TextEditingController();

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
  final Rxn<TeacherModuleDetailModel> selectedModuleDetail = Rxn<TeacherModuleDetailModel>();

  final RxBool isLoadingChapter = false.obs;
  final Rxn<TeacherChapterDetailModel> selectedChapterDetail = Rxn<TeacherChapterDetailModel>();

  final RxBool _isValid = false.obs;
  final RxBool _isLoadingRevision = false.obs;
  final RxBool _isTextValid = false.obs;

  List<TeacherChapterSummaryModel> get chaptersJobs {
    final chapters = selectedModuleDetail.value?.chapters ?? [];
    return chapters.where((element) {
      final job = element.job;
      if (job == null) return false;
      final isInProgress = job.isInProgress;
      final needsReview = element.isNeedReview || (job.isDone && !job.isReviewed.value);

      return isInProgress;
    }).toList();
  }

  @override
  RxBool get isValid => _isValid;

  @override
  RxBool get isLoadingRevision => _isLoadingRevision;

  @override
  RxBool get isTextValid => _isTextValid;

  final RxList<BlockResponseModel> selectedBlocks = <BlockResponseModel>[].obs;

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  late Worker _searchWorker;

  bool get isUsingApi => teacherRepository != null;

  bool get isTextSelected => selectedBlocks.isNotEmpty && selectedBlocks.every((c) => !c.isRevisionWithAI);

  bool get canSelectAllSpecial => selectedBlocks.value.where((element) => element.isRevisionWithAI).isNotEmpty;

  bool get isAllSpecialSelected {
    final specials = selectedBlocks.value.where((element) => element.isRevisionWithAI).toList();
    return specials.isNotEmpty && selectedBlocks.length == specials.length && specials.every((s) => selectedBlocks.contains(s));
  }

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

  @override
  void onSelectChunk(ModuleChunk chunk) {
    if (isLoadingRevision.value) return;
    final block = chunk.toBlockResponseModel();

    final selectedIndex = selectedBlocks.indexWhere(
          (item) => item.id == block.id,
    );

    if (selectedIndex != -1) {
      selectedBlocks.removeAt(selectedIndex);
      return;
    }

    if (selectedBlocks.isEmpty) {
      if (block.isRevisionWithAI) {
        selectedBlocks.add(block);
      } else {
        selectedBlocks.assignAll([block]);
        prepareTextEdit();
      }
      return;
    }

    final firstBlock = selectedBlocks.first;
    final isSameType = block.isRevisionWithAI == firstBlock.isRevisionWithAI;

    if (!isSameType) {
      SnackbarHelper.showError(
        title: 'Pilih Block',
        message: 'Mempunyai tipe yang berbeda untuk revisi',
      );
      return;
    }

    if (block.isRevisionWithAI) {
      selectedBlocks.add(block);
      return;
    }

    selectedBlocks.assignAll([block]);
    prepareTextEdit();
    return;
  }

  void toggleSelectAllSpecial() {
    if (isLoadingRevision.value) return;

    final specials = selectedBlocks.value.where((element) => element.isRevisionWithAI);
    if (specials.isEmpty) return;

    if (isAllSpecialSelected) {
      selectedBlocks.clear();
    } else {
      selectedBlocks.clear();
      selectedBlocks.addAll(specials);
    }
  }

  @override
  Future<void> onSendAdvice() async {
    final feedback = adviceController.text.trim();
    if (feedback.isEmpty || selectedBlocks.isEmpty) return;

    isLoadingRevision.value = true;
    try {
      final blockRevisionAIIds = selectedBlocks.where((element) => element.isRevisionWithAI,).map((e) => e.id).whereType<int>().toList();


      if (teacherRepository != null && blockRevisionAIIds.isNotEmpty) {
        final results = await teacherRepository!.bulkRegenerateSpecial(
          blockIds: blockRevisionAIIds,
          feedback: feedback,
        );

        final current = selectedChapterDetail.value;

        final updatedList = current?.blocks.map((c) {
          final match = results.firstWhereOrNull((r) => r.blockId == c.id);
          if (match != null) {
            return c.copyWith(readableText: match.readableText);
          }
          return c;
        }).toList();

        selectedChapterDetail.value = current?.copyWith(blocks: updatedList);
      }

      if (Get.isBottomSheetOpen ?? false) {
        Get.back();
      }

      selectedBlocks.clear();
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
      isLoadingRevision.value = false;
    }
  }

  @override
  Future<void> onSaveDirectText() async {
    if (selectedBlocks.isEmpty || selectedBlocks.first.isRevisionWithAI) return;

    final chunk = selectedBlocks.first;
    final newText = textEditController.text.trim();

    if (newText.isEmpty) return;

    if (teacherRepository != null) {
      await teacherRepository!.bulkRegenerateText(
        blockIds: [?chunk.id],
        feedback: newText,
      );
    }

    final current = selectedChapterDetail.value;
    final updatedList = current?.blocks.map((c) {
      if (c.id == chunk.id) {
        return c.copyWith(readableText: newText);
      }
      return c;
    }).toList();

    selectedChapterDetail.value = current?.copyWith(blocks: updatedList);
    selectedBlocks.clear();
    textEditController.clear();

    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
    SnackbarHelper.showSuccess(
      title: "Anotasi Teks Disimpan!",
      message: "Perubahan anotasi berhasil disimpan.",
    );
  }

  void prepareTextEdit() {
    if (selectedBlocks.isEmpty || selectedBlocks.first.isRevisionWithAI) return;
    final chunk = selectedBlocks.first;
    textEditController.text = chunk.readableText;
    isTextValid.value = textEditController.text.trim().isNotEmpty;
  }

  @override
  void onTextChange(String v) {
    isTextValid.value = v.trim().isNotEmpty;
  }

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

  void addChapter(TeacherChapterSummaryModel newChapter) {
    final detail = selectedModuleDetail.value;
    if (detail == null) return;

    detail.chapters.add(newChapter);
    _startTrackingChapterJobs([newChapter]);
    selectedModuleDetail.refresh();
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

  /// Aksi Draft Modul: POST /api/modules/draft/{module_id}
  Future<void> onDraftModule(TeacherModuleModel module) async {
    if (module.status?.toLowerCase() == 'draft') return;

    try {
      isPublishing.value = true;
      publishingModuleId.value = module.id;

      if (teacherRepository != null) {
        final success = await teacherRepository!.draftModule(module.id);
        if (success) {
          final index = teacherModules.indexWhere((m) => m.id == module.id);
          if (index != -1) {
            final updated = TeacherModuleModel(
              id: module.id,
              title: module.title,
              faseId: module.faseId,
              createdAt: module.createdAt,
              status: 'draft',
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
              status: 'draft',
              chapters: selectedModuleDetail.value!.chapters,
            );
          }

          SnackbarHelper.showSuccess(
            title: "Modul Berhasil Menjadi draft!",
            message: "Siswa sekarang tidak dapat mengakses modul ini.",
          );
        }
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Menjadi Draft Modul",
        message: e.message,
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Menjadi Draft Modul",
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
      title: context.l10n.deleteModule,
      description: context.l10n.deleteModuleConfirm(module.title),
      colorDescription: ColorConstant.textDarkGreyColor,
      icon: SvgPicture.asset(
        SvgConstant.iconTrashConfirmation,
        width: Dimens.iconBigSize,
        height: Dimens.iconBigSize,
      ),
      actions: CommonButtonWidget(
        buttonName: context.l10n.confirm,
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
    _cancelAllJobStreams();
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
      _startTrackingChapterJobs(chaptersJobs);
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
    adviceController.dispose();
    textEditController.dispose();
    _searchWorker.dispose();
    _cancelAllJobStreams();
    super.onClose();
  }

  @override
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  final GlobalKey<FormState> textFormKey = GlobalKey<FormState>();

  @override
  RxList<ModuleChunk> get selectedChunks => RxList(selectedBlocks.map((block) => block.toModuleChunk()).toList());

  @override
  void onChangeAdviceController(String value) {
    isValid.value = adviceController.text.isNotEmpty && selectedBlocks.isNotEmpty;
  }

  void _startTrackingChapterJobs(List<TeacherChapterSummaryModel> chapters) {
    if (teacherRepository == null) return;

    for (final chapter in chapters) {
      final job = chapter.job;
      if (job == null || job.isDone || job.isFailed) continue;

      // Skip if this job already has an active stream subscription
      if (job.subscription != null) continue;

      job.subscription = teacherRepository?.streamChapterJob(job.id).listen(
            (event) {
          // Update reactive fields on the JobResponse model
          job.progress.value = event.progress;
          job.status.value = JobStatus.fromString(event.status.toLowerCase());

          if (event.annotationPath != null && event.annotationPath!.isNotEmpty) {
            job.pdfPath.value = event.annotationPath!;
          }

          // Stop listening once the job finishes or fails
          if (event.isDone || event.isFailed) {
            job.dispose();
            job.subscription = null;
            selectedModuleDetail.refresh();
          }
        },
        onError: (error) {
          job.status.value = JobStatus.failed;
          job.dispose();
          job.subscription = null;
          selectedModuleDetail.refresh();
        },
      );
    }
  }

  void _cancelAllJobStreams() {
    final chapters = selectedModuleDetail.value?.chapters ?? [];
    for (final chapter in chapters) {
      chapter.job?.dispose();
      chapter.job?.subscription = null;
    }
  }
}
