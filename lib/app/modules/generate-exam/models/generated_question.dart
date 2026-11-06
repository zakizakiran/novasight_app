import 'package:equatable/equatable.dart';
import 'package:lydera_app/app/data/models/quiz_teacher_model.dart';

// ignore: must_be_immutable
class GeneratedQuestion extends Equatable {
  int? id;
  int? chapterId;
  int? stimulusId;
  String? stimulusText;
  QuestionStimulusModel? stimulus;
  String? sourcePoint;
  String? validationNotes;
  String? reviewPriority;
  String? reviewStatus;
  QuestionMarkupModel? markup;
  int bloomLevel;
  String question;
  List<String> options;
  int correctOptionIndex;
  String? correctOptionLabel;
  List<String> justificationSteps;
  String conclusion;
  bool isEditing;
  bool isExpanded;

  GeneratedQuestion({
    this.id,
    this.chapterId,
    this.stimulusId,
    this.stimulusText,
    this.stimulus,
    this.sourcePoint,
    this.validationNotes,
    this.reviewPriority,
    this.reviewStatus,
    this.markup,
    this.bloomLevel = 3,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.correctOptionLabel,
    required this.justificationSteps,
    required this.conclusion,
    this.isEditing = false,
    this.isExpanded = false,
  });

  bool get hasStimulus =>
      (stimulusText != null && stimulusText!.isNotEmpty) ||
      (stimulus?.svgMarkup != null) ||
      (stimulus?.effectiveTable != null) ||
      (stimulus?.sourceMarkup.trim().isNotEmpty ?? false);

  bool get isHots => hasStimulus || bloomLevel >= 4;

  factory GeneratedQuestion.fromQuizRequestQuestion(QuizRequestQuestionModel q) {
    int correctIndex = 0;
    final cleanCorrect = q.correctOption.trim().toUpperCase();
    if (cleanCorrect.isNotEmpty) {
      final code = cleanCorrect.codeUnitAt(0) - 'A'.codeUnitAt(0);
      if (code >= 0 && code < (q.options.isNotEmpty ? q.options.length : 5)) {
        correctIndex = code;
      }
    }

    final opts = q.options.map((o) => o.opsiText).toList();
    if (opts.isEmpty) {
      opts.addAll(['Pilihan A', 'Pilihan B', 'Pilihan C', 'Pilihan D']);
    }

    final steps = q.explanationSteps.map((s) => s.text).toList();
    if (steps.isEmpty && q.kesimpulan.isNotEmpty) {
      steps.add(q.kesimpulan);
    }

    return GeneratedQuestion(
      id: q.id,
      chapterId: q.chapterId,
      stimulusId: q.stimulus?.id,
      stimulusText: q.stimulus?.readableText.isNotEmpty == true
          ? q.stimulus?.readableText
          : q.stimulus?.ringkasan,
      stimulus: q.stimulus,
      sourcePoint: q.sourcePoint,
      validationNotes: q.validationNotes,
      reviewPriority: q.reviewPriority,
      reviewStatus: q.reviewStatus,
      markup: q.markup,
      bloomLevel: q.bloomLevel,
      question: q.questionText,
      options: opts,
      correctOptionIndex: correctIndex,
      correctOptionLabel: q.correctOption,
      justificationSteps: steps,
      conclusion: q.kesimpulan.isNotEmpty
          ? q.kesimpulan
          : 'Jawaban: ${q.correctOption}',
      isExpanded: false,
    );
  }

  factory GeneratedQuestion.fromSoalResponse(SoalResponseModel s) {
    int correctIndex = 0;
    final cleanCorrect = s.correctOption.trim().toUpperCase();
    if (cleanCorrect.isNotEmpty) {
      final code = cleanCorrect.codeUnitAt(0) - 'A'.codeUnitAt(0);
      if (code >= 0 && code < (s.options.isNotEmpty ? s.options.length : 5)) {
        correctIndex = code;
      }
    }

    final opts = s.options.map((o) => o.opsiText).toList();
    if (opts.isEmpty) {
      opts.addAll(['Pilihan A', 'Pilihan B', 'Pilihan C', 'Pilihan D']);
    }

    final steps = List<String>.from(s.langkah);

    return GeneratedQuestion(
      id: s.id,
      chapterId: s.chapterId,
      stimulusId: s.stimulusId,
      stimulusText: s.stimulusText,
      stimulus: s.stimulus,
      sourcePoint: s.sourcePoint,
      validationNotes: s.validationNotes,
      reviewPriority: s.reviewPriority,
      reviewStatus: s.reviewStatus,
      markup: s.markup,
      bloomLevel: s.bloomLevel,
      question: s.questionText,
      options: opts,
      correctOptionIndex: correctIndex,
      correctOptionLabel: s.correctOption,
      justificationSteps: steps,
      conclusion: s.kesimpulan.isNotEmpty
          ? s.kesimpulan
          : 'Jawaban: ${s.correctOption}',
      isExpanded: false,
    );
  }

  SoalEditRequest toSoalEditRequest() {
    final Map<String, String> optsMap = {};
    for (int i = 0; i < options.length; i++) {
      final label = String.fromCharCode('A'.codeUnitAt(0) + i);
      optsMap[label] = options[i];
    }

    final correctLabel =
        correctOptionIndex >= 0 && correctOptionIndex < options.length
            ? String.fromCharCode('A'.codeUnitAt(0) + correctOptionIndex)
            : (correctOptionLabel ?? 'A');

    return SoalEditRequest(
      questionText: question,
      options: optsMap,
      correctOption: correctLabel,
      langkah: justificationSteps,
      kesimpulan: conclusion,
    );
  }

  GeneratedQuestion clone() {
    return GeneratedQuestion(
      id: id,
      chapterId: chapterId,
      stimulusId: stimulusId,
      stimulusText: stimulusText,
      stimulus: stimulus,
      sourcePoint: sourcePoint,
      validationNotes: validationNotes,
      reviewPriority: reviewPriority,
      reviewStatus: reviewStatus,
      markup: markup,
      bloomLevel: bloomLevel,
      question: question,
      options: List.from(options),
      correctOptionIndex: correctOptionIndex,
      correctOptionLabel: correctOptionLabel,
      justificationSteps: List.from(justificationSteps),
      conclusion: conclusion,
      isEditing: isEditing,
      isExpanded: isExpanded,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chapterId,
        stimulusId,
        stimulusText,
        stimulus,
        sourcePoint,
        validationNotes,
        reviewPriority,
        reviewStatus,
        markup,
        bloomLevel,
        question,
        options,
        correctOptionIndex,
        correctOptionLabel,
        justificationSteps,
        conclusion,
      ];
}
