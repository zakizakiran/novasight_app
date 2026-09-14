import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
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
  final RxList<dynamic> taskExams = <dynamic>[].obs;
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

      final result = await studentRepository.getDashboardTasks(
        classroomId: classroomId,
        status: status ?? selectedFilter.value,
      );

      taskModules.value = result.modules;
      taskExams.value = result.exams;
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
