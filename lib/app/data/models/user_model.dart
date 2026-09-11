class TeacherResponseModel {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TeacherResponseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TeacherResponseModel.fromJson(Map<String, dynamic> json) {
    return TeacherResponseModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class StudentResponseModel {
  final int id;
  final String? nis;
  final String? nisn;
  final int? grade;
  final DateTime createdAt;
  final DateTime updatedAt;

  const StudentResponseModel({
    required this.id,
    this.nis,
    this.nisn,
    this.grade,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudentResponseModel.fromJson(Map<String, dynamic> json) {
    return StudentResponseModel(
      id: json['id'] as int,
      nis: json['nis'] as String?,
      nisn: json['nisn'] as String?,
      grade: json['grade'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nis': nis,
      'nisn': nisn,
      'grade': grade,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProfileResponseModel {
  final int id;
  final String email;
  final TeacherResponseModel? teacher;
  final StudentResponseModel? student;

  const ProfileResponseModel({
    required this.id,
    required this.email,
    this.teacher,
    this.student,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      id: json['id'] as int,
      email: json['email'] as String,
      teacher: json['teacher'] != null
          ? TeacherResponseModel.fromJson(json['teacher'] as Map<String, dynamic>)
          : null,
      student: json['student'] != null
          ? StudentResponseModel.fromJson(json['student'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'teacher': teacher?.toJson(),
      'student': student?.toJson(),
    };
  }
}
