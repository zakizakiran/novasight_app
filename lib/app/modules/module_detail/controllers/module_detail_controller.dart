import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/subject_args.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/models/module_model.dart';
import 'package:novasight_app/app/data/model/subject_model.dart';
import 'package:novasight_app/app/data/model/subject_page_module.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/module_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/module/controllers/module_controller.dart';
import 'package:novasight_app/app/modules/student-dashboard/controllers/student_dashboard_controller.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class ModuleDetailController extends GetxController {
  final int id;
  final ModuleRepository? moduleRepository;
  final StudentRepository? studentRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ModuleDetailController({
    int? moduleId,
    ModuleRepository? moduleRepository,
    ModuleRepository? repository,
    StudentRepository? studentRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : id = moduleId ?? (Get.arguments is int ? Get.arguments as int : 0),
        moduleRepository = moduleRepository ??
            repository ??
            (Get.isRegistered<ModuleRepository>()
                ? Get.find<ModuleRepository>()
                : null),
        studentRepository = studentRepository ??
            (Get.isRegistered<StudentRepository>()
                ? Get.find<StudentRepository>()
                : null),
        classroomRepository = classroomRepository ??
            (Get.isRegistered<ClassroomRepository>()
                ? Get.find<ClassroomRepository>()
                : null),
        storageService = storageService ??
            (Get.isRegistered<StorageService>()
                ? Get.find<StorageService>()
                : null);

  final state = Rx<UiState<void>>(
    const UiStateInitial<void>(),
  );

  final Rxn<StudentModuleDetailModel> studentModule =
      Rxn<StudentModuleDetailModel>();
  final RxnInt startingChapterId = RxnInt();

  ModuleModel? get localModule =>
      moduleRepository?.modules.firstWhereOrNull((m) => m.id == id);

  bool get hasApiDetail => studentModule.value != null;

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }

  Future<void> onLoad() async {
    state.value = const UiStateLoading();

    try {
      // 1. Try loading module detail from Student API
      if (studentRepository != null) {
        int? classroomId;
        if (classroomRepository != null) {
          final list = await classroomRepository!.getClassrooms();
          if (list.isNotEmpty) {
            final cachedCode = storageService?.getClassCode();
            final selected = list.firstWhereOrNull((c) => c.code == cachedCode) ??
                list.first;
            classroomId = selected.id;
          }
        }

        if (classroomId != null) {
          final result = await studentRepository!.getModuleDetail(
            moduleId: id,
            classroomId: classroomId,
          );
          studentModule.value = result;
          state.value = const UiStateSuccess(null);
          return;
        }
      }

      // 2. Fallback to local mock repository
      if (moduleRepository != null) {
        final result = await moduleRepository!.getModuleById(id);
        result.match(
          (failure) => state.value = UiStateFailure(failure.message),
          (data) => state.value = const UiStateSuccess(null),
        );
      } else {
        state.value = const UiStateSuccess(null);
      }
    } on ApiException catch (e) {
      state.value = UiStateFailure(e.message);
    } catch (e) {
      state.value = UiStateFailure(e.toString());
    }
  }

  /// Optimistically mark chapter done and update module progress
  void markChapterDoneLocally(int chapterId) {
    if (studentModule.value != null) {
      final current = studentModule.value!;
      final updatedChapters = current.chapters.map((ch) {
        if (ch.id == chapterId) {
          return ch.copyWith(
            chapterProgress: StudentChapterProgressModel(
              isDone: true,
              completedAt: DateTime.now(),
            ),
          );
        }
        return ch;
      }).toList();

      final totalCount = updatedChapters.length;
      final doneCount = updatedChapters
          .where((ch) => ch.chapterProgress?.isDone == true)
          .length;
      final newPercentage =
          totalCount > 0 ? ((doneCount / totalCount) * 100).round() : 0;
      final isAllDone = totalCount > 0 && doneCount == totalCount;

      final updatedProgress = current.progress != null
          ? current.progress!.copyWith(
              progressPercentage: newPercentage,
              isDone: isAllDone,
            )
          : ModuleProgressModel(
              id: 0,
              studentId: 0,
              moduleId: current.id,
              progressPercentage: newPercentage,
              isDone: isAllDone,
            );

      studentModule.value = current.copyWith(
        chapters: updatedChapters,
        progress: updatedProgress,
      );

      // Also proactively update ModuleController and StudentDashboardController in memory
      if (Get.isRegistered<ModuleController>()) {
        Get.find<ModuleController>().updateModuleProgressLocally(
          moduleId: current.id,
          progressPercentage: newPercentage,
          isDone: isAllDone,
        );
      }
      if (Get.isRegistered<StudentDashboardController>()) {
        Get.find<StudentDashboardController>().updateModuleProgressLocally(
          moduleId: current.id,
          progressPercentage: newPercentage,
          isDone: isAllDone,
        );
      }
    }
  }

  /// Start a chapter from the API and convert its blocks into readable subject pages
  Future<void> onChapterStudent(
    StudentChapterSummaryModel chapter,
    int index,
  ) async {
    if (startingChapterId.value != null) return;
    startingChapterId.value = chapter.id;

    try {
      if (studentRepository != null) {
        final detail = await studentRepository!.startChapter(
          chapterId: chapter.id,
        );

        // Convert BlockResponseModel items into SubjectPageModel
        final pages = <SubjectPageModel>[];
        if (detail.blocks != null && detail.blocks!.isNotEmpty) {
          for (final b in detail.blocks!) {
            pages.add(
              SubjectPageModel(
                title: '${chapter.title} • Bagian ${b.readingOrder}',
                subject: b.readableText,
              ),
            );
          }
        } else {
          pages.add(
            SubjectPageModel(
              title: chapter.title,
              subject: 'Belum ada konten materi untuk bab ini.',
            ),
          );
        }

        final subject = SubjectModel(
          id: chapter.id,
          title: chapter.title,
          isDone: chapter.chapterProgress?.isDone ?? false,
          pages: pages,
        );

        await Get.toNamed(
          Routes.SUBJECT,
          arguments: SubjectArgs(subject: subject, index: index),
        );
        await onLoad();
        return;
      }

      // Default fallback
      final fallbackSubject = SubjectModel(
        id: chapter.id,
        title: chapter.title,
        isDone: chapter.chapterProgress?.isDone ?? false,
        pages: [
          SubjectPageModel(
            title: chapter.title,
            subject: 'Materi bab: ${chapter.title}',
          ),
        ],
      );
      await Get.toNamed(
        Routes.SUBJECT,
        arguments: SubjectArgs(subject: fallbackSubject, index: index),
      );
      await onLoad();
    } catch (_) {
      // Fallback below if API call encounters issue
      final fallbackSubject = SubjectModel(
        id: chapter.id,
        title: chapter.title,
        isDone: chapter.chapterProgress?.isDone ?? false,
        pages: [
          SubjectPageModel(
            title: chapter.title,
            subject: 'Materi bab: ${chapter.title}',
          ),
        ],
      );
      await Get.toNamed(
        Routes.SUBJECT,
        arguments: SubjectArgs(subject: fallbackSubject, index: index),
      );
      await onLoad();
    } finally {
      startingChapterId.value = null;
    }
  }

  Future<void> onSubject(SubjectModel subject, int index) async {
    await Get.toNamed(
      Routes.SUBJECT,
      arguments: SubjectArgs(subject: subject, index: index),
    );
    await onLoad();
  }
}
