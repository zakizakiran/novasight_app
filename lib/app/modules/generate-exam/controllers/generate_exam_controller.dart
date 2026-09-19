import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/models/quiz_teacher_model.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/exam-teachers/controllers/exam_teachers_controller.dart';
import '../../../core/args/main_bar_args.dart';
import '../../../core/utils/user_roles.dart';
import '../../../routes/app_pages.dart';
import '../models/chapter_exam_config.dart';
import '../models/generated_question.dart';

class GenerateExamController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  GenerateExamController({
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

  // Stepper State (0: Pilih Modul, 1: Konfigurasi, 2: AI Generate & Review)
  final currentStep = 0.obs;

  // Step 1: Modul Sumber
  final selectedModuleId = Rx<int?>(null);
  final selectedModuleName = ''.obs;
  final selectedModule = Rxn<TeacherModuleModel>();
  final availableModules = <TeacherModuleModel>[].obs;
  final isLoadingModules = false.obs;
  final isLoadingChapters = false.obs;

  // Step 2: Konfigurasi Endpoint Real
  final titleController = TextEditingController();
  final maxDurationMinutes = 60.obs; // Durasi dalam menit (> 0)
  final maxRetry = 1.obs; // Maksimal pengulangan (default 1)
  final startTime = DateTime.now().add(const Duration(minutes: 5)).obs;
  final endTime = DateTime.now().add(const Duration(days: 7)).obs;

  // Bab-bab dari modul & distribusi HOTS / LOTS
  final chapterConfigs = <ChapterExamConfig>[].obs;

  // Legacy compatibility fields
  final numberOfQuestions = 10.obs;
  final answerOptions = 'A-E'.obs;
  final difficulty = 'Campuran'.obs;

  // Step 3: Loading/AI
  final isGenerating = false.obs;
  final generatedCount = 0.obs;
  final totalTargetCount = 0.obs;
  final generationStatusMessage = 'Menyiapkan pembuatan soal...'.obs;
  final createdQuizRequestId = Rx<int?>(null);

  // List Soal yang di-generate
  final generatedQuestions = <GeneratedQuestion>[].obs;

  // Backup saat diedit
  final Map<int, GeneratedQuestion> editingCache = {};

  int? _cachedClassroomId;
  StreamSubscription<QuizStreamEvent>? _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    loadModules();
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    titleController.dispose();
    super.onClose();
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

  Future<void> loadModules() async {
    if (teacherRepository == null) return;
    isLoadingModules.value = true;
    try {
      final classroomId = await _resolveClassroomId();
      if (classroomId == null) return;

      final result = await teacherRepository!.getModules(
        classroomId: classroomId,
      );
      availableModules.assignAll(result);

      // Auto-select first if available
      if (result.isNotEmpty && selectedModuleId.value == null) {
        selectModule(result.first);
      }
    } catch (e) {
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Gagal memuat modul: ${e.toString()}',
      );
    } finally {
      isLoadingModules.value = false;
    }
  }

  Future<void> selectModule(TeacherModuleModel module) async {
    selectedModuleId.value = module.id;
    selectedModuleName.value = module.title;
    selectedModule.value = module;

    // Fetch chapters for this module
    await loadChaptersForModule(module.id);
  }

  Future<void> loadChaptersForModule(int moduleId) async {
    if (teacherRepository == null) return;
    isLoadingChapters.value = true;
    try {
      final classroomId = await _resolveClassroomId();
      if (classroomId == null) return;

      final detail = await teacherRepository!.getModuleDetail(
        classroomId: classroomId,
        moduleId: moduleId,
      );

      final configs = detail.chapters.map((ch) {
        return ChapterExamConfig(
          chapterId: ch.id,
          title: ch.title != null && ch.title!.isNotEmpty
              ? ch.title!
              : (ch.number != null ? 'Bab ${ch.number}' : 'Bab #${ch.id}'),
          number: ch.number,
          isSelected: true,
          hotsCount: 2,
          lotsCount: 3,
        );
      }).toList();

      chapterConfigs.assignAll(configs);
      _updateCalculatedTotals();
    } catch (e) {
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Gagal memuat bab modul: ${e.toString()}',
      );
    } finally {
      isLoadingChapters.value = false;
    }
  }

  void _updateCalculatedTotals() {
    numberOfQuestions.value = totalQuestions;
  }

  int get totalHots {
    return chapterConfigs
        .where((c) => c.isSelected.value)
        .fold(0, (sum, c) => sum + c.hotsCount.value);
  }

  int get totalLots {
    return chapterConfigs
        .where((c) => c.isSelected.value)
        .fold(0, (sum, c) => sum + c.lotsCount.value);
  }

  int get totalQuestions => totalHots + totalLots;

  List<ChapterExamConfig> get activeChapters =>
      chapterConfigs.where((c) => c.isSelected.value).toList();

  void setDuration(int minutes) {
    if (minutes > 0) {
      maxDurationMinutes.value = minutes;
    }
  }

  void setMaxRetry(int retry) {
    if (retry >= 1) {
      maxRetry.value = retry;
    }
  }

  void setDateRange({required DateTime start, required DateTime end}) {
    startTime.value = start;
    endTime.value = end;
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (selectedModuleId.value == null) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Pilih modul sumber terlebih dahulu',
        );
        return;
      }
      currentStep.value++;
    } else if (currentStep.value == 1) {
      final title = titleController.text.trim();
      if (title.isEmpty) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Masukkan judul kuis / ujian',
        );
        return;
      }
      if (activeChapters.isEmpty) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Pilih minimal satu bab untuk kuis',
        );
        return;
      }
      if (totalQuestions <= 0) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Total jumlah soal (HOTS + LOTS) minimal 1 soal',
        );
        return;
      }
      final now = DateTime.now();
      if (startTime.value.isBefore(now)) {
        startTime.value = now.add(const Duration(minutes: 2));
      }
      if (endTime.value.isBefore(startTime.value)) {
        endTime.value = startTime.value.add(Duration(minutes: maxDurationMinutes.value + 60));
      }

      currentStep.value++;
      startGeneration();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  Future<void> startGeneration() async {
    if (teacherRepository == null) return;

    final classroomId = await _resolveClassroomId();
    if (classroomId == null) {
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Kelas tidak ditemukan.',
      );
      return;
    }

    isGenerating.value = true;
    generatedCount.value = 0;
    totalTargetCount.value = totalQuestions;
    generationStatusMessage.value = 'Memulai pembuatan soal...';
    generatedQuestions.clear();
    editingCache.clear();

    // Pastikan start_time tidak di masa lalu (validator FastAPI: 'Waktu mulai (start_time) tidak boleh di masa lalu.')
    final now = DateTime.now();
    DateTime effectiveStartTime = startTime.value;
    if (effectiveStartTime.isBefore(now.add(const Duration(seconds: 30)))) {
      effectiveStartTime = now.add(const Duration(minutes: 2));
      startTime.value = effectiveStartTime;
    }

    DateTime effectiveEndTime = endTime.value;
    if (effectiveEndTime.isBefore(effectiveStartTime)) {
      effectiveEndTime = effectiveStartTime.add(Duration(minutes: maxDurationMinutes.value + 60));
      endTime.value = effectiveEndTime;
    }

    final payload = QuizRequestCreatePayload(
      classroomId: classroomId,
      moduleId: selectedModuleId.value!,
      title: titleController.text.trim(),
      chapters: activeChapters.map((c) => c.toRequest()).toList(),
      maxDurationMinutes: maxDurationMinutes.value,
      maxRetry: maxRetry.value,
      startTime: effectiveStartTime,
      endTime: effectiveEndTime,
    );

    try {
      debugPrint('[GenerateExamController] Calling createQuizStream with payload: title="${payload.title}", chapters=${payload.chapters.length}, start=${payload.startTime}, end=${payload.endTime}');
      final stream = teacherRepository!.createQuizStream(payload);
      _streamSubscription?.cancel();
      _streamSubscription = stream.listen(
        (event) async {
          debugPrint('[GenerateExamController] Received event -> status: "${event.status}", msg: "${event.message}", completed: ${event.completed}/${event.total}');
          if (event.quizRequestId != null) {
            createdQuizRequestId.value = event.quizRequestId;
          }
          if (event.total > 0) {
            totalTargetCount.value = event.total;
          }
          generatedCount.value = event.completed;
          if (event.message.isNotEmpty) {
            generationStatusMessage.value = event.message;
          }

          if (event.status == 'done') {
            await _onGenerationDone(classroomId);
          } else if (event.status == 'failed') {
            isGenerating.value = false;
            final failMsg = event.message.isNotEmpty ? event.message : 'Server gagal memproses pembuatan soal ujian.';
            debugPrint('[GenerateExamController] Generation marked as failed: $failMsg');
            SnackbarHelper.showError(
              title: 'Pembuatan Soal Gagal',
              message: failMsg,
            );
          }
        },
        onError: (err) {
          isGenerating.value = false;
          debugPrint('[GenerateExamController] Stream onError: $err');
          SnackbarHelper.showError(
            title: 'Koneksi Terputus',
            message: 'Gagal mendengarkan proses pembuatan soal: $err',
          );
        },
        onDone: () async {
          debugPrint('[GenerateExamController] Stream onDone. isGenerating: ${isGenerating.value}, createdId: ${createdQuizRequestId.value}');
          if (isGenerating.value && createdQuizRequestId.value != null) {
            await _onGenerationDone(classroomId);
          }
        },
      );
    } on ApiException catch (e) {
      isGenerating.value = false;
      debugPrint('[GenerateExamController] ApiException caught: "${e.message}" (Status: ${e.statusCode})');
      SnackbarHelper.showError(
        title: 'Gagal Membuat Soal',
        message: e.message,
      );
    } catch (e, stack) {
      isGenerating.value = false;
      debugPrint('[GenerateExamController] Unexpected catch: $e\n$stack');
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Terjadi kesalahan: ${e.toString()}',
      );
    }
  }

  Future<void> _onGenerationDone(int classroomId) async {
    try {
      if (createdQuizRequestId.value != null) {
        final detail = await teacherRepository!.getQuizDetail(
          quizId: createdQuizRequestId.value!,
          classroomId: classroomId,
        );

        final questions = detail.questions
            .map((q) => GeneratedQuestion.fromQuizRequestQuestion(q))
            .toList();

        if (questions.isNotEmpty) {
          questions.first.isExpanded = true;
        }
        generatedQuestions.assignAll(questions);
      }
    } catch (e) {
      // If fetching detail fails, fallback gracefully
    } finally {
      isGenerating.value = false;
    }
  }

  void toggleExpand(int index) {
    if (index >= 0 && index < generatedQuestions.length) {
      var q = generatedQuestions[index];
      q.isExpanded = !q.isExpanded;
      generatedQuestions.refresh();
    }
  }

  void toggleEdit(int index) {
    if (index >= 0 && index < generatedQuestions.length) {
      var q = generatedQuestions[index];
      if (!q.isEditing) {
        editingCache[index] = q.clone();
        q.isEditing = true;
      } else {
        if (editingCache.containsKey(index)) {
          generatedQuestions[index] = editingCache[index]!;
          generatedQuestions[index].isExpanded = true;
        }
        generatedQuestions[index].isEditing = false;
      }
      generatedQuestions.refresh();
    }
  }

  Future<void> saveChanges(
    int index,
    GeneratedQuestion updatedQuestion,
  ) async {
    updatedQuestion.isEditing = false;
    generatedQuestions[index] = updatedQuestion;
    editingCache.remove(index);
    generatedQuestions.refresh();

    // Call API if question has backend ID
    if (updatedQuestion.id != null && teacherRepository != null) {
      try {
        final payload = updatedQuestion.toSoalEditRequest();
        await teacherRepository!.editSoal(
          soalId: updatedQuestion.id!,
          payload: payload,
        );
        SnackbarHelper.showSuccess(
          title: 'Soal Diperbarui',
          message: 'Perubahan pada soal berhasil disimpan di server.',
        );
      } catch (e) {
        SnackbarHelper.showError(
          title: 'Gagal Menyimpan Soal',
          message: e.toString(),
        );
      }
    }
  }

  Future<void> regenerateStimulus(int index, String feedback) async {
    final question = generatedQuestions[index];
    if (question.id == null || teacherRepository == null) return;

    try {
      final updatedList = await teacherRepository!.regenerateStimulusSoal(
        soalId: question.id!,
        feedback: feedback,
      );

      if (updatedList.isNotEmpty) {
        final updatedSoal = updatedList.first;
        final newQ = GeneratedQuestion.fromSoalResponse(updatedSoal);
        newQ.isExpanded = true;
        generatedQuestions[index] = newQ;
        generatedQuestions.refresh();

        SnackbarHelper.showSuccess(
          title: 'Stimulus Diperbarui',
          message: 'Stimulus soal berhasil diregenerasi oleh AI.',
        );
      }
    } catch (e) {
      SnackbarHelper.showError(
        title: 'Gagal Regenerasi Stimulus',
        message: e.toString(),
      );
    }
  }

  Future<void> finish(FinishType type) async {
    final classroomId = await _resolveClassroomId();
    final quizId = createdQuizRequestId.value;

    if (quizId != null && classroomId != null && teacherRepository != null) {
      try {
        await teacherRepository!.updateQuizStatus(
          quizId: quizId,
          classroomId: classroomId,
          status: type.name.toLowerCase(),
        );
      } catch (_) {}
    }

    // Refresh exam list
    if (Get.isRegistered<ExamTeachersController>()) {
      Get.find<ExamTeachersController>().fetchQuizzes(showLoading: false);
    }

    final title = type == FinishType.publish
        ? 'Soal Ujian Berhasil Dipublikasikan'
        : 'Soal Ujian Berhasil Disimpan';
    final message = type == FinishType.publish
        ? 'Siswa sekarang dapat mengakses soal ujian.'
        : 'Anda dapat mempublikasikannya kapan saja.';

    Get.offNamedUntil(
      Routes.MAIN_LAYOUT,
      arguments: const MainBarArgs(role: UserRoles.guru, index: 2),
      (route) => route.settings.name == Routes.MAIN_LAYOUT,
    );

    SnackbarHelper.showSuccess(title: title, message: message);
  }
}

enum FinishType {
  draft("Draft"),
  publish("Publish");

  final String name;
  const FinishType(this.name);
}
