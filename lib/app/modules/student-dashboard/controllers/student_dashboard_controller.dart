import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class StudentDashboardController extends GetxController {
  final StudentRepository studentRepository;
  final ClassroomRepository classroomRepository;
  final StorageService storageService;

  StudentDashboardController({
    StudentRepository? studentRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : studentRepository =
            studentRepository ?? Get.find<StudentRepository>(),
        classroomRepository =
            classroomRepository ?? Get.find<ClassroomRepository>(),
        storageService = storageService ?? Get.find<StorageService>();

  // Reactive state for Dashboard
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<StudentDashboardModel> dashboardData = Rxn<StudentDashboardModel>();

  // Reactive state for Tasks
  final RxBool isLoadingTasks = false.obs;
  final RxString tasksErrorMessage = ''.obs;
  final RxList<StudentModuleModel> taskModules = <StudentModuleModel>[].obs;
  final RxList<QuizRequestStudentResponse> taskExams =
      <QuizRequestStudentResponse>[].obs;
  final Rx<StudentTaskStatus> selectedFilter = StudentTaskStatus.semua.obs;

  // Active student & classroom display information
  final RxString studentName = ''.obs;
  final RxString classroomSubtitle = ''.obs;
  final RxnInt activeClassroomId = RxnInt();
  final RxList<ClassroomResponseModel> classrooms =
      <ClassroomResponseModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialCache();
    initStudentData();
  }

  void _loadInitialCache() {
    final cachedName = storageService.getUserName();
    if (cachedName != null && cachedName.isNotEmpty) {
      studentName.value = cachedName;
    }
    final cachedEmail = storageService.getUserEmail();
    if (studentName.value.isEmpty && cachedEmail != null && cachedEmail.isNotEmpty) {
      studentName.value = cachedEmail.split('@').first;
    }
    final cachedClassName = storageService.getClassName();
    if (cachedClassName != null && cachedClassName.isNotEmpty) {
      classroomSubtitle.value = cachedClassName;
    }
  }

  /// Initial load: fetch student classrooms, pick active classroom, then load dashboard and tasks
  Future<void> initStudentData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final list = await classroomRepository.getClassrooms();
      classrooms.value = list;

      if (list.isNotEmpty) {
        // Prioritize cached class code if any, otherwise first classroom
        final cachedCode = storageService.getClassCode();
        final selected = list.firstWhereOrNull((c) => c.code == cachedCode) ?? list.first;

        activeClassroomId.value = selected.id;
        await storageService.writeClassCode(selected.code);
        await storageService.writeClassName(
          '${selected.classroomType.name} • Kelas ${selected.grade}',
        );
        classroomSubtitle.value =
            '${selected.classroomType.name} • Kelas ${selected.grade}';

        await Future.wait([
          fetchDashboard(selected.id),
          fetchTasks(selected.id, status: selectedFilter.value),
        ]);
      } else {
        errorMessage.value = 'Anda belum terdaftar di kelas manapun.';
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Gagal memuat data kelas siswa: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch student dashboard metrics
  Future<void> fetchDashboard(int classroomId) async {
    try {
      final result = await studentRepository.getDashboard(classroomId: classroomId);
      dashboardData.value = result;

      if (result.studentEmail.isNotEmpty) {
        final emailPrefix = result.studentEmail.split('@').first;
        if (studentName.value.isEmpty || studentName.value == 'Siswa') {
          studentName.value = emailPrefix;
        }
      }

      if (result.classroomInfo != null) {
        final info = result.classroomInfo!;
        classroomSubtitle.value =
            '${info.classroomType} • Kelas ${info.gradeClass} • ${info.schoolName}';
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = 'Gagal memuat ringkasan dashboard: ${e.toString()}';
    }
  }

  /// Fetch tasks (modules & exams) filtered by status
  Future<void> fetchTasks(int classroomId, {StudentTaskStatus? status}) async {
    try {
      isLoadingTasks.value = true;
      tasksErrorMessage.value = '';

      final targetStatus = status ?? selectedFilter.value;

      // 1. Fetch dashboard tasks (maintains compatibility and initial state)
      try {
        final result = await studentRepository.getDashboardTasks(
          classroomId: classroomId,
          status: targetStatus,
        );
        taskModules.value = result.modules;
        taskExams.value = result.exams;
      } catch (_) {}

      // 2. Fetch all modules & quizzes to ensure completed modules and all exams are always displayed
      try {
        final modulesFuture = (targetStatus == StudentTaskStatus.semua ||
                targetStatus == StudentTaskStatus.materi)
            ? studentRepository.getModules(
                classroomId: classroomId,
                status: StudentModuleStatus.semua,
              )
            : Future.value(<StudentModuleModel>[]);

        final quizzesFuture = (targetStatus == StudentTaskStatus.semua ||
                targetStatus == StudentTaskStatus.soalUjian)
            ? studentRepository.getQuizzes(
                classroomId: classroomId,
                status: QuizRequestStudentQueryStatus.semua,
              )
            : Future.value(<QuizRequestStudentResponse>[]);

        final results = await Future.wait([modulesFuture, quizzesFuture]);
        final allModules = results[0] as List<StudentModuleModel>;
        final allQuizzes = results[1] as List<QuizRequestStudentResponse>;

        if (allModules.isNotEmpty || targetStatus == StudentTaskStatus.materi) {
          taskModules.value = allModules;
        }
        if (allQuizzes.isNotEmpty || targetStatus == StudentTaskStatus.soalUjian) {
          taskExams.value = allQuizzes;
        }
      } catch (_) {
        // Fallback to dashboard tasks if modules/quizzes endpoint is not mocked or fails
      }
    } on ApiException catch (e) {
      tasksErrorMessage.value = e.message;
    } catch (e) {
      tasksErrorMessage.value = 'Gagal memuat daftar tugas: ${e.toString()}';
    } finally {
      isLoadingTasks.value = false;
    }
  }

  /// Change filter chip ('Semua', 'Materi', 'Soal Ujian')
  Future<void> onFilterChanged(StudentTaskStatus status) async {
    if (selectedFilter.value == status) return;
    selectedFilter.value = status;

    if (activeClassroomId.value != null) {
      await fetchTasks(activeClassroomId.value!, status: status);
    }
  }

  /// Optimistically update module progress in taskModules
  void updateModuleProgressLocally({
    required int moduleId,
    required int progressPercentage,
    required bool isDone,
  }) {
    final index = taskModules.indexWhere((m) => m.id == moduleId);
    if (index != -1) {
      final old = taskModules[index];
      final newProgress = old.progress != null
          ? old.progress!.copyWith(
              progressPercentage: progressPercentage,
              isDone: isDone,
            )
          : ModuleProgressModel(
              id: 0,
              studentId: 0,
              moduleId: moduleId,
              progressPercentage: progressPercentage,
              isDone: isDone,
            );
      taskModules[index] = old.copyWith(progress: newProgress);
      taskModules.refresh();
    }
  }

  /// Refresh all data for pull-to-refresh
  Future<void> onRefresh() async {
    if (activeClassroomId.value != null) {
      await Future.wait([
        fetchDashboard(activeClassroomId.value!),
        fetchTasks(activeClassroomId.value!, status: selectedFilter.value),
      ]);
    } else {
      await initStudentData();
    }
  }
}
