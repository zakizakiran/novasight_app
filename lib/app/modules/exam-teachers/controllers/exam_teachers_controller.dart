import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/exam_student_progress_args.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/data/models/quiz_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import '../../../routes/app_pages.dart';
import '../models/exam_teacher_model.dart';

class ExamTeachersController extends GetxController {
  final TeacherRepository? teacherRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ExamTeachersController({
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

  final selectedFilter = 'Semua'.obs;
  final filterOptions = const ['Semua', 'Publish', 'Draft'];

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Real backend quiz list
  final RxList<QuizRequestTeacherModel> quizzes = <QuizRequestTeacherModel>[].obs;
  final List<QuizRequestTeacherModel> _masterQuizzes = [];

  // In-progress action states
  final RxInt publishingQuizId = 0.obs;
  final RxInt deletingQuizId = 0.obs;

  int? _cachedClassroomId;

  @override
  void onInit() {
    super.onInit();
    fetchQuizzes();
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

  void _sortNewestFirst(List<QuizRequestTeacherModel> list) {
    list.sort((a, b) {
      // Sort by ID descending (newest created has higher id)
      final cmp = b.id.compareTo(a.id);
      if (cmp != 0) return cmp;
      return b.startTime.compareTo(a.startTime);
    });
  }

  void _applyLocalFilter() {
    if (_masterQuizzes.isEmpty) {
      quizzes.clear();
      return;
    }

    final filter = selectedFilter.value.toLowerCase();
    if (filter == 'semua') {
      quizzes.assignAll(_masterQuizzes);
    } else {
      quizzes.assignAll(
        _masterQuizzes.where((q) {
          final pub = q.statusPublished.toLowerCase();
          return pub == filter;
        }).toList(),
      );
    }
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    _applyLocalFilter();
  }

  Future<void> fetchQuizzes({bool showLoading = true}) async {
    if (teacherRepository == null) return;

    if (showLoading && _masterQuizzes.isEmpty) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final classroomId = await _resolveClassroomId();
      if (classroomId == null) {
        errorMessage.value = 'Tidak ada kelas yang ditemukan.';
        return;
      }

      final result = await teacherRepository!.getQuizzes(
        classroomId: classroomId,
      );

      _sortNewestFirst(result);
      _masterQuizzes.clear();
      _masterQuizzes.addAll(result);

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

  Future<void> onChangeQuizStatus(
    QuizRequestTeacherModel quiz,
    String newStatus,
  ) async {
    if (teacherRepository == null) return;

    final classroomId = await _resolveClassroomId();
    if (classroomId == null) return;

    publishingQuizId.value = quiz.id;
    try {
      final success = await teacherRepository!.updateQuizStatus(
        quizId: quiz.id,
        classroomId: classroomId,
        status: newStatus.toLowerCase(),
      );

      if (success) {
        final updated = quiz.copyWith(
          statusPublished: newStatus.toLowerCase(),
        );

        final masterIdx = _masterQuizzes.indexWhere((q) => q.id == quiz.id);
        if (masterIdx != -1) {
          _masterQuizzes[masterIdx] = updated;
        }

        final listIdx = quizzes.indexWhere((q) => q.id == quiz.id);
        if (listIdx != -1) {
          quizzes[listIdx] = updated;
        }
        _applyLocalFilter();

        final statusDisplay = newStatus.toLowerCase() == 'publish'
            ? 'dipublikasikan'
            : 'disimpan sebagai draft';
        SnackbarHelper.showSuccess(
          title: 'Status Diperbarui',
          message: 'Soal ujian berhasil $statusDisplay.',
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: 'Gagal Mengubah Status',
        message: e.message,
      );
    } catch (e) {
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Gagal memperbarui status kuis: ${e.toString()}',
      );
    } finally {
      publishingQuizId.value = 0;
    }
  }

  Future<void> onDeleteQuiz(QuizRequestTeacherModel quiz) async {
    if (teacherRepository == null) return;

    final classroomId = await _resolveClassroomId();
    if (classroomId == null) return;

    deletingQuizId.value = quiz.id;
    try {
      final success = await teacherRepository!.deleteQuiz(
        quizId: quiz.id,
        classroomId: classroomId,
      );

      if (success) {
        _masterQuizzes.removeWhere((q) => q.id == quiz.id);
        quizzes.removeWhere((q) => q.id == quiz.id);
        _applyLocalFilter();

        Get.back(); // close dialog if open
        SnackbarHelper.showSuccess(
          title: 'Kuis Dihapus',
          message: 'Kuis "${quiz.title}" berhasil dihapus.',
        );
      }
    } on ApiException catch (e) {
      SnackbarHelper.showError(title: 'Gagal Menghapus Kuis', message: e.message);
    } catch (e) {
      SnackbarHelper.showError(
        title: 'Error',
        message: 'Gagal menghapus kuis: ${e.toString()}',
      );
    } finally {
      deletingQuizId.value = 0;
    }
  }

  // Backward compatibility methods for existing callers/UI
  void onDeleteExam(ExamTeacherModel exam) {
    Get.back();
    final match = _masterQuizzes.firstWhereOrNull((q) => q.id.toString() == exam.id);
    if (match != null) {
      onDeleteQuiz(match);
    }
  }

  void onChangeExamStatus(ExamTeacherModel exam, String status) {
    final match = _masterQuizzes.firstWhereOrNull((q) => q.id.toString() == exam.id);
    if (match != null) {
      onChangeQuizStatus(match, status);
    }
  }

  void onAddExam(ExamTeacherModel exam) {
    fetchQuizzes(showLoading: false);
  }

  void onDetailExam(QuizRequestTeacherModel quiz) {
    Get.toNamed(Routes.EXAM_TEACHERS_DETAIL, arguments: quiz);
  }

  void onStudentExamProgress(QuizRequestTeacherModel quiz) {
    print('Quiz Id : ${quiz.id}');
    Get.toNamed(Routes.EXAM_TEACHER_STUDENT_PROGRESS,arguments: ExamStudentProgressArgs(quizId: quiz.id, title: quiz.title));
  }

  List<ExamTeacherModel> get filteredExams {
    return quizzes.map((q) {
      return ExamTeacherModel(
        id: q.id.toString(),
        title: q.title,
        questionCount: q.questionCounts,
        type: 'Pilihan Ganda',
        difficulty: 'Campuran',
        moduleName: q.module.title.isNotEmpty
            ? q.module.title
            : 'Modul #${q.moduleId}',
        status: q.isPublished ? 'Publish' : 'Draft',
      );
    }).toList();
  }
}
