import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/core/utils/module_status.dart';
import 'package:lydera_app/app/data/models/module_model.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/module_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/module/controllers/module_controller.dart';

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

  final mockStudentModules = [
    StudentModuleModel(
      id: 1,
      title: 'Eksponen dan Logaritma',
      faseId: 1,
      createdAt: testNow,
      progress: ModuleProgressModel(
        id: 101,
        studentId: 5,
        moduleId: 1,
        progressPercentage: 60,
        isDone: false,
      ),
    ),
  ];

  setUp(() {
    Get.testMode = true;
    mockStudentRepo = MockStudentRepository();
    mockClassroomRepo = MockClassroomRepository();
    mockStorage = MockStorageService();

    when(() => mockStorage.getClassCode()).thenReturn('CLS-1234');
    when(() => mockClassroomRepo.getClassrooms()).thenAnswer((_) async => mockClassrooms);
  });

  tearDown(() {
    Get.reset();
  });

  group('ModuleController Tests', () {
    test('Fetches student modules successfully from StudentRepository', () async {
      when(
        () => mockStudentRepo.getModules(
          classroomId: 10,
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => mockStudentModules);

      final controller = ModuleController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      // onInit triggers onLoad
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.studentModules.length, equals(1));
      expect(controller.studentModules.first.title, equals('Eksponen dan Logaritma'));
      expect(controller.hasApiModules, isTrue);
    });

    test('onChangeStatus updates filter and refetches from StudentRepository', () async {
      when(
        () => mockStudentRepo.getModules(
          classroomId: 10,
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async => mockStudentModules);

      final controller = ModuleController(
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
        () => mockStudentRepo.getModules(
          classroomId: 10,
          status: StudentModuleStatus.selesai,
        ),
      ).called(1);
    });

    test('Handles error on fetching student modules', () async {
      when(
        () => mockStudentRepo.getModules(
          classroomId: 10,
          status: any(named: 'status'),
        ),
      ).thenThrow(const ApiException(message: 'Gagal mengambil modul'));

      final controller = ModuleController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, equals('Gagal mengambil modul'));
    });
  });
}
