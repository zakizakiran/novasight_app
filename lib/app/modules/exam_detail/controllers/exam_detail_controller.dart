import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/modules/exam/controllers/exam_controller.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ExamDetailController extends GetxController {
  final Rxn<QuizRequestStudentResponse> quiz = Rxn<QuizRequestStudentResponse>();
  final RxInt quizId = 1.obs;
  final RxString title = 'Soal Ujian'.obs;
  final RxString moduleTitle = 'UTS Kelas X'.obs;
  final RxInt questionCount = 5.obs;
  final RxInt durationMinutes = 45.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is QuizRequestStudentResponse) {
      quiz.value = args;
      quizId.value = args.id;
      title.value = args.title;
      moduleTitle.value = args.module.title;
      questionCount.value = args.questionCounts > 0 ? args.questionCounts : 5;
      durationMinutes.value =
          args.maxDurationMinutes > 0 ? args.maxDurationMinutes : 45;
    } else if (args is ExamDummyModel) {
      if (args.rawQuiz != null) {
        final q = args.rawQuiz!;
        quiz.value = q;
        quizId.value = q.id;
        title.value = q.title;
        moduleTitle.value = q.module.title;
        questionCount.value = q.questionCounts > 0 ? q.questionCounts : 5;
        durationMinutes.value =
            q.maxDurationMinutes > 0 ? q.maxDurationMinutes : 45;
      } else {
        quizId.value = int.tryParse(args.id) ?? 1;
        title.value = args.title;
        moduleTitle.value = args.subtitle;
      }
    } else if (args is int) {
      quizId.value = args;
    } else if (args != null) {
      quizId.value = int.tryParse(args.toString()) ?? 1;
    }
  }

  void onStartExam() {
    Get.toNamed(
      Routes.EXAM_ACTIVE,
      arguments: {
        'quizId': quizId.value,
        'durationMinutes': durationMinutes.value,
        'title': title.value,
        'moduleTitle': moduleTitle.value,
        'quiz': quiz.value,
      },
    );
  }
}
