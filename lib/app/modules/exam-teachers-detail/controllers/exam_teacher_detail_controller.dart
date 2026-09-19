import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/models/quiz_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/exam-teachers/controllers/exam_teachers_controller.dart';
import 'package:novasight_app/app/modules/exam-teachers/models/exam_teacher_model.dart';

import '../../../core/args/main_bar_args.dart';
import '../../../core/utils/user_roles.dart';
import '../../../routes/app_pages.dart';
import '../../generate-exam/models/generated_question.dart';

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
  final Rxn<ExamTeacherModel> selectedExam = Rxn<ExamTeacherModel>();

  // Title configuration
  final titleController = TextEditingController();
  final isTitleReadOnly = true.obs;
  final title = ''.obs;
  final maxDurationMinutes = 60.obs;

  // Compatibility fields
  final numberOfQuestions = 0.obs;
  final answerOptions = 'A-D'.obs;
  final difficulty = 'Campuran'.obs;

  // List Soal
  final generatedQuestions = <GeneratedQuestion>[].obs;
  List<GeneratedQuestion> initialQuestion = [];

  // Backup saat diedit
  final Map<int, GeneratedQuestion> editingCache = {};

  final isSaving = false.obs;
  int? _cachedClassroomId;

  bool get hasChanges {
    final titleChanged = title.value.trim() !=
        (quizDetail.value?.title ?? selectedExam.value?.title ?? '').trim();
    final questionsChanged = !listEquals(initialQuestion, generatedQuestions);
    return titleChanged || questionsChanged;
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

  void _parseArguments() {
    final args = Get.arguments;
    if (args is QuizRequestTeacherModel) {
      quizId.value = args.id;
      titleController.text = args.title;
      title.value = args.title;
      maxDurationMinutes.value = args.maxDurationMinutes;
      numberOfQuestions.value = args.questionCounts;
      selectedExam.value = ExamTeacherModel(
        id: args.id.toString(),
        title: args.title,
        questionCount: args.questionCounts,
        type: 'Pilihan Ganda',
        difficulty: 'Campuran',
        moduleName: args.module.title,
        status: args.isPublished ? 'Publish' : 'Draft',
      );
    } else if (args is ExamTeacherModel) {
      selectedExam.value = args;
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

  void onToggleTitle() {
    isTitleReadOnly.value = !isTitleReadOnly.value;
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

  Future<void> saveChanges(int index, GeneratedQuestion updatedQuestion) async {
    updatedQuestion.isEditing = false;
    generatedQuestions[index] = updatedQuestion;
    editingCache.remove(index);
    generatedQuestions.refresh();

    // Call API if question has real ID
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

  Future<void> onConfirmChange() async {
    isSaving.value = true;
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

    isSaving.value = false;
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
