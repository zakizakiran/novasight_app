import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/exam_student_detail_progress_args.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/utils/math_latex_parser.dart';
import '../../../core/utils/math_semantic_serializer.dart';
import '../../../data/models/exam_review_question_model.dart';
import '../../../data/models/student_progress_quiz.dart';
import '../../../data/repositories/classroom_repository.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../../data/services/local/storage_service.dart';

class ExamTeacherStudentProgressDetailController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;
  final MathLatexParser parser = MathLatexParser();
  final MathSemanticSerializer serializer = MathSemanticSerializer();
  final Rx<StudentProgressQuiz?> quizProgress = Rx<StudentProgressQuiz?>(null);

  final RxString quizTitle = 'Hasil Ujian'.obs;
  final quizId = Rx<int?>(null);
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;
  final currentIndex = 0.obs;
  final questions = <ExamReviewQuestion>[].obs;
  int? _cachedClassroomId;

  ExamTeacherStudentProgressDetailController({
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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as ExamStudentDetailProgressArgs;
    quizTitle.value = args.title;
    quizId.value = args.quizId;
    quizProgress.value = args.quiz;
    fetchResults();
  }


  Future<void> fetchResults() async {
    if (teacherRepository == null) {
      errorMessage.value = 'Repository data siswa tidak ditemukan.';
      return;
    }

    final classroomId = await _resolveClassroomId();
    if (classroomId == null) {
      errorMessage.value = 'Tidak ada kelas yang ditemukan.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final results = await teacherRepository!.studentQuizResults(
        quizRequestId: quizId.value!,
        classroomId: classroomId,
        studentId: quizProgress.value?.profileResponse.student?.id ?? -1
      );

      if (results.isNotEmpty) {
        questions.value = results.map((item) {
          final List<String> options = item.options.map((option) => option.opsiText,).toList();
          const defaultOptions = ['A','B','C','D'];
          final correctIdx = options.indexOf(item.correctOption.trim().toUpperCase());
          final userIdx = item.selectedOption != null
              ? defaultOptions.indexOf(item.selectedOption!.trim().toUpperCase())
              : -1;
          int totalQuestions = results.length;
          double scorePerQuestion = totalQuestions > 0 ? 100.0 / totalQuestions : 0.0;
          return ExamReviewQuestion(
            id: item.soalId,
            userStep: item.studentSteps,
            question: item.questionText,
            options: options,
            correctAnswerIndex: correctIdx != -1 ? correctIdx : 0,
            userAnswerIndex: userIdx != -1 ? userIdx : -1,
            isCorrect: item.isCorrect ?? false,
            score: (item.isCorrect == true) ? scorePerQuestion : 0,
            explanationSteps: item.justification?.diagnosis.isNotEmpty == true
                ? [item.justification!.diagnosis]
                : [],
            errorStepIndex: item.justification?.divergenceStep != null
                ? (item.justification!.divergenceStep! > 0
                ? item.justification!.divergenceStep! - 1
                : 0)
                : null,
            errorExplanation: item.justification?.diagnosis,
            correction: item.justification?.personalizedJustification,
          );
        }).toList();
        currentIndex.value = 0;
      } else {
        questions.clear();
        errorMessage.value =
        'Belum ada hasil evaluasi yang tersimpan untuk ujian ini.';
      }
    } on ApiException catch (e) {
      questions.clear();
      errorMessage.value = e.message;
    } catch (e) {
      questions.clear();
      errorMessage.value = 'Gagal memuat hasil ujian: ${e.toString()}';
    } finally {
      isLoading.value = false;
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

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      currentIndex.value = index;
    }
  }
}
