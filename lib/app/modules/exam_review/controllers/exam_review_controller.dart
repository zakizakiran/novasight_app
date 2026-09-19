import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/exam_review_model.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';

class ExamReviewController extends GetxController {
  final StudentRepository? studentRepository;

  ExamReviewController({
    StudentRepository? studentRepository,
  }) : studentRepository = studentRepository ??
            (Get.isRegistered<StudentRepository>()
                ? Get.find<StudentRepository>()
                : null);

  final RxInt quizRequestId = 1.obs;
  final RxString quizTitle = 'Hasil Ujian'.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final currentIndex = 0.obs;
  final questions = <ExamReviewQuestion>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is int) {
      quizRequestId.value = args;
    } else if (args is QuizRequestStudentResponse) {
      quizRequestId.value = args.id;
      quizTitle.value = args.title;
    } else if (args is Map) {
      if (args['id'] != null) {
        quizRequestId.value = int.tryParse(args['id'].toString()) ?? 1;
      }
      if (args['title'] != null) {
        quizTitle.value = args['title'].toString();
      }
    } else if (args != null) {
      quizRequestId.value = int.tryParse(args.toString()) ?? 1;
    }
    fetchResults();
  }

  Future<void> fetchResults() async {
    if (studentRepository == null) {
      errorMessage.value = 'Repository data siswa tidak ditemukan.';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final results = await studentRepository!.getMyQuizResults(
        quizRequestId: quizRequestId.value,
      );

      if (results.isNotEmpty) {
        questions.value = results.map((item) {
          const options = ['A', 'B', 'C', 'D'];
          final correctIdx =
              options.indexOf(item.correctOption.trim().toUpperCase());
          final userIdx = item.selectedOption != null
              ? options.indexOf(item.selectedOption!.trim().toUpperCase())
              : -1;

          return ExamReviewQuestion(
            id: item.soalId,
            question: item.questionText,
            options: options,
            correctAnswerIndex: correctIdx != -1 ? correctIdx : 0,
            userAnswerIndex: userIdx != -1 ? userIdx : 0,
            isCorrect: item.isCorrect ?? false,
            score: (item.isCorrect == true) ? 20 : 0,
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
