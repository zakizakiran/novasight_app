import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/core/utils/module_status.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/exam/controllers/exam_controller.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockStudentRepository mockStudentRepo;
  late MockClassroomRepository mockClassroomRepo;
  late MockStorageService mockStorage;

  final testNow = DateTime.parse('2026-09-14T00:00:00.000Z');

  final mockClassrooms = [
    ClassroomResponseModel(
      id: 10,
      teacherId: 2,
      schoolId: 1,
      name: 'Kelas 10 Matematika',
      code: 'CLS-1234',
      grade: 10,
      classroomType: ClassroomTypeModel(
        id: 1,
        name: 'Tunanetra',
        createdAt: testNow,
        updatedAt: testNow,
      ),
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  final mockQuizzes = [
    QuizRequestStudentResponse(
      id: 101,
      moduleId: 12,
      title: 'UTS Ujian Semester 1',
      statusPublished: 'publish',
      maxDurationMinutes: 60,
      maxRetry: 1,
      startTime: testNow,
      endTime: testNow.add(const Duration(days: 7)),
      questionCounts: 5,
      module: ModuleQuizResponse(id: 12, title: 'Matematika Dasar', description: 'Deskripsi'),
      progress: QuizRequestStudentProgressResponse(
        isDone: false,
        score: null,
      ),
    ),
  ];

  setUp(() {
    Get.reset();
    mockStudentRepo = MockStudentRepository();
    mockClassroomRepo = MockClassroomRepository();
    mockStorage = MockStorageService();

    when(() => mockStorage.getClassCode()).thenReturn('CLS-1234');
    when(() => mockClassroomRepo.getClassrooms())
        .thenAnswer((_) async => mockClassrooms);
    when(
      () => mockStudentRepo.getQuizzes(
        classroomId: any(named: 'classroomId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) async => mockQuizzes);
  });

  group('ExamController Tests', () {
    test('Initial onLoad fetches quizzes from StudentRepository', () async {
      final controller = ExamController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.quizzes.length, equals(1));
      expect(controller.apiExams.length, equals(1));
      expect(controller.errorMessage.value, isEmpty);

      verify(
        () => mockStudentRepo.getQuizzes(
          classroomId: 10,
          status: QuizRequestStudentQueryStatus.semua,
        ),
      ).called(1);
    });

    test('onChangeStatus updates filter and triggers refetch', () async {
      final controller = ExamController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      controller.onChangeStatus(PublicStatus.done);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.selectedStatus.value, equals(PublicStatus.done));
      verify(
        () => mockStudentRepo.getQuizzes(
          classroomId: 10,
          status: QuizRequestStudentQueryStatus.selesai,
        ),
      ).called(1);
    });

    test('Handles ApiException gracefully and sets errorMessage', () async {
      when(
        () => mockStudentRepo.getQuizzes(
          classroomId: any(named: 'classroomId'),
          status: any(named: 'status'),
        ),
      ).thenThrow(const ApiException(message: 'Gagal mengambil soal ujian'));

      final controller = ExamController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, equals('Gagal mengambil soal ujian'));
      expect(controller.filteredExams, isNotEmpty);
    });
  });
}
