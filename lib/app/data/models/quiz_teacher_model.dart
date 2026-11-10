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
  final int maxRetry;
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
    required this.maxRetry,
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
      maxRetry: json['max_retry'] as int? ?? 1,
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
      'max_retry':maxRetry,
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
      maxRetry: this.maxRetry,
    );
  }
}

class StimulusTableModel {
  final String? judul;
  final List<String> kolom;
  final List<List<String>> baris;
  final int? skemaVersi;

  const StimulusTableModel({
    this.judul,
    this.kolom = const [],
    this.baris = const [],
    this.skemaVersi,
  });

  factory StimulusTableModel.fromJson(Map<String, dynamic> json) {
    final rawKolom = json['kolom'];
    final rawBaris = json['baris'];

    return StimulusTableModel(
      judul: json['judul'] as String?,
      kolom: rawKolom is List
          ? rawKolom.map((e) => e?.toString() ?? '').toList()
          : const [],
      baris: rawBaris is List
          ? rawBaris
              .whereType<List>()
              .map((row) => row.map((cell) => cell?.toString() ?? '').toList())
              .toList()
          : const [],
      skemaVersi: json['skema_versi'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (judul != null) 'judul': judul,
      'kolom': kolom,
      'baris': baris,
      if (skemaVersi != null) 'skema_versi': skemaVersi,
    };
  }
}

class StimulusSpecModel {
  final String? svg;
  final String? deskripsi;
  final String? judul;
  final List<String> kolom;
  final List<List<String>> baris;
  final int? skemaVersi;

  const StimulusSpecModel({
    this.svg,
    this.deskripsi,
    this.judul,
    this.kolom = const [],
    this.baris = const [],
    this.skemaVersi,
  });

  bool get hasSvg => svg != null && svg!.trim().isNotEmpty;
  bool get hasTable => kolom.isNotEmpty || baris.isNotEmpty;

  StimulusTableModel? toTableModel() {
    if (!hasTable) return null;
    return StimulusTableModel(
      judul: judul,
      kolom: kolom,
      baris: baris,
      skemaVersi: skemaVersi,
    );
  }

  factory StimulusSpecModel.fromJson(Map<String, dynamic> json) {
    final rawKolom = json['kolom'];
    final rawBaris = json['baris'];

    return StimulusSpecModel(
      svg: json['svg'] as String?,
      deskripsi: json['deskripsi'] as String?,
      judul: json['judul'] as String?,
      kolom: rawKolom is List
          ? rawKolom.map((e) => e?.toString() ?? '').toList()
          : const [],
      baris: rawBaris is List
          ? rawBaris
              .whereType<List>()
              .map((row) => row.map((cell) => cell?.toString() ?? '').toList())
              .toList()
          : const [],
      skemaVersi: json['skema_versi'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (svg != null) 'svg': svg,
      if (deskripsi != null) 'deskripsi': deskripsi,
      if (judul != null) 'judul': judul,
      if (kolom.isNotEmpty) 'kolom': kolom,
      if (baris.isNotEmpty) 'baris': baris,
      if (skemaVersi != null) 'skema_versi': skemaVersi,
    };
  }
}

class QuestionMarkupModel {
  final String? question;
  final Map<String, String> options;
  final List<String> langkah;
  final String? kesimpulan;

  const QuestionMarkupModel({
    this.question,
    this.options = const {},
    this.langkah = const [],
    this.kesimpulan,
  });

  factory QuestionMarkupModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final rawLangkah = json['langkah'];

    return QuestionMarkupModel(
      question: json['question'] as String?,
      options: rawOptions is Map
          ? rawOptions.map(
              (k, v) => MapEntry(k.toString(), v?.toString() ?? ''),
            )
          : const {},
      langkah: rawLangkah is List
          ? rawLangkah.map((e) => e?.toString() ?? '').toList()
          : const [],
      kesimpulan: json['kesimpulan'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (question != null) 'question': question,
      if (options.isNotEmpty) 'options': options,
      if (langkah.isNotEmpty) 'langkah': langkah,
      if (kesimpulan != null) 'kesimpulan': kesimpulan,
    };
  }
}

class QuestionStimulusModel {
  final int id;
  final String sourceMarkup;
  final String readableText;
  final String? ringkasan;
  final StimulusTableModel? tabel;
  final String? jenis;
  final StimulusSpecModel? spesifikasi;
  final String reviewStatus;
  final int sourceReadingOrderStart;
  final int sourceReadingOrderEnd;

  QuestionStimulusModel({
    required this.id,
    required this.sourceMarkup,
    required this.readableText,
    this.ringkasan,
    this.tabel,
    this.jenis,
    this.spesifikasi,
    required this.reviewStatus,
    required this.sourceReadingOrderStart,
    required this.sourceReadingOrderEnd,
  });

  StimulusTableModel? get effectiveTable =>
      spesifikasi?.toTableModel() ?? tabel;

  String? get svgMarkup =>
      (spesifikasi?.hasSvg ?? false) ? spesifikasi!.svg : null;

  factory QuestionStimulusModel.fromJson(Map<String, dynamic> json) {
    return QuestionStimulusModel(
      id: json['id'] as int? ?? 0,
      sourceMarkup: json['source_markup'] as String? ?? '',
      readableText: json['readable_text'] as String? ?? '',
      ringkasan: json['ringkasan'] as String?,
      tabel: json['tabel'] is Map<String, dynamic>
          ? StimulusTableModel.fromJson(json['tabel'] as Map<String, dynamic>)
          : null,
      jenis: json['jenis'] as String?,
      spesifikasi: json['spesifikasi'] is Map<String, dynamic>
          ? StimulusSpecModel.fromJson(
              json['spesifikasi'] as Map<String, dynamic>,
            )
          : null,
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
      'ringkasan': ringkasan,
      'tabel': tabel?.toJson(),
      'jenis': jenis,
      'spesifikasi': spesifikasi?.toJson(),
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
  final String? sourcePoint;
  final QuestionMarkupModel? markup;
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
    this.sourcePoint,
    this.markup,
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
      sourcePoint: json['source_point'] as String?,
      markup: json['markup'] is Map<String, dynamic>
          ? QuestionMarkupModel.fromJson(json['markup'] as Map<String, dynamic>)
          : null,
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
      'source_point': sourcePoint,
      'markup': markup?.toJson(),
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
    String? sourcePoint,
    QuestionMarkupModel? markup,
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
      sourcePoint: sourcePoint ?? this.sourcePoint,
      markup: markup ?? this.markup,
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
  final int maxRetry;
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
    required this.maxRetry,
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
      maxRetry: json['max_retry'],
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

class QuizRequestUpdatePayload extends QuizRequestUpdateResponse{
  QuizRequestUpdatePayload({required super.title, required super.maxDurationMinutes, required super.startTime, required super.endTime});
}

class QuizRequestUpdateResponse {
  final String title;
  final int maxDurationMinutes;
  final int maxRetry;
  final DateTime startTime;
  final DateTime endTime;

  QuizRequestUpdateResponse({
    required this.title,
    required this.maxDurationMinutes,
    this.maxRetry = 1,
    required this.startTime,
    required this.endTime,
  });

  factory QuizRequestUpdateResponse.fromJson(Map<String, dynamic> json) {
    return QuizRequestUpdateResponse(
        title: json['title'],
        maxDurationMinutes: json['max_duration_minutes'],
        startTime: json['start_time'],
        endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'max_duration_minutes': maxDurationMinutes,
      'max_retry': maxRetry,
      'start_time': startTime.toUtc().toIso8601String(),
      'end_time': endTime.toUtc().toIso8601String(),
    };
  }
}

class QuizCreateResponse{
  final int quizRequestId;
  final String status;
  final String idemKey;
  final bool isCached;

  QuizCreateResponse({
    required this.quizRequestId,
    required this.status,
    required this.idemKey,
    required this.isCached
  });

  factory QuizCreateResponse.fromJson(Map<String, dynamic> json){
    return QuizCreateResponse(
        quizRequestId: json['quiz_request_id'],
        status: json['status'],
        idemKey: json['idem_key'],
        isCached: json['is_cached']
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
  final QuestionStimulusModel? stimulus;
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
  final String? sourcePoint;
  final QuestionMarkupModel? markup;

  SoalResponseModel({
    required this.id,
    required this.chapterId,
    this.stimulusId,
    this.stimulus,
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
    this.sourcePoint,
    this.markup,
  });

  factory SoalResponseModel.fromJson(Map<String, dynamic> json) {
    final parsedStimulus = json['stimulus'] is Map<String, dynamic>
        ? QuestionStimulusModel.fromJson(
            json['stimulus'] as Map<String, dynamic>,
          )
        : null;

    List<String> parsedLangkah = [];
    if (json['langkah'] is List) {
      parsedLangkah = (json['langkah'] as List).map((e) => e.toString()).toList();
    } else if (json['explanation_steps'] is List) {
      parsedLangkah = (json['explanation_steps'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => e['text']?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return SoalResponseModel(
      id: json['id'] as int? ?? 0,
      chapterId: json['chapter_id'] as int? ?? 0,
      stimulusId: json['stimulus_id'] as int? ?? parsedStimulus?.id,
      stimulus: parsedStimulus,
      bloomLevel: json['bloom_level'] as int? ?? 1,
      questionText: json['question_text'] as String? ?? '',
      options: json['options'] != null
          ? (json['options'] as List)
              .map((e) =>
                  SoalOpsiResponseModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      correctOption: json['correct_option'] as String? ?? 'A',
      langkah: parsedLangkah,
      kesimpulan: json['kesimpulan'] as String? ?? '',
      stimulusText:
          json['stimulus_text'] as String? ?? parsedStimulus?.readableText,
      reviewStatus: json['review_status'] as String? ?? '',
      reviewPriority: json['review_priority'] as String? ?? '',
      validationNotes: json['validation_notes'] as String?,
      sourcePoint: json['source_point'] as String?,
      markup: json['markup'] is Map<String, dynamic>
          ? QuestionMarkupModel.fromJson(json['markup'] as Map<String, dynamic>)
          : null,
    );
  }
}

class SoalEditRequest {
  final String? questionText;
  final Map<String, String>? options;
  final String? correctOption;
  final List<String>? langkah;
  final String? kesimpulan;
  final Map<String, dynamic>? markup;

  SoalEditRequest({
    this.questionText,
    this.options,
    this.correctOption,
    this.langkah,
    this.kesimpulan,
    this.markup,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (questionText != null) map['question_text'] = questionText;
    if (options != null) map['options'] = options;
    if (correctOption != null) map['correct_option'] = correctOption;
    if (langkah != null) map['langkah'] = langkah;
    if (kesimpulan != null) map['kesimpulan'] = kesimpulan;
    if (markup != null) map['markup'] = markup;
    return map;
  }
}
