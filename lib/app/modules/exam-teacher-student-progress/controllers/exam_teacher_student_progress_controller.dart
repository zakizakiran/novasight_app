import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/student_progress_quiz.dart';

import '../../../core/errors/api_exception.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../data/repositories/classroom_repository.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../../data/services/local/storage_service.dart';

class ExamTeacherStudentProgressController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  final selectedFilter = 'Semua'.obs;
  final filterOptions = const ['Semua', 'Selesai', 'Belum Dikerjakan'];

  final RxList<StudentProgressQuiz> quizzesProgress = <StudentProgressQuiz>[].obs;
  final List<StudentProgressQuiz> _masterQuizzesProgress = [];

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final quizId = Rx<int?>(null);

  ExamTeacherStudentProgressController({
    TeacherRepository? teacherRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : teacherRepository = teacherRepository ??
      (Get.isRegistered<TeacherRepository>()
          ? Get.find<TeacherRepository>()
          : null),
        classroomRepository = classroomRepository ??
            (Get.isRegistered<ClassroomRepository>()
                ? Get.find<ClassroomRepository>()
                : null),
        storageService = storageService ??
            (Get.isRegistered<StorageService>()
                ? Get.find<StorageService>()
                : null);

  int? _cachedClassroomId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is int) {
      quizId.value = args;
    }
    fetchQuizzesProgress();
  }


  Future<int?> _resolveClassroomId({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedClassroomId != null) return _cachedClassroomId;
    if (classroomRepository == null) return null;
    final list = await classroomRepository!.getClassrooms();
    if (list.isEmpty) return null;
    final cachedCode = storageService?.getClassCode();
    final selected =
        list.firstWhereOrNull((c) => c.code == cachedCode) ?? list.first;
    _cachedClassroomId = selected.id;
    return selected.id;
  }

  Future<void> fetchQuizzesProgress({bool showLoading = true}) async {
    if (teacherRepository == null) return;

    if (showLoading && _masterQuizzesProgress.isEmpty) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final classroomId = await _resolveClassroomId();
      if (classroomId == null) {
        errorMessage.value = 'Tidak ada kelas yang ditemukan.';
        return;
      }

      final result = await teacherRepository!.getStudentQuizzesProgress(
        classroomId: classroomId,
        quizId: quizId.value ?? -1,
      );

      _masterQuizzesProgress.clear();
      _masterQuizzesProgress.addAll(result);

      _applyLocalFilter();
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(title: 'Gagal Memuat Kuis', message: e.message);
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan saat memuat data kuis.';
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Gagal memuat kuis: ${e.toString()}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyLocalFilter();
  }

  void _applyLocalFilter() {
    if (_masterQuizzesProgress.isEmpty) {
      quizzesProgress.clear();
      return;
    }

    final filter = selectedFilter.value.toLowerCase();
    if (filter == 'semua') {
      quizzesProgress.assignAll(_masterQuizzesProgress);
    } else if (filter == 'belum dikerjakan'){
      quizzesProgress.assignAll(
        _masterQuizzesProgress.where((q) {
          final pub = q.quizProgress?.score;
          return pub == null;
        }).toList(),
      );
    } else if (filter == 'selesai'){
      quizzesProgress.assignAll(
        _masterQuizzesProgress.where((q) {
          final pub = q.quizProgress?.score;
          return pub != null;
        }).toList(),
      );
    }
  }
}
