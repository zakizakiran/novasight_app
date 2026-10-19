class ExamStudentProgressArgs {
  final int quizId;
  final String title;

  const ExamStudentProgressArgs({
    required this.quizId,
    this.title = 'Hasil Ujian',
  });
}