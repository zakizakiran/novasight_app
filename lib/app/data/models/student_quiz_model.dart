enum QuizRequestStudentQueryStatus {
  semua('Semua'),
  belumDikerjakan('Belum Dikerjakan'),
  selesai('Selesai');

  final String value;
  const QuizRequestStudentQueryStatus(this.value);

  static QuizRequestStudentQueryStatus fromValue(String value) {
    return QuizRequestStudentQueryStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => QuizRequestStudentQueryStatus.semua,
    );
  }
}

class ModuleQuizResponse {
  final int id;
  final String title;
  final String description;

  ModuleQuizResponse({
    required this.id,
    required this.title,
    required this.description,
  });

  factory ModuleQuizResponse.fromJson(Map<String, dynamic> json) {
    return ModuleQuizResponse(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

class QuizRequestStudentProgressResponse {
  final int attemptCount;
  final double? score;
  final bool isDone;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String reviewStatus;
  final String? reviewError;

  QuizRequestStudentProgressResponse({
    this.attemptCount = 0,
    this.score,
    this.isDone = false,
    this.startedAt,
    this.completedAt,
    this.reviewStatus = 'PENDING',
    this.reviewError,
  });

  factory QuizRequestStudentProgressResponse.fromJson(Map<String, dynamic> json) {
    return QuizRequestStudentProgressResponse(
      attemptCount: json['attempt_count'] as int? ?? 0,
      score: json['score'] != null ? (json['score'] as num).toDouble() : null,
      isDone: json['is_done'] as bool? ?? false,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
      reviewStatus: json['review_status'] as String? ?? 'PENDING',
      reviewError: json['review_error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attempt_count': attemptCount,
      if (score != null) 'score': score,
      'is_done': isDone,
      if (startedAt != null) 'started_at': startedAt?.toIso8601String(),
      if (completedAt != null) 'completed_at': completedAt?.toIso8601String(),
      'review_status': reviewStatus,
      if (reviewError != null) 'review_error': reviewError,
    };
  }

  QuizRequestStudentProgressResponse copyWith({
    int? attemptCount,
    double? score,
    bool? isDone,
    DateTime? startedAt,
    DateTime? completedAt,
    String? reviewStatus,
    String? reviewError,
  }) {
    return QuizRequestStudentProgressResponse(
      attemptCount: attemptCount ?? this.attemptCount,
      score: score ?? this.score,
      isDone: isDone ?? this.isDone,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewError: reviewError ?? this.reviewError,
    );
  }
}

class QuizRequestStudentResponse {
  final int id;
  final int moduleId;
  final String title;
  final String statusPublished;
  final int maxDurationMinutes;
  final int maxRetry;
  final DateTime startTime;
  final DateTime endTime;
  final QuizRequestStudentProgressResponse? progress;
  final int questionCounts;
  final ModuleQuizResponse module;

  QuizRequestStudentResponse({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.statusPublished,
    required this.maxDurationMinutes,
    required this.maxRetry,
    required this.startTime,
    required this.endTime,
    this.progress,
    this.questionCounts = 0,
    required this.module,
  });

  factory QuizRequestStudentResponse.fromJson(Map<String, dynamic> json) {
    return QuizRequestStudentResponse(
      id: json['id'] as int? ?? 0,
      moduleId: json['module_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      statusPublished: json['status_published'] as String? ?? 'draft',
      maxDurationMinutes: json['max_duration_minutes'] as int? ?? 0,
      maxRetry: json['max_retry'] as int? ?? 1,
      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'] as String) ?? DateTime.now()
          : DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'] as String) ?? DateTime.now()
          : DateTime.now(),
      progress: json['progress'] != null
          ? QuizRequestStudentProgressResponse.fromJson(
              json['progress'] as Map<String, dynamic>,
            )
          : null,
      questionCounts: json['question_counts'] as int? ?? 0,
      module: json['module'] != null
          ? ModuleQuizResponse.fromJson(json['module'] as Map<String, dynamic>)
          : ModuleQuizResponse(id: 0, title: '', description: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'status_published': statusPublished,
      'max_duration_minutes': maxDurationMinutes,
      'max_retry': maxRetry,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'progress': progress?.toJson(),
      'question_counts': questionCounts,
      'module': module.toJson(),
    };
  }

  QuizRequestStudentResponse copyWith({
    int? id,
    int? moduleId,
    String? title,
    String? statusPublished,
    int? maxDurationMinutes,
    int? maxRetry,
    DateTime? startTime,
    DateTime? endTime,
    QuizRequestStudentProgressResponse? progress,
    int? questionCounts,
    ModuleQuizResponse? module,
  }) {
    return QuizRequestStudentResponse(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      statusPublished: statusPublished ?? this.statusPublished,
      maxDurationMinutes: maxDurationMinutes ?? this.maxDurationMinutes,
      maxRetry: maxRetry ?? this.maxRetry,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      progress: progress ?? this.progress,
      questionCounts: questionCounts ?? this.questionCounts,
      module: module ?? this.module,
    );
  }

  bool get isPublished => statusPublished.toLowerCase() == 'publish';
  bool get isDone => progress?.isDone ?? false;
}

class QuestionOptionResponse {
  final int id;
  final String label;
  final String opsiText;

  QuestionOptionResponse({
    required this.id,
    required this.label,
    required this.opsiText,
  });

  factory QuestionOptionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionOptionResponse(
      id: json['id'] as int? ?? 0,
      label: json['label'] as String? ?? '',
      opsiText: json['opsi_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'opsi_text': opsiText,
    };
  }
}

class QuestionExplanationSteps {
  final int id;
  final int steps;
  final String text;

  QuestionExplanationSteps({
    required this.id,
    required this.steps,
    required this.text,
  });

  factory QuestionExplanationSteps.fromJson(Map<String, dynamic> json) {
    return QuestionExplanationSteps(
      id: json['id'] as int? ?? 0,
      steps: json['steps'] as int? ?? 0,
      text: json['text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'steps': steps,
      'text': text,
    };
  }
}

class StudentStep extends QuestionExplanationSteps {
  StudentStep({required super.id, required super.steps, required super.text});

  factory StudentStep.fromJson(Map<String, dynamic> json) {
    return StudentStep(
      id: json['id'] as int? ?? 0,
      steps: json['steps'] as int? ?? json['urutan'] as int? ?? 0,
      text: json['text'] as String? ?? json['teks'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'urutan': steps,
      'teks': text,
    };
  }

  @override
  String toString() {
    return 'StudentStep(id: $id, steps: $steps, text: "$text")';
  }
}

class QuestionStimulusResponse {
  final int id;
  final String sourceMarkup;
  final String readableText;
  final String reviewStatus;
  final int sourceReadingOrderStart;
  final int sourceReadingOrderEnd;

  QuestionStimulusResponse({
    required this.id,
    required this.sourceMarkup,
    required this.readableText,
    required this.reviewStatus,
    required this.sourceReadingOrderStart,
    required this.sourceReadingOrderEnd,
  });

  factory QuestionStimulusResponse.fromJson(Map<String, dynamic> json) {
    return QuestionStimulusResponse(
      id: json['id'] as int? ?? 0,
      sourceMarkup: json['source_markup'] as String? ?? '',
      readableText: json['readable_text'] as String? ?? '',
      reviewStatus: json['review_status'] as String? ?? '',
      sourceReadingOrderStart: json['source_reading_order_start'] as int? ?? 0,
      sourceReadingOrderEnd: json['source_reading_order_end'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_markup': sourceMarkup,
      'readable_text': readableText,
      'review_status': reviewStatus,
      'source_reading_order_start': sourceReadingOrderStart,
      'source_reading_order_end': sourceReadingOrderEnd,
    };
  }
}

class QuizStudentAnswer{
  final int id;
  final String selectedOption;
  final List<StudentStep> steps;

  QuizStudentAnswer({required this.id, required this.selectedOption, required this.steps});

  factory QuizStudentAnswer.fromJson(Map<String, dynamic> json) {
    return QuizStudentAnswer(
      id: json['id'] as int? ?? 0,
      selectedOption: json['selected_option'] as String? ??
          json['selectedOption'] as String? ??
          '',
      steps: (json['steps'] as List<dynamic>? ?? json['langkah'] as List<dynamic>?)
          ?.map((e) {
        if (e is Map<String, dynamic>) {
          return StudentStep.fromJson(e);
        }
        return StudentStep(id: 0, steps: 0, text: e.toString());
      }).toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'selected_option': selectedOption,
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }
}

class QuizRequestQuestionResponse {
  final int id;
  final int chapterId;
  final QuestionStimulusResponse? stimulus;
  final int bloomLevel;
  final String questionText;
  final String? correctOption;
  final String? kesimpulan;
  final int? sourceReadingOrderStart;
  final int? sourceReadingOrderEnd;
  final String reviewStatus;
  final String reviewPriority;
  final String? validationNotes;
  final QuizStudentAnswer? answer;
  final List<QuestionOptionResponse> options;
  final List<QuestionExplanationSteps> explanationSteps;

  QuizRequestQuestionResponse({
    required this.id,
    required this.chapterId,
    this.stimulus,
    required this.bloomLevel,
    required this.questionText,
    this.correctOption,
    this.kesimpulan,
    this.answer,
    this.sourceReadingOrderStart,
    this.sourceReadingOrderEnd,
    this.reviewStatus = 'pending',
    this.reviewPriority = 'normal',
    this.validationNotes,
    required this.options,
    required this.explanationSteps,
  });

  factory QuizRequestQuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuizRequestQuestionResponse(
      id: json['id'] as int? ?? 0,
      chapterId: json['chapter_id'] as int? ?? 0,
      stimulus: json['stimulus'] != null
          ? QuestionStimulusResponse.fromJson(
              json['stimulus'] as Map<String, dynamic>,
            )
          : null,
      bloomLevel: json['bloom_level'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? '',
      correctOption: json['correct_option'] as String?,
      kesimpulan: json['kesimpulan'] as String?,
      sourceReadingOrderStart: json['source_reading_order_start'] as int?,
      sourceReadingOrderEnd: json['source_reading_order_end'] as int?,
      reviewStatus: json['review_status'] as String? ?? 'pending',
      reviewPriority: json['review_priority'] as String? ?? 'normal',
      validationNotes: json['validation_notes'] as String?,
      options: (json['options'] as List? ?? [])
          .map((e) => QuestionOptionResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      explanationSteps: (json['explanation_steps'] as List? ?? [])
          .map((e) =>
              QuestionExplanationSteps.fromJson(e as Map<String, dynamic>))
          .toList(),
      answer: json['answer'] != null && json['answer'] is Map<String, dynamic>
          ? QuizStudentAnswer.fromJson(json['answer'] as Map<String, dynamic>,) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'stimulus': stimulus?.toJson(),
      'bloom_level': bloomLevel,
      'question_text': questionText,
      if (correctOption != null) 'correct_option': correctOption,
      if (kesimpulan != null) 'kesimpulan': kesimpulan,
      if (answer != null) 'answer': answer?.toJson(),
      if (sourceReadingOrderStart != null)
        'source_reading_order_start': sourceReadingOrderStart,
      if (sourceReadingOrderEnd != null)
        'source_reading_order_end': sourceReadingOrderEnd,
      'review_status': reviewStatus,
      'review_priority': reviewPriority,
      if (validationNotes != null) 'validation_notes': validationNotes,
      'options': options.map((e) => e.toJson()).toList(),
      'explanation_steps': explanationSteps.map((e) => e.toJson()).toList(),
    };
  }
}

// ---------------- SSE Student Quiz Events ---------------- //

sealed class StudentQuizEvent {
  const StudentQuizEvent();
}

class StudentQuizInitEvent extends StudentQuizEvent {
  final List<QuizRequestQuestionResponse> questions;
  final DateTime? targetEndTime;

  const StudentQuizInitEvent({
    required this.questions,
    this.targetEndTime,
  });
}

class StudentQuizTickEvent extends StudentQuizEvent {
  final String time;

  const StudentQuizTickEvent({required this.time});
}

class StudentQuizTimeoutEvent extends StudentQuizEvent {
  final String message;

  const StudentQuizTimeoutEvent({this.message = 'Waktu pengerjaan telah habis'});
}

class StudentQuizErrorEvent extends StudentQuizEvent {
  final String error;

  const StudentQuizErrorEvent({required this.error});
}

// ---------------- Soal Submit DTO ---------------- //

class SoalStepRequest {
  final String step;

  const SoalStepRequest({
    required this.step,
  });

  Map<String, dynamic> toJson() {
    return {
      'step': step,
    };
  }
}

class SoalSubmitRequest {
  final String selectedOption;

  const SoalSubmitRequest({
    required this.selectedOption,
  });

  Map<String, dynamic> toJson() {
    return {
      'selected_option': selectedOption,
    };
  }
}

class SoalSubmitResponse {
  final int soalId;
  final String status;

  SoalSubmitResponse({
    required this.soalId,
    required this.status,
  });

  factory SoalSubmitResponse.fromJson(Map<String, dynamic> json) {
    return SoalSubmitResponse(
      soalId: json['soal_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soal_id': soalId,
      'status': status,
    };
  }
}

// ---------------- Quiz Results DTO ---------------- //

class SoalJustification {
  final int? divergenceStep;
  final String diagnosis;
  final String personalizedJustification;

  SoalJustification({
    this.divergenceStep,
    required this.diagnosis,
    required this.personalizedJustification,
  });

  factory SoalJustification.fromJson(Map<String, dynamic> json) {
    return SoalJustification(
      divergenceStep: json['divergence_step'] != null
          ? int.tryParse(json['divergence_step'].toString())
          : null,
      diagnosis: json['diagnosis'] as String? ?? '',
      personalizedJustification:
          json['personalized_justification'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (divergenceStep != null) 'divergence_step': divergenceStep,
      'diagnosis': diagnosis,
      'personalized_justification': personalizedJustification,
    };
  }
}

class QuizResultItem {
  final int soalId;
  final String questionText;
  final String? selectedOption;
  final String correctOption;
  final bool? isCorrect;
  final SoalJustification? justification;
  final List<StudentStep> studentSteps;

  QuizResultItem({
    required this.soalId,
    required this.questionText,
    required this.studentSteps,
    this.selectedOption,
    required this.correctOption,
    this.isCorrect,
    this.justification,
  });

  factory QuizResultItem.fromJson(Map<String, dynamic> json) {
    return QuizResultItem(
      soalId: json['soal_id'] != null
          ? (int.tryParse(json['soal_id'].toString()) ?? 0)
          : 0,
      studentSteps: (json['langkah'] as List<dynamic>?)?.map((item) {
        if (item is Map<String, dynamic>) {
          return StudentStep.fromJson(item);
        } else if (item is String) {
          return StudentStep(id: 0, steps: 0, text: item);
        }
        return StudentStep(id: 0, steps: 0, text: '');
      }).toList() ?? [],
      questionText: json['question_text'] as String? ?? '',
      selectedOption: json['selected_option'] as String?,
      correctOption: json['correct_option'] as String? ?? '',
      isCorrect: json['is_correct'] as bool?,
      justification: json['justification'] != null &&
              json['justification'] is Map<String, dynamic>
          ? SoalJustification.fromJson(
              json['justification'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soal_id': soalId,
      'question_text': questionText,
      if (selectedOption != null) 'selected_option': selectedOption,
      'correct_option': correctOption,
      if (isCorrect != null) 'is_correct': isCorrect,
      'langkah': studentSteps.map((step) => step.toJson()).toList(),
      if (justification != null) 'justification': justification?.toJson(),
    };
  }
}
