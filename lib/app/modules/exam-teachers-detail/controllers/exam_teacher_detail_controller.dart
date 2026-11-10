import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/core/utils/snackbar_helper.dart';
import 'package:lydera_app/app/data/models/quiz_teacher_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/exam-teachers/controllers/exam_teachers_controller.dart';
import 'package:lydera_app/app/modules/exam-teachers/models/exam_teacher_model.dart';

import '../../../core/args/main_bar_args.dart';
import '../../../core/utils/user_roles.dart';
import '../../../routes/app_pages.dart';
import '../../generate-exam/models/generated_question.dart';

class QuizSettings {
  final String title;
  final int maxDurationMinutes;
  final int maxRetry;
  final DateTime startTime;
  final DateTime endTime;

  const QuizSettings({
    required this.title,
    required this.maxDurationMinutes,
    required this.maxRetry,
    required this.startTime,
    required this.endTime,
  });

  bool isEqualTo(QuizSettings other) {
    return title == other.title &&
        maxDurationMinutes == other.maxDurationMinutes &&
        maxRetry == other.maxRetry &&
        startTime == other.startTime &&
        endTime == other.endTime;
  }
}

class ExamTeacherDetailController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ExamTeacherDetailController({
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

  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final quizId = Rx<int?>(null);
  final quizDetail = Rxn<QuizRequestTeacherDetailModel>();

  // Title configuration
  final titleController = TextEditingController();
  final isQuizSettingReadOnly = true.obs;
  final title = ''.obs;
  final maxDurationMinutes = 60.obs;
  final maxRetry = 1.obs;
  final Rx<DateTime> startTime = DateTime.now().obs;
  final Rx<DateTime> endTime = DateTime.now().add(const Duration(hours: 1)).obs;

  // Compatibility fields
  final numberOfQuestions = 0.obs;
  final answerOptions = 'A-D'.obs;
  final difficulty = 'Campuran'.obs;

  // List Soal
  final generatedQuestions = <GeneratedQuestion>[].obs;
  List<GeneratedQuestion> initialQuestion = [];

  // Backup saat diedit
  final Map<int, GeneratedQuestion> editingCache = {};

  QuizSettings? originalSettings;

  QuizSettings get currentSettings => QuizSettings(
    title: title.value.trim(),
    maxDurationMinutes: maxDurationMinutes.value,
    maxRetry: maxRetry.value,
    startTime: startTime.value,
    endTime: endTime.value,
  );

  bool get hasChanges {
    if (originalSettings == null) return false;

    return !currentSettings.isEqualTo(originalSettings!);
  }

  int? _cachedClassroomId;

  bool get quizStatusPublish {
    // final titleChanged = title.value.trim() !=
    //     (quizDetail.value?.title ?? selectedExam.value?.title ?? '').trim();
    // final questionsChanged = !listEquals(initialQuestion, generatedQuestions);
    // return titleChanged || questionsChanged;

    return quizDetail.value?.isPublished ?? false;
  }

  @override
  void onInit() {
    super.onInit();
    _parseArguments();

    titleController.addListener(() {
      title.value = titleController.text;
    });

    if (quizId.value != null && quizId.value! > 0) {
      fetchDetail(quizId.value!);
    } else {
      _startMockFallback();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void setInitialSettings() {
    originalSettings = currentSettings;
  }

  void _parseArguments() {
    final args = Get.arguments;
    if (args is QuizRequestTeacherModel) {
      print('Start Time : ${args.startTime}');
      quizId.value = args.id;
      titleController.text = args.title;
      title.value = args.title;
      maxRetry.value = args.maxRetry;
      maxDurationMinutes.value = args.maxDurationMinutes;
      numberOfQuestions.value = args.questionCounts;
      startTime.value = args.startTime;
      endTime.value = args.endTime;
      originalSettings = QuizSettings(
          title: args.title,
          maxDurationMinutes: args.maxDurationMinutes,
          maxRetry: args.maxRetry,
          startTime: args.startTime,
          endTime: args.endTime
      );
    } else if (args is ExamTeacherModel) {
      // selectedExam.value = args;
      quizId.value = int.tryParse(args.id);
      titleController.text = args.title;
      title.value = args.title;
      numberOfQuestions.value = args.questionCount;
    } else if (args is int) {
      quizId.value = args;
    } else if (args is Map) {
      quizId.value = args['id'] as int?;
    }
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

  Future<void> fetchDetail(int id) async {
    if (teacherRepository == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final classroomId = await _resolveClassroomId();
      if (classroomId == null) {
        errorMessage.value = 'Kelas tidak ditemukan.';
        return;
      }

      final detail = await teacherRepository!.getQuizDetail(
        quizId: id,
        classroomId: classroomId,
      );

      quizDetail.value = detail;
      titleController.text = detail.title;
      title.value = detail.title;
      startTime.value = detail.startTime;
      endTime.value = detail.startTime;
      maxRetry.value = detail.maxRetry;
      maxDurationMinutes.value = detail.maxDurationMinutes;
      numberOfQuestions.value = detail.questionCounts;

      final questions = detail.questions
          .map((q) => GeneratedQuestion.fromQuizRequestQuestion(q))
          .toList();

      if (questions.isNotEmpty) {
        questions.first.isExpanded = true;
      }

      generatedQuestions.assignAll(questions);
      initialQuestion = generatedQuestions.map((q) => q.clone()).toList();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(
        title: 'Gagal Memuat Detail Kuis',
        message: e.message,
      );
      _startMockFallback();
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat detail kuis.';
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Gagal memuat: ${e.toString()}',
      );
      _startMockFallback();
    } finally {
      isLoading.value = false;
    }
  }

  void _startMockFallback() {
    if (generatedQuestions.isNotEmpty) return;

    generatedQuestions.clear();
    editingCache.clear();
    final count = numberOfQuestions.value > 0 ? numberOfQuestions.value : 5;

    for (int i = 0; i < count; i++) {
      generatedQuestions.add(
        GeneratedQuestion(
          question:
              'Manakah yang merupakan definisi himpunan yang paling tepat?',
          options: const [
            'Kumpulan objek yang tidak terdefinisi',
            'Kumpulan objek yang dapat didefinisikan dengan jelas',
            'Kumpulan angka yang berurutan',
            'Kumpulan huruf dalam alfabet',
          ],
          correctOptionIndex: 1,
          justificationSteps: const [
            'Himpunan didefinisikan sebagai kumpulan objek yang dapat diidentifikasi dengan jelas.',
            'Setiap anggota himpunan memiliki kriteria keanggotaan yang pasti.',
          ],
          conclusion:
              'Jawaban: B — Kumpulan objek yang dapat didefinisikan dengan jelas.',
          isExpanded: i == 0,
        ),
      );
    }
    initialQuestion = generatedQuestions.map((q) => q.clone()).toList();
  }

  void stillPublish(){
    SnackbarHelper.showError(title: 'Status Quiz', message: 'Ubah status ke draft terlebih dahulu');
  }

  Future<void> onToggleQuizSetting() async {
    if(quizStatusPublish){
      stillPublish();
      return;
    }

    if (!isQuizSettingReadOnly.value && hasChanges){
      await saveQuizSetting();
    }
    isQuizSettingReadOnly.value = !isQuizSettingReadOnly.value;
  }

  void toggleExpand(int index) {
    if (index >= 0 && index < generatedQuestions.length) {
      var q = generatedQuestions[index];
      q.isExpanded = !q.isExpanded;
      generatedQuestions.refresh();
    }
  }

  void toggleEdit(int index) {
    if(quizStatusPublish){
      stillPublish();
      return;
    }

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

  Future<void> saveQuizSetting() async {
    final classroomId = await _resolveClassroomId();
    final currentQuizId = quizId.value;

    if (currentQuizId != null &&
        classroomId != null &&
        teacherRepository != null) {
      try {
       final result = await teacherRepository!.updateQuizSetting(
          quizId: currentQuizId,
          classroomId: classroomId,
          payload: QuizRequestUpdatePayload(
              title: title.value,
              maxDurationMinutes: maxDurationMinutes.value,
              startTime: startTime.value,
              endTime: endTime.value
          )
        );
       title.value = result.title;
       maxDurationMinutes.value = result.maxDurationMinutes;
       startTime.value = result.startTime;
       endTime.value = result.endTime;
       setInitialSettings();

      } catch (_) {}
      SnackbarHelper.showSuccess(
        title: "Ujian Berhasil Diubah",
        message: "Soal ujian saat ini bersifat draft.",
      );
    }
  }

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
  Future<void> saveChanges(int index, GeneratedQuestion updatedQuestion) async {
    final previous = editingCache[index] ?? generatedQuestions[index].clone();
    updatedQuestion.isEditing = false;
    generatedQuestions[index] = updatedQuestion;
    editingCache.remove(index);
    generatedQuestions.refresh();

    // Call API if question has real ID
    if (updatedQuestion.id != null && teacherRepository != null) {
      try {
        final payload = updatedQuestion.toSoalEditRequest();
        final updatedSoal = await teacherRepository!.editSoal(
          soalId: updatedQuestion.id!,
          payload: payload,
        );
        final serverQ = GeneratedQuestion.fromSoalResponse(updatedSoal)
          ..stimulus = updatedSoal.stimulus ?? updatedQuestion.stimulus
          ..stimulusText =
              updatedSoal.stimulusText ?? updatedQuestion.stimulusText
          ..isExpanded = true
          ..isEditing = false;
        generatedQuestions[index] = serverQ;
        generatedQuestions.refresh();
        SnackbarHelper.showSuccess(
          title: 'Soal Diperbarui',
          message: 'Perubahan pada soal berhasil disimpan di server.',
        );
      } catch (e) {
        generatedQuestions[index] = previous
          ..isExpanded = true
          ..isEditing = false;
        generatedQuestions.refresh();
        SnackbarHelper.showError(
          title: 'Gagal Menyimpan Soal',
          message: e.toString(),
        );
      }
    } else {
      SnackbarHelper.showSuccess(
        title: 'Perubahan Berhasil Disimpan!',
        message: 'Soal telah diperbarui.',
      );
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
        for (final updatedSoal in updatedList) {
          final targetIdx =
              generatedQuestions.indexWhere((q) => q.id == updatedSoal.id);
          final idxToUpdate = targetIdx != -1 ? targetIdx : index;
          final prev = generatedQuestions[idxToUpdate];
          final newQ = GeneratedQuestion.fromSoalResponse(updatedSoal)
            ..stimulus = updatedSoal.stimulus ?? prev.stimulus
            ..isExpanded = idxToUpdate == index ? true : prev.isExpanded;
          generatedQuestions[idxToUpdate] = newQ;
        }
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

  Future<void> onConfirmChange() async {
    final classroomId = await _resolveClassroomId();
    final currentQuizId = quizId.value;

    if (currentQuizId != null &&
        classroomId != null &&
        teacherRepository != null) {
      try {
        await teacherRepository!.updateQuizStatus(
          quizId: currentQuizId,
          classroomId: classroomId,
          status: "draft",
        );
      } catch (_) {}
    }

    if (Get.isRegistered<ExamTeachersController>()) {
      Get.find<ExamTeachersController>().fetchQuizzes(showLoading: false);
    }

    SnackbarHelper.showSuccess(
      title: "Soal Ujian Berhasil Diubah",
      message: "Soal ujian saat ini bersifat draft.",
    );

    Get.offNamedUntil(
      Routes.MAIN_LAYOUT,
      arguments: const MainBarArgs(role: UserRoles.guru, index: 2),
      (route) => route.settings.name == Routes.MAIN_LAYOUT,
    );
  }
}
