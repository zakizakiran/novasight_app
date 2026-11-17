import 'package:lydera_app/app/data/models/student_quiz_model.dart';

class ExamReviewQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int userAnswerIndex;
  final bool isCorrect;
  final double score;
  final StepError? stepError;
  final QuestionStimulusResponse? stimulus;
  final List<String> explanationSteps;
  final List<StudentStep> userStep;
  final int? errorStepIndex;
  final String? correction;
  final String conclusion;
  final bool isEvaluationFailed;
  final bool isEvaluationOnProcess;

  ExamReviewQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.userAnswerIndex,
    required this.isCorrect,
    required this.score,
    required this.explanationSteps,
    required this.userStep,
    this.errorStepIndex,
    this.correction,
    this.stimulus,
    this.stepError,
    required this.conclusion,
    required this.isEvaluationFailed,
    required this.isEvaluationOnProcess,
  });
}
