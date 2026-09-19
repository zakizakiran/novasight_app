import 'package:novasight_app/app/data/models/student_quiz_model.dart';

// DTO models for Student API endpoints.
// Maps strictly to OpenAPI schema contract:
// - StudentTaskStatus
// - StudentModuleStatus
// - ClassroomInfoResponse -> ClassroomInfoModel
// - ModuleProgressResponse -> ModuleProgressModel
// - StudentChapterProgressResponse -> StudentChapterProgressModel
// - BlockResponse -> BlockResponseModel
// - StudentDashboardResponse -> StudentDashboardModel
// - StudentTaskResponse -> StudentTaskModel
// - StudentModuleWithoutChaptersResponse -> StudentModuleModel
// - StudentChapterDetailWithoutBlockResponse -> StudentChapterSummaryModel
// - StudentModuleResponse -> StudentModuleDetailModel
// - StudentChapterDetailResponse -> StudentChapterDetailModel

enum StudentTaskStatus {
  semua('Semua'),
  materi('Materi'),
  soalUjian('Soal Ujian');

  final String value;
  const StudentTaskStatus(this.value);

  static StudentTaskStatus fromString(String? val) {
    return StudentTaskStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == val?.toLowerCase(),
      orElse: () => StudentTaskStatus.semua,
    );
  }
}

enum StudentModuleStatus {
  semua('Semua'),
  selesai('Selesai'),
  belumSelesai('Belum Selesai');

  final String value;
  const StudentModuleStatus(this.value);

  static StudentModuleStatus fromString(String? val) {
    return StudentModuleStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == val?.toLowerCase(),
      orElse: () => StudentModuleStatus.semua,
    );
  }
}

class ClassroomInfoModel {
  final String schoolName;
  final String? code;
  final int gradeClass;
  final String classroomType;

  ClassroomInfoModel({
    required this.schoolName,
    this.code,
    required this.gradeClass,
    required this.classroomType,
  });

  factory ClassroomInfoModel.fromJson(Map<String, dynamic> json) {
    return ClassroomInfoModel(
      schoolName: json['school_name'] as String? ?? '',
      code: json['code'] as String?,
      gradeClass: json['grade_class'] as int? ?? 0,
      classroomType: json['classroom_type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_name': schoolName,
      'code': code,
      'grade_class': gradeClass,
      'classroom_type': classroomType,
    };
  }
}

class ModuleProgressModel {
  final int id;
  final int studentId;
  final int moduleId;
  final int progressPercentage;
  final bool isDone;

  ModuleProgressModel({
    required this.id,
    required this.studentId,
    required this.moduleId,
    required this.progressPercentage,
    required this.isDone,
  });

  factory ModuleProgressModel.fromJson(Map<String, dynamic> json) {
    return ModuleProgressModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      moduleId: json['module_id'] as int,
      progressPercentage: json['progress_percentage'] as int? ?? 0,
      isDone: json['is_done'] as bool? ?? false,
    );
  }

  ModuleProgressModel copyWith({
    int? id,
    int? studentId,
    int? moduleId,
    int? progressPercentage,
    bool? isDone,
  }) {
    return ModuleProgressModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      moduleId: moduleId ?? this.moduleId,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'module_id': moduleId,
      'progress_percentage': progressPercentage,
      'is_done': isDone,
    };
  }
}

class StudentChapterProgressModel {
  final bool isDone;
  final DateTime? completedAt;

  StudentChapterProgressModel({
    this.isDone = false,
    this.completedAt,
  });

  factory StudentChapterProgressModel.fromJson(Map<String, dynamic> json) {
    return StudentChapterProgressModel(
      isDone: json['is_done'] as bool? ?? false,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'] as String)
          : null,
    );
  }

  StudentChapterProgressModel copyWith({
    bool? isDone,
    DateTime? completedAt,
  }) {
    return StudentChapterProgressModel(
      isDone: isDone ?? this.isDone,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_done': isDone,
      'completed_at': completedAt?.toIso8601String(),
    };
  }
}

class BlockResponseModel {
  final int? id;
  final int readingOrder;
  final String blockType;
  final String readableText;
  final String? previousText;
  final String reviewPriority;
  final int? headingLevel;
  final String? sourceMarkup;
  final String? caption;
  final String? imageFile;
  final String? imageUrl;

  BlockResponseModel({
    this.id,
    required this.readingOrder,
    required this.blockType,
    required this.readableText,
    this.previousText,
    required this.reviewPriority,
    this.headingLevel,
    this.sourceMarkup,
    this.caption,
    this.imageFile,
    this.imageUrl,
  });

  factory BlockResponseModel.fromJson(Map<String, dynamic> json) {
    return BlockResponseModel(
      id: json['id'] as int?,
      readingOrder: json['reading_order'] as int? ?? 0,
      blockType: json['block_type'] as String? ?? '',
      readableText: json['readable_text'] as String? ?? '',
      previousText: json['previous_text'] as String?,
      reviewPriority: json['review_priority'] as String? ?? '',
      headingLevel: json['heading_level'] as int?,
      sourceMarkup: json['source_markup'] as String?,
      caption: json['caption'] as String?,
      imageFile: json['image_file'] as String?,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reading_order': readingOrder,
      'block_type': blockType,
      'readable_text': readableText,
      'previous_text': previousText,
      'review_priority': reviewPriority,
      'heading_level': headingLevel,
      'source_markup': sourceMarkup,
      'caption': caption,
      'image_file': imageFile,
      if (imageUrl != null) 'image_url': imageUrl,
    };
  }
}

class StudentDashboardModel {
  final String studentEmail;
  final ClassroomInfoModel? classroomInfo;
  final int modulesNotDone;
  final int examNotDone;

  StudentDashboardModel({
    required this.studentEmail,
    this.classroomInfo,
    this.modulesNotDone = 0,
    this.examNotDone = 0,
  });

  factory StudentDashboardModel.fromJson(Map<String, dynamic> json) {
    return StudentDashboardModel(
      studentEmail: json['student_email'] as String? ?? '',
      classroomInfo: json['classroom_info'] != null
          ? ClassroomInfoModel.fromJson(
              json['classroom_info'] as Map<String, dynamic>,
            )
          : null,
      modulesNotDone: json['modules_not_done'] as int? ?? 0,
      examNotDone: json['exam_not_done'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_email': studentEmail,
      'classroom_info': classroomInfo?.toJson(),
      'modules_not_done': modulesNotDone,
      'exam_not_done': examNotDone,
    };
  }
}

class StudentModuleModel {
  final int id;
  final String title;
  final int? faseId;
  final DateTime createdAt;
  final ModuleProgressModel? progress;

  StudentModuleModel({
    required this.id,
    required this.title,
    this.faseId,
    required this.createdAt,
    this.progress,
  });

  factory StudentModuleModel.fromJson(Map<String, dynamic> json) {
    return StudentModuleModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      faseId: json['fase_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      progress: json['progress'] != null
          ? ModuleProgressModel.fromJson(
              json['progress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  StudentModuleModel copyWith({
    int? id,
    String? title,
    int? faseId,
    DateTime? createdAt,
    ModuleProgressModel? progress,
  }) {
    return StudentModuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      faseId: faseId ?? this.faseId,
      createdAt: createdAt ?? this.createdAt,
      progress: progress ?? this.progress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fase_id': faseId,
      'created_at': createdAt.toIso8601String(),
      'progress': progress?.toJson(),
    };
  }
}

class StudentTaskModel {
  final List<StudentModuleModel> modules;
  final List<QuizRequestStudentResponse> exams;

  StudentTaskModel({
    required this.modules,
    required this.exams,
  });

  factory StudentTaskModel.fromJson(Map<String, dynamic> json) {
    return StudentTaskModel(
      modules: (json['modules'] as List? ?? [])
          .map((e) => StudentModuleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      exams: (json['exams'] as List? ?? []).map((e) {
        if (e is QuizRequestStudentResponse) return e;
        return QuizRequestStudentResponse.fromJson(e as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modules': modules.map((e) => e.toJson()).toList(),
      'exams': exams.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentChapterSummaryModel {
  final int id;
  final String title;
  final int? number;
  final StudentChapterProgressModel? chapterProgress;

  StudentChapterSummaryModel({
    required this.id,
    required this.title,
    this.number,
    this.chapterProgress,
  });

  factory StudentChapterSummaryModel.fromJson(Map<String, dynamic> json) {
    return StudentChapterSummaryModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      number: json['number'] as int?,
      chapterProgress: json['chapter_progress'] != null
          ? StudentChapterProgressModel.fromJson(
              json['chapter_progress'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  StudentChapterSummaryModel copyWith({
    int? id,
    String? title,
    int? number,
    StudentChapterProgressModel? chapterProgress,
  }) {
    return StudentChapterSummaryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      number: number ?? this.number,
      chapterProgress: chapterProgress ?? this.chapterProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'chapter_progress': chapterProgress?.toJson(),
    };
  }
}

class StudentModuleDetailModel {
  final int id;
  final String title;
  final int? faseId;
  final DateTime createdAt;
  final ModuleProgressModel? progress;
  final List<StudentChapterSummaryModel> chapters;

  StudentModuleDetailModel({
    required this.id,
    required this.title,
    this.faseId,
    required this.createdAt,
    this.progress,
    required this.chapters,
  });

  factory StudentModuleDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentModuleDetailModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      faseId: json['fase_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      progress: json['progress'] != null
          ? ModuleProgressModel.fromJson(
              json['progress'] as Map<String, dynamic>,
            )
          : null,
      chapters: (json['chapters'] as List? ?? [])
          .map((e) =>
              StudentChapterSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  StudentModuleDetailModel copyWith({
    int? id,
    String? title,
    int? faseId,
    DateTime? createdAt,
    ModuleProgressModel? progress,
    List<StudentChapterSummaryModel>? chapters,
  }) {
    return StudentModuleDetailModel(
      id: id ?? this.id,
      title: title ?? this.title,
      faseId: faseId ?? this.faseId,
      createdAt: createdAt ?? this.createdAt,
      progress: progress ?? this.progress,
      chapters: chapters ?? this.chapters,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fase_id': faseId,
      'created_at': createdAt.toIso8601String(),
      'progress': progress?.toJson(),
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentChapterDetailModel {
  final int id;
  final String title;
  final int? number;
  final StudentChapterProgressModel? chapterProgress;
  final List<BlockResponseModel>? blocks;

  StudentChapterDetailModel({
    required this.id,
    required this.title,
    this.number,
    this.chapterProgress,
    this.blocks,
  });

  factory StudentChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return StudentChapterDetailModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      number: json['number'] as int?,
      chapterProgress: json['chapter_progress'] != null
          ? StudentChapterProgressModel.fromJson(
              json['chapter_progress'] as Map<String, dynamic>,
            )
          : null,
      blocks: json['blocks'] != null
          ? (json['blocks'] as List)
              .map((e) => BlockResponseModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'number': number,
      'chapter_progress': chapterProgress?.toJson(),
      'blocks': blocks?.map((e) => e.toJson()).toList(),
    };
  }
}
