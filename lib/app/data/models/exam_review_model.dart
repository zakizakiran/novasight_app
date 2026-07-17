class ExamReviewQuestion {
  final int id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final int userAnswerIndex;
  final bool isCorrect;
  final int score;
  final List<String> explanationSteps;
  final List<String>? userWorkingSteps;
  final int? errorStepIndex;
  final String? errorExplanation;
  final String? correction;

  ExamReviewQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.userAnswerIndex,
    required this.isCorrect,
    required this.score,
    required this.explanationSteps,
    this.userWorkingSteps,
    this.errorStepIndex,
    this.errorExplanation,
    this.correction,
  });
}
