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

  // Cp endpoints
  static String cp(int faseId) => '/api/cp/$faseId';

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
  static const String studentQuizzes = '/api/students/quizzes';
  static String studentQuizStart(int quizId) => '/api/students/quizzes/$quizId/start';
  static String studentQuizFinish(int quizId) => '/api/students/quizzes/$quizId/finish';
  static String studentQuizMyResults(int quizRequestId) => '/api/students/quizzes/$quizRequestId/my-results';
  static String studentSoalSubmit(int soalId) => '/api/students/soal/$soalId/select-option';
  static String studentSoalStep(int soalId) => '/api/students/soal/$soalId/steps';
  static String studentDeleteStep(int stepId) => '/api/students/steps/$stepId';

  // Teacher endpoints
  static const String teacherDashboard = '/api/teachers/dashboard';
  static const String teacherModules = '/api/teachers/modules';
  static String teacherModuleDetail(int moduleId) => '/api/teachers/modules/$moduleId';
  static String teacherChapterDetail(int chapterId) => '/api/teachers/chapters/$chapterId';
  static const String createModule = '/api/modules';
  static String publishModule(int moduleId) => '/api/modules/publish/$moduleId';
  static const String fases = '/api/fases';
  static const String createChapter = '/api/chapters';
  static String chapterJobStream(int jobId) => '/api/chapters/jobs/$jobId/stream';
  static String teacherStudentQuizResults(int quizRequestId) => '/api/teachers/quizzes/$quizRequestId/student-results';
  static const String previewChapter = '/api/chapters/preview';
  static String confirmChapter(int chapterId) => '/api/chapters/confirm/$chapterId';
  static const String bulkRegenerateText = '/api/blocks/bulk-regenerate/text';
  static const String bulkRegenerateSpecial = '/api/blocks/bulk-regenerate/special';

  // Teacher Quiz endpoints
  static const String teacherQuizzes = '/api/teachers/quizzes';
  static String teacherQuizDetail(int quizId) => '/api/teachers/quizzes/$quizId';
  static String teacherQuizDelete(int quizId) => '/api/teachers/quizzes/$quizId';
  static String teacherQuizStudentProgress(int quizId) => '/api/teachers/quizzes/$quizId/students';
  static String teacherQuizStatus(int quizId) => '/api/teachers/quizzes/statuses/$quizId';
  static String teacherSoalStimulusRegenerate(int soalId) => '/api/teachers/soal/stimulus/regenerate/$soalId';
  static String teacherSoalEdit(int soalId) => '/api/teachers/soal/$soalId';

  // Chatbot endpoints
  static const String chatbotSessions = '/api/chatbot/sessions';
  static String chatbotSessionMessages(int sessionId) => '/api/chatbot/sessions/$sessionId/messages';
  static String chatbotChapterReindex(int chapterId) => '/api/chatbot/chapters/$chapterId/reindex';
  static String chatbotClassroomReindex(int classroomId) => '/api/chatbot/classrooms/$classroomId/reindex';

  // Health
  static const String health = '/health';
}
