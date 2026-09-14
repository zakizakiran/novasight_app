import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/exam/controllers/exam_controller.dart';

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

  final mockTasks = StudentTaskModel(
    modules: [],
    exams: [
      {'id': 101, 'title': 'UTS Ujian Semester 1'}
    ],
  );

  setUp(() {
    Get.reset();
    mockStudentRepo = MockStudentRepository();
    mockClassroomRepo = MockClassroomRepository();
    mockStorage = MockStorageService();

    when(() => mockStorage.getClassCode()).thenReturn('CLS-1234');
    when(() => mockClassroomRepo.getClassrooms())
        .thenAnswer((_) async => mockClassrooms);
    when(
      () => mockStudentRepo.getDashboardTasks(
        classroomId: any(named: 'classroomId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) async => mockTasks);
  });

  group('ExamController Tests', () {
    test('Initial onLoad fetches tasks from StudentRepository', () async {
      final controller = ExamController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.apiExams.length, equals(1));
      expect(controller.errorMessage.value, isEmpty);

      verify(
        () => mockStudentRepo.getDashboardTasks(
          classroomId: 10,
          status: StudentTaskStatus.soalUjian,
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

      controller.onChangeStatus(ModuleStatus.done);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.selectedStatus.value, equals(ModuleStatus.done));
      verify(
        () => mockStudentRepo.getDashboardTasks(
          classroomId: 10,
          status: StudentTaskStatus.soalUjian,
        ),
      ).called(2);
    });

    test('Handles ApiException gracefully and sets errorMessage', () async {
      when(
        () => mockStudentRepo.getDashboardTasks(
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
