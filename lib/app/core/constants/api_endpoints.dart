class ApiEndpoints {
  ApiEndpoints._();

  // Auth & User endpoints
  static const String login = '/api/users/login';
  static const String profile = '/api/users/profile';
  static const String registerStudent = '/api/students';
  static const String registerTeacher = '/api/teachers';

  // Classroom endpoints
  static const String classrooms = '/api/classrooms';
  static const String joinClassroom = '/api/classrooms/join';
  static const String classroomTypes = '/api/classroom-types';

  // School & City endpoints
  static const String cities = '/api/cities';
  static const String schools = '/api/schools';

  // Health
  static const String health = '/health';
}
