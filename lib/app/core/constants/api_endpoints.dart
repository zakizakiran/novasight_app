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

  // Student endpoints
  static const String studentDashboard = '/api/students/dashboard';
  static const String studentDashboardTasks = '/api/students/dashboard/tasks';
  static const String studentModules = '/api/students/modules';
  static String studentModuleDetail(int moduleId) => '/api/students/modules/$moduleId';
  static String studentChapterStart(int chapterId) => '/api/students/chapters/$chapterId/start';
  static String studentChapterMarkComplete(int chapterId) => '/api/students/chapters/$chapterId/mark-complete';

  // Health
  static const String health = '/health';
}
