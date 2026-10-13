import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

import '../../../data/models/exam_model.dart';


class ExamController extends GetxController {
  final StudentRepository? studentRepository;
  final ClassroomRepository? classroomRepository;
  final StorageService? storageService;

  ExamController({
    StudentRepository? studentRepository,
    ClassroomRepository? classroomRepository,
    StorageService? storageService,
  })  : studentRepository = studentRepository ??
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

  final selectedStatus = PublicStatus.all.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<QuizRequestStudentResponse> quizzes =
      <QuizRequestStudentResponse>[].obs;
  RxList<QuizRequestStudentResponse> get apiExams => quizzes;

  List<ExamModel> get filteredExams {
    if (quizzes.isNotEmpty) {
      final list = quizzes.map((q) {
        final isDone = q.progress?.isDone == true;
        return ExamModel(
          id: q.id.toString(),
          title: q.title,
          subtitle: q.module.title,
          statusText: isDone ? 'Selesai dikerjakan' : 'Belum dikerjakan',
          score: q.progress?.score != null
              ? q.progress!.score!.toInt().toString()
              : '-',
          status: isDone ? PublicStatus.done : PublicStatus.notDone,
          rawQuiz: q,
        );
      }).toList();

      return switch (selectedStatus.value) {
        PublicStatus.all => list,
        PublicStatus.notDone =>
          list.where((e) => e.status == PublicStatus.notDone).toList(),
        PublicStatus.done =>
          list.where((e) => e.status == PublicStatus.done).toList(),
      };
    } else {
      return [];
    }
  }

  Future<void> onLoad() async {
    if (studentRepository == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      int? classroomId;
      if (classroomRepository != null) {
        final list = await classroomRepository!.getClassrooms();
        if (list.isNotEmpty) {
          final cachedCode = storageService?.getClassCode();
          final selected =
              list.firstWhereOrNull((c) => c.code == cachedCode) ?? list.first;
          classroomId = selected.id;
        }
      }

      if (classroomId != null) {
        final queryStatus = switch (selectedStatus.value) {
          PublicStatus.all => QuizRequestStudentQueryStatus.semua,
          PublicStatus.notDone => QuizRequestStudentQueryStatus.belumDikerjakan,
          PublicStatus.done => QuizRequestStudentQueryStatus.selesai,
        };

        final result = await studentRepository!.getQuizzes(
          classroomId: classroomId,
          status: queryStatus,
        );
        quizzes.value = result;
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void onChangeStatus(PublicStatus status) {
    selectedStatus.value = status;
    onLoad();
  }

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }
}
