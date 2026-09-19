import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class ExamDummyModel {
  final String id;
  final String title;
  final String subtitle;
  final String statusText;
  final String nilai;
  final ModuleStatus status;
  final QuizRequestStudentResponse? rawQuiz;

  ExamDummyModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.nilai,
    required this.status,
    this.rawQuiz,
  });
}

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

  final selectedStatus = ModuleStatus.all.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<QuizRequestStudentResponse> quizzes =
      <QuizRequestStudentResponse>[].obs;
  RxList<QuizRequestStudentResponse> get apiExams => quizzes;

  final exams = <ExamDummyModel>[
    ExamDummyModel(
      id: '1',
      title: 'UTS Kelas X',
      subtitle: 'Bab Eksponen dan Logaritma',
      statusText: 'Belum dikerjakan',
      nilai: '-',
      status: ModuleStatus.notDone,
    ),
    ExamDummyModel(
      id: '2',
      title: 'UH 1 — Himpunan dan Operasinya',
      subtitle: 'Bab Himpunan dan Operasinya',
      statusText: 'Belum dikerjakan',
      nilai: '-',
      status: ModuleStatus.notDone,
    ),
    ExamDummyModel(
      id: '3',
      title: 'UAS Semester 1',
      subtitle: 'Semua Bab',
      statusText: 'Selesai dikerjakan',
      nilai: '90',
      status: ModuleStatus.done,
    ),
    ExamDummyModel(
      id: '4',
      title: 'Kuis Singkat — Aljabar',
      subtitle: 'Bab Aljabar',
      statusText: 'Selesai dikerjakan',
      nilai: '85',
      status: ModuleStatus.done,
    ),
  ];

  List<ExamDummyModel> get filteredExams {
    if (quizzes.isNotEmpty) {
      final list = quizzes.map((q) {
        final isDone = q.progress?.isDone == true;
        return ExamDummyModel(
          id: q.id.toString(),
          title: q.title,
          subtitle: q.module.title,
          statusText: isDone ? 'Selesai dikerjakan' : 'Belum dikerjakan',
          nilai: q.progress?.score != null
              ? q.progress!.score!.toInt().toString()
              : '-',
          status: isDone ? ModuleStatus.done : ModuleStatus.notDone,
          rawQuiz: q,
        );
      }).toList();

      return switch (selectedStatus.value) {
        ModuleStatus.all => list,
        ModuleStatus.notDone =>
          list.where((e) => e.status == ModuleStatus.notDone).toList(),
        ModuleStatus.done =>
          list.where((e) => e.status == ModuleStatus.done).toList(),
      };
    }

    return switch (selectedStatus.value) {
      ModuleStatus.all => exams.toList(),
      ModuleStatus.notDone =>
        exams.where((e) => e.status == ModuleStatus.notDone).toList(),
      ModuleStatus.done =>
        exams.where((e) => e.status == ModuleStatus.done).toList(),
    };
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
          ModuleStatus.all => QuizRequestStudentQueryStatus.semua,
          ModuleStatus.notDone => QuizRequestStudentQueryStatus.belumDikerjakan,
          ModuleStatus.done => QuizRequestStudentQueryStatus.selesai,
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

  void onChangeStatus(ModuleStatus status) {
    selectedStatus.value = status;
    onLoad();
  }

  @override
  void onInit() {
    super.onInit();
    onLoad();
  }
}
