// DTO models for Teacher Quiz endpoints.
// Maps strictly to OpenAPI schema contract:
// - ModuleQuizResponse -> ModuleQuizModel
// - QuizRequestTeacherResponse -> QuizRequestTeacherModel
// - QuizRequestTeacherDetailResponse -> QuizRequestTeacherDetailModel
// - QuizRequestQuestionResponse -> QuizRequestQuestionModel
// - QuestionStimulusResponse -> QuestionStimulusModel
// - QuestionOptionResponse -> QuestionOptionModel
// - QuestionExplanationSteps -> QuestionExplanationStepModel
// - QuizRequestChapterDetailResponse -> QuizRequestChapterDetailModel
// - QuizChapterRequest -> QuizChapterRequest
// - QuizRequestCreate -> QuizRequestCreatePayload
// - QuizStreamEvent -> QuizStreamEvent
// - SoalEditRequest -> SoalEditRequest
// - SoalResponse -> SoalResponseModel
// - SoalOpsiResponse -> SoalOpsiResponseModel

class ModuleQuizModel {
  final int id;
  final String title;
  final String? description;

  ModuleQuizModel({
    required this.id,
    required this.title,
    this.description,
  });

  factory ModuleQuizModel.fromJson(Map<String, dynamic> json) {
    return ModuleQuizModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
    };
  }
}

class QuizRequestTeacherModel {
  final int id;
  final int moduleId;
  final String title;
  final String statusPublished; // 'draft' | 'publish'
  final int maxDurationMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // 'running', 'done', 'failed', etc.
  final String? error;
  final int questionCounts;
  final ModuleQuizModel module;

  QuizRequestTeacherModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.statusPublished,
    required this.maxDurationMinutes,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.error,
    this.questionCounts = 0,
    required this.module,
  });

  bool get isPublished => statusPublished.toLowerCase() == 'publish';

  factory QuizRequestTeacherModel.fromJson(Map<String, dynamic> json) {
    return QuizRequestTeacherModel(
      id: json['id'] as int? ?? 0,
      moduleId: json['module_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      statusPublished: json['status_published'] as String? ?? 'draft',
      maxDurationMinutes: json['max_duration_minutes'] as int? ?? 0,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : DateTime.now().add(const Duration(hours: 1)),
      status: json['status'] as String? ?? '',
      error: json['error'] as String?,
      questionCounts: json['question_counts'] as int? ?? 0,
      module: json['module'] != null
          ? ModuleQuizModel.fromJson(json['module'] as Map<String, dynamic>)
          : ModuleQuizModel(id: 0, title: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'status_published': statusPublished,
      'max_duration_minutes': maxDurationMinutes,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status,
      'error': error,
      'question_counts': questionCounts,
      'module': module.toJson(),
    };
  }

  QuizRequestTeacherModel copyWith({
    int? id,
    int? moduleId,
    String? title,
    String? statusPublished,
    int? maxDurationMinutes,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? error,
    int? questionCounts,
    ModuleQuizModel? module,
  }) {
    return QuizRequestTeacherModel(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      title: title ?? this.title,
      statusPublished: statusPublished ?? this.statusPublished,
      maxDurationMinutes: maxDurationMinutes ?? this.maxDurationMinutes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      error: error ?? this.error,
      questionCounts: questionCounts ?? this.questionCounts,
      module: module ?? this.module,
    );
  }
}

class QuestionStimulusModel {
  final int id;
  final String sourceMarkup;
  final String readableText;
  final String reviewStatus;
  final int sourceReadingOrderStart;
  final int sourceReadingOrderEnd;

  QuestionStimulusModel({
    required this.id,
    required this.sourceMarkup,
    required this.readableText,
    required this.reviewStatus,
    required this.sourceReadingOrderStart,
    required this.sourceReadingOrderEnd,
  });

  factory QuestionStimulusModel.fromJson(Map<String, dynamic> json) {
    return QuestionStimulusModel(
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

class QuestionOptionModel {
  final int id;
  final String label;
  final String opsiText;

  QuestionOptionModel({
    required this.id,
    required this.label,
    required this.opsiText,
  });

  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) {
    return QuestionOptionModel(
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

class QuestionExplanationStepModel {
  final int id;
  final int steps;
  final String text;

  QuestionExplanationStepModel({
    required this.id,
    required this.steps,
    required this.text,
  });

  factory QuestionExplanationStepModel.fromJson(Map<String, dynamic> json) {
    return QuestionExplanationStepModel(
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

class QuizRequestQuestionModel {
  final int id;
  final int chapterId;
  final QuestionStimulusModel? stimulus;
  final int bloomLevel;
  final String questionText;
  final String correctOption;
  final String kesimpulan;
  final int sourceReadingOrderStart;
  final int sourceReadingOrderEnd;
  final String reviewStatus;
  final String reviewPriority;
  final String? validationNotes;
  final List<QuestionOptionModel> options;
  final List<QuestionExplanationStepModel> explanationSteps;

  QuizRequestQuestionModel({
    required this.id,
    required this.chapterId,
    this.stimulus,
    required this.bloomLevel,
    required this.questionText,
    required this.correctOption,
    required this.kesimpulan,
    required this.sourceReadingOrderStart,
    required this.sourceReadingOrderEnd,
    this.reviewStatus = 'pending',
    this.reviewPriority = 'normal',
    this.validationNotes,
    required this.options,
    required this.explanationSteps,
  });

  bool get isHots => stimulus != null || bloomLevel >= 4;

  factory QuizRequestQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizRequestQuestionModel(
      id: json['id'] as int? ?? 0,
      chapterId: json['chapter_id'] as int? ?? 0,
      stimulus: json['stimulus'] != null
          ? QuestionStimulusModel.fromJson(
              json['stimulus'] as Map<String, dynamic>)
          : null,
      bloomLevel: json['bloom_level'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? '',
      correctOption: json['correct_option'] as String? ?? 'A',
      kesimpulan: json['kesimpulan'] as String? ?? '',
      sourceReadingOrderStart: json['source_reading_order_start'] as int? ?? 0,
      sourceReadingOrderEnd: json['source_reading_order_end'] as int? ?? 0,
      reviewStatus: json['review_status'] as String? ?? 'pending',
      reviewPriority: json['review_priority'] as String? ?? 'normal',
      validationNotes: json['validation_notes'] as String?,
      options: json['options'] != null
          ? (json['options'] as List)
              .map((e) =>
                  QuestionOptionModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      explanationSteps: json['explanation_steps'] != null
          ? (json['explanation_steps'] as List)
              .map((e) => QuestionExplanationStepModel.fromJson(
                  e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter_id': chapterId,
      'stimulus': stimulus?.toJson(),
      'bloom_level': bloomLevel,
      'question_text': questionText,
      'correct_option': correctOption,
      'kesimpulan': kesimpulan,
      'source_reading_order_start': sourceReadingOrderStart,
      'source_reading_order_end': sourceReadingOrderEnd,
      'review_status': reviewStatus,
      'review_priority': reviewPriority,
      'validation_notes': validationNotes,
      'options': options.map((e) => e.toJson()).toList(),
      'explanation_steps': explanationSteps.map((e) => e.toJson()).toList(),
    };
  }

  QuizRequestQuestionModel copyWith({
    int? id,
    int? chapterId,
    QuestionStimulusModel? stimulus,
    int? bloomLevel,
    String? questionText,
    String? correctOption,
    String? kesimpulan,
    int? sourceReadingOrderStart,
    int? sourceReadingOrderEnd,
    String? reviewStatus,
    String? reviewPriority,
    String? validationNotes,
    List<QuestionOptionModel>? options,
    List<QuestionExplanationStepModel>? explanationSteps,
  }) {
    return QuizRequestQuestionModel(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      stimulus: stimulus ?? this.stimulus,
      bloomLevel: bloomLevel ?? this.bloomLevel,
      questionText: questionText ?? this.questionText,
      correctOption: correctOption ?? this.correctOption,
      kesimpulan: kesimpulan ?? this.kesimpulan,
      sourceReadingOrderStart:
          sourceReadingOrderStart ?? this.sourceReadingOrderStart,
      sourceReadingOrderEnd:
          sourceReadingOrderEnd ?? this.sourceReadingOrderEnd,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      reviewPriority: reviewPriority ?? this.reviewPriority,
      validationNotes: validationNotes ?? this.validationNotes,
      options: options ?? this.options,
      explanationSteps: explanationSteps ?? this.explanationSteps,
    );
  }
}

class QuizRequestChapterDetailModel {
  final int quizRequestId;
  final int chapterId;
  final int hotsCount;
  final int lotsCount;

  QuizRequestChapterDetailModel({
    required this.quizRequestId,
    required this.chapterId,
    required this.hotsCount,
    required this.lotsCount,
  });

  factory QuizRequestChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return QuizRequestChapterDetailModel(
      quizRequestId: json['quiz_request_id'] as int? ?? 0,
      chapterId: json['chapter_id'] as int? ?? 0,
      hotsCount: json['hots_count'] as int? ?? 0,
      lotsCount: json['lots_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz_request_id': quizRequestId,
      'chapter_id': chapterId,
      'hots_count': hotsCount,
      'lots_count': lotsCount,
    };
  }
}

class QuizRequestTeacherDetailModel {
  final int id;
  final int moduleId;
  final String title;
  final String statusPublished;
  final String status;
  final int maxDurationMinutes;
  final DateTime startTime;
  final DateTime endTime;
  final String? error;
  final List<QuizRequestQuestionModel> questions;
  final List<QuizRequestChapterDetailModel> quizRequestChapters;
  final ModuleQuizModel module;

  QuizRequestTeacherDetailModel({
    required this.id,
    required this.moduleId,
    required this.title,
    required this.statusPublished,
    required this.status,
    required this.maxDurationMinutes,
    required this.startTime,
    required this.endTime,
    this.error,
    required this.questions,
    required this.quizRequestChapters,
    required this.module,
  });

  bool get isPublished => statusPublished.toLowerCase() == 'publish';
  int get questionCounts => questions.length;

  factory QuizRequestTeacherDetailModel.fromJson(Map<String, dynamic> json) {
    return QuizRequestTeacherDetailModel(
      id: json['id'] as int? ?? 0,
      moduleId: json['module_id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      statusPublished: json['status_published'] as String? ?? 'draft',
      status: json['status'] as String? ?? '',
      maxDurationMinutes: json['max_duration_minutes'] as int? ?? 0,
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : DateTime.now(),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : DateTime.now().add(const Duration(hours: 1)),
      error: json['error'] as String?,
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((e) => QuizRequestQuestionModel.fromJson(
                  e as Map<String, dynamic>))
              .toList()
          : [],
      quizRequestChapters: json['quiz_request_chapters'] != null
          ? (json['quiz_request_chapters'] as List)
              .map((e) => QuizRequestChapterDetailModel.fromJson(
                  e as Map<String, dynamic>))
              .toList()
          : [],
      module: json['module'] != null
          ? ModuleQuizModel.fromJson(json['module'] as Map<String, dynamic>)
          : ModuleQuizModel(id: 0, title: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'title': title,
      'status_published': statusPublished,
      'status': status,
      'max_duration_minutes': maxDurationMinutes,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'error': error,
      'questions': questions.map((e) => e.toJson()).toList(),
      'quiz_request_chapters':
          quizRequestChapters.map((e) => e.toJson()).toList(),
      'module': module.toJson(),
    };
  }
}

class QuizChapterRequest {
  final int chapterId;
  final int hotsCount;
  final int lotsCount;

  QuizChapterRequest({
    required this.chapterId,
    required this.hotsCount,
    required this.lotsCount,
  });

  int get totalCount => hotsCount + lotsCount;

  factory QuizChapterRequest.fromJson(Map<String, dynamic> json) {
    return QuizChapterRequest(
      chapterId: json['chapter_id'] as int? ?? 0,
      hotsCount: json['hots_count'] as int? ?? 0,
      lotsCount: json['lots_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter_id': chapterId,
      'hots_count': hotsCount,
      'lots_count': lotsCount,
    };
  }
}

class QuizRequestCreatePayload {
  final int classroomId;
  final int moduleId;
  final String title;
  final List<QuizChapterRequest> chapters;
  final int maxDurationMinutes;
  final int maxRetry;
  final DateTime startTime;
  final DateTime endTime;

  QuizRequestCreatePayload({
    required this.classroomId,
    required this.moduleId,
    required this.title,
    required this.chapters,
    required this.maxDurationMinutes,
    this.maxRetry = 1,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'classroom_id': classroomId,
      'module_id': moduleId,
      'title': title,
      'chapters': chapters.map((e) => e.toJson()).toList(),
      'max_duration_minutes': maxDurationMinutes,
      'max_retry': maxRetry,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
    };
  }
}

class QuizRequestCreateResponse {
  final int quizRequestId;
  final String status;
  final bool isCached;

  QuizRequestCreateResponse({
    required this.quizRequestId,
    required this.status,
    this.isCached = false,
  });

  factory QuizRequestCreateResponse.fromJson(Map<String, dynamic> json) {
    return QuizRequestCreateResponse(
      quizRequestId: json['quiz_request_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      isCached: json['is_cached'] as bool? ?? false,
    );
  }
}

class QuizStreamEvent {
  final int? quizRequestId;
  final String status; // 'running', 'done', 'failed'
  final int completed;
  final int total;
  final String message;
  final List<QuizRequestQuestionModel>? data;

  QuizStreamEvent({
    this.quizRequestId,
    required this.status,
    this.completed = 0,
    this.total = 0,
    this.message = '',
    this.data,
  });

  bool get isDone => status.toLowerCase() == 'done';
  bool get isFailed => status.toLowerCase() == 'failed';
  double get progress => total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;

  factory QuizStreamEvent.fromJson(Map<String, dynamic> json) {
    List<QuizRequestQuestionModel>? questions;
    if (json['data'] != null && json['data'] is List) {
      questions = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => QuizRequestQuestionModel.fromJson(e))
          .toList();
    }

    String status = json['status'] as String? ?? '';
    String message = json['message'] as String? ?? '';

    // Support backend error payload fields ('detail', 'error', 'msg')
    if (json['detail'] != null && message.isEmpty) {
      final detail = json['detail'];
      if (detail is String && detail.isNotEmpty) {
        message = detail;
        if (status.isEmpty) status = 'failed';
      }
    }
    if (json['error'] != null && message.isEmpty) {
      final err = json['error'];
      if (err is String && err.isNotEmpty) {
        message = err;
        if (status.isEmpty) status = 'failed';
      }
    }
    if (status.isEmpty) {
      status = 'running';
    }

    return QuizStreamEvent(
      quizRequestId: json['quiz_request_id'] as int?,
      status: status,
      completed: json['completed'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      message: message,
      data: questions,
    );
  }
}

class SoalOpsiResponseModel {
  final String label;
  final String opsiText;

  SoalOpsiResponseModel({
    required this.label,
    required this.opsiText,
  });

  factory SoalOpsiResponseModel.fromJson(Map<String, dynamic> json) {
    return SoalOpsiResponseModel(
      label: json['label'] as String? ?? '',
      opsiText: json['opsi_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'opsi_text': opsiText,
    };
  }
}

class SoalResponseModel {
  final int id;
  final int chapterId;
  final int? stimulusId;
  final int bloomLevel;
  final String questionText;
  final List<SoalOpsiResponseModel> options;
  final String correctOption;
  final List<String> langkah;
  final String kesimpulan;
  final String? stimulusText;
  final String reviewStatus;
  final String reviewPriority;
  final String? validationNotes;

  SoalResponseModel({
    required this.id,
    required this.chapterId,
    this.stimulusId,
    required this.bloomLevel,
    required this.questionText,
    required this.options,
    required this.correctOption,
    required this.langkah,
    required this.kesimpulan,
    this.stimulusText,
    required this.reviewStatus,
    required this.reviewPriority,
    this.validationNotes,
  });

  factory SoalResponseModel.fromJson(Map<String, dynamic> json) {
    return SoalResponseModel(
      id: json['id'] as int? ?? 0,
      chapterId: json['chapter_id'] as int? ?? 0,
      stimulusId: json['stimulus_id'] as int?,
      bloomLevel: json['bloom_level'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? '',
      options: json['options'] != null
          ? (json['options'] as List)
              .map((e) =>
                  SoalOpsiResponseModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      correctOption: json['correct_option'] as String? ?? 'A',
      langkah: json['langkah'] != null
          ? List<String>.from(json['langkah'] as List)
          : [],
      kesimpulan: json['kesimpulan'] as String? ?? '',
      stimulusText: json['stimulus_text'] as String?,
      reviewStatus: json['review_status'] as String? ?? '',
      reviewPriority: json['review_priority'] as String? ?? '',
      validationNotes: json['validation_notes'] as String?,
    );
  }
}

class SoalEditRequest {
  final String? questionText;
  final Map<String, String>? options;
  final String? correctOption;
  final List<String>? langkah;
  final String? kesimpulan;

  SoalEditRequest({
    this.questionText,
    this.options,
    this.correctOption,
    this.langkah,
    this.kesimpulan,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (questionText != null) map['question_text'] = questionText;
    if (options != null) map['options'] = options;
    if (correctOption != null) map['correct_option'] = correctOption;
    if (langkah != null) map['langkah'] = langkah;
    if (kesimpulan != null) map['kesimpulan'] = kesimpulan;
    return map;
  }
}
