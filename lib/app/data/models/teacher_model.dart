// DTO models for Teacher API endpoints.
// Maps strictly to OpenAPI schema contract:
// - TeacherModuleStatus
// - TeacherDashboardResponse -> TeacherDashboardModel
// - ModuleResponse -> TeacherNewestModuleModel
// - TeacherModuleWithoutChapterResponse -> TeacherModuleModel
// - TeacherModuleResponse -> TeacherModuleDetailModel
// - ChapterResponse -> TeacherChapterSummaryModel
// - ChapterDetailResponse -> TeacherChapterDetailModel

import 'package:flutter/widgets.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/data/models/student_model.dart';

enum TeacherModuleStatus {
  semua('Semua'),
  draft('draft'),
  publish('publish');

  final String value;
  const TeacherModuleStatus(this.value);

  String get label {
    switch (this) {
      case TeacherModuleStatus.semua:
        return 'Semua';
      case TeacherModuleStatus.draft:
        return 'Draft';
      case TeacherModuleStatus.publish:
        return 'Publish';
    }
  }

  String localizedLabel(BuildContext context) {
    switch (this) {
      case TeacherModuleStatus.semua:
        return context.l10n.filterAll;
      case TeacherModuleStatus.draft:
        return context.l10n.filterDraft;
      case TeacherModuleStatus.publish:
        return context.l10n.filterPublish;
    }
  }

  static TeacherModuleStatus fromString(String? val) {
    return TeacherModuleStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == val?.toLowerCase(),
      orElse: () => TeacherModuleStatus.semua,
    );
  }
}

class TeacherNewestModuleModel {
  final int id;
  final String title;
  final int? faseId;
  final DateTime createdAt;

  TeacherNewestModuleModel({
    required this.id,
    required this.title,
    this.faseId,
    required this.createdAt,
  });

  factory TeacherNewestModuleModel.fromJson(Map<String, dynamic> json) {
    return TeacherNewestModuleModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      faseId: json['fase_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fase_id': faseId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TeacherDashboardModel {
  final String teacherEmail;
  final ClassroomInfoModel? classroomInfo;
  final int totalModules;
  final int totalExams;
  final int totalStudents;
  final List<TeacherNewestModuleModel> newestModules;
  final List<dynamic> newestExams;

  TeacherDashboardModel({
    required this.teacherEmail,
    this.classroomInfo,
    this.totalModules = 0,
    this.totalExams = 0,
    this.totalStudents = 0,
    this.newestModules = const [],
    this.newestExams = const [],
  });

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardModel(
      teacherEmail: json['teacher_email'] as String? ?? '',
      classroomInfo: json['classroom_info'] != null
          ? ClassroomInfoModel.fromJson(
              json['classroom_info'] as Map<String, dynamic>,
            )
          : null,
      totalModules: json['total_modules'] as int? ?? 0,
      totalExams: json['total_exams'] as int? ?? 0,
      totalStudents: json['total_students'] as int? ?? 0,
      newestModules: json['newest_modules'] != null
          ? (json['newest_modules'] as List)
              .map((e) =>
                  TeacherNewestModuleModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      newestExams: json['newest_exams'] as List? ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_email': teacherEmail,
      'classroom_info': classroomInfo?.toJson(),
      'total_modules': totalModules,
      'total_exams': totalExams,
      'total_students': totalStudents,
      'newest_modules': newestModules.map((e) => e.toJson()).toList(),
      'newest_exams': newestExams,
    };
  }
}

class TeacherModuleModel {
  final int id;
  final String title;
  final int? faseId;
  final DateTime createdAt;
  final String? status;

  TeacherModuleModel({
    required this.id,
    required this.title,
    this.faseId,
    required this.createdAt,
    this.status,
  });

  factory TeacherModuleModel.fromJson(Map<String, dynamic> json) {
    return TeacherModuleModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      faseId: json['fase_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fase_id': faseId,
      'created_at': createdAt.toIso8601String(),
      'status': status,
    };
  }
}

class TeacherChapterSummaryModel {
  final int id;
  final int moduleId;
  final int? number;
  final String? title;
  final String? sourceFile;
  final int? cpId;
  final DateTime createdAt;

  TeacherChapterSummaryModel({
    required this.id,
    required this.moduleId,
    this.number,
    this.title,
    this.sourceFile,
    this.cpId,
    required this.createdAt,
  });

  factory TeacherChapterSummaryModel.fromJson(Map<String, dynamic> json) {
    return TeacherChapterSummaryModel(
      id: json['id'] as int,
      moduleId: json['module_id'] as int,
      number: json['number'] as int?,
      title: json['title'] as String?,
      sourceFile: json['source_file'] as String?,
      cpId: json['cp_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'number': number,
      'title': title,
      'source_file': sourceFile,
      'cp_id': cpId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class TeacherModuleDetailModel {
  final int id;
  final String title;
  final int? faseId;
  final DateTime createdAt;
  final String? status;
  final List<TeacherChapterSummaryModel> chapters;

  TeacherModuleDetailModel({
    required this.id,
    required this.title,
    this.faseId,
    required this.createdAt,
    this.status,
    this.chapters = const [],
  });

  factory TeacherModuleDetailModel.fromJson(Map<String, dynamic> json) {
    return TeacherModuleDetailModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      faseId: json['fase_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      status: json['status'] as String?,
      chapters: json['chapters'] != null
          ? (json['chapters'] as List)
              .map((e) =>
                  TeacherChapterSummaryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'fase_id': faseId,
      'created_at': createdAt.toIso8601String(),
      'status': status,
      'chapters': chapters.map((e) => e.toJson()).toList(),
    };
  }
}

class TeacherChapterDetailModel {
  final int id;
  final int moduleId;
  final int? number;
  final String? title;
  final String? sourceFile;
  final int? cpId;
  final DateTime createdAt;
  final List<BlockResponseModel> blocks;

  TeacherChapterDetailModel({
    required this.id,
    required this.moduleId,
    this.number,
    this.title,
    this.sourceFile,
    this.cpId,
    required this.createdAt,
    required this.blocks,
  });

  factory TeacherChapterDetailModel.fromJson(Map<String, dynamic> json) {
    return TeacherChapterDetailModel(
      id: json['id'] as int,
      moduleId: json['module_id'] as int,
      number: json['number'] as int?,
      title: json['title'] as String?,
      sourceFile: json['source_file'] as String?,
      cpId: json['cp_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      blocks: json['blocks'] != null
          ? (json['blocks'] as List)
              .map((e) => BlockResponseModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module_id': moduleId,
      'number': number,
      'title': title,
      'source_file': sourceFile,
      'cp_id': cpId,
      'created_at': createdAt.toIso8601String(),
      'blocks': blocks.map((e) => e.toJson()).toList(),
    };
  }
}
