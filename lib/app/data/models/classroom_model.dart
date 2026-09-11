/// DTO models for Classroom API endpoints.
/// Maps to the API contract schemas: ClassroomCreate, ClassroomResponse,
/// ClassroomTypeResponse, CityResponse, SchoolResponse.

class ClassroomTypeModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassroomTypeModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassroomTypeModel.fromJson(Map<String, dynamic> json) {
    return ClassroomTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  String toString() => name;
}

class CityResponseModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  CityResponseModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityResponseModel.fromJson(Map<String, dynamic> json) {
    return CityResponseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  String toString() => name;
}

class SchoolResponseModel {
  final int id;
  final int cityId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  SchoolResponseModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SchoolResponseModel.fromJson(Map<String, dynamic> json) {
    return SchoolResponseModel(
      id: json['id'] as int,
      cityId: json['city_id'] as int,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  String toString() => name;
}

class ClassroomCreateModel {
  final String name;
  final int classroomTypeId;
  final int schoolId;
  final int grade;

  ClassroomCreateModel({
    required this.name,
    required this.classroomTypeId,
    required this.schoolId,
    required this.grade,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'classroom_type_id': classroomTypeId,
      'school_id': schoolId,
      'grade': grade,
    };
  }
}

class ClassroomResponseModel {
  final int id;
  final int teacherId;
  final int schoolId;
  final String name;
  final String code;
  final int grade;
  final ClassroomTypeModel classroomType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassroomResponseModel({
    required this.id,
    required this.teacherId,
    required this.schoolId,
    required this.name,
    required this.code,
    required this.grade,
    required this.classroomType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassroomResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassroomResponseModel(
      id: json['id'] as int,
      teacherId: json['teacher_id'] as int,
      schoolId: json['school_id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
      grade: json['grade'] as int,
      classroomType: ClassroomTypeModel.fromJson(
        json['classroom_type'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

class JoinClassroomRequestModel {
  final String code;

  JoinClassroomRequestModel({required this.code});

  Map<String, dynamic> toJson() {
    return {'code': code};
  }
}
