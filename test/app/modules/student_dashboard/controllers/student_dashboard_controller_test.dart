import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/student-dashboard/controllers/student_dashboard_controller.dart';

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

  final mockDashboard = StudentDashboardModel(
    studentEmail: 'ahmad@example.com',
    classroomInfo: ClassroomInfoModel(
      schoolName: 'SLBN A-Citeureup',
      code: 'CLS-1234',
      gradeClass: 10,
      classroomType: 'Tunanetra',
    ),
    modulesNotDone: 2,
    examNotDone: 1,
  );

  final mockTasks = StudentTaskModel(
    modules: [
      StudentModuleModel(
        id: 1,
        title: 'Eksponen',
        faseId: 1,
        createdAt: testNow,
        progress: ModuleProgressModel(
          id: 1,
          studentId: 5,
          moduleId: 1,
          progressPercentage: 80,
          isDone: false,
        ),
      ),
    ],
    exams: [],
  );

  setUp(() {
    Get.testMode = true;
    mockStudentRepo = MockStudentRepository();
    mockClassroomRepo = MockClassroomRepository();
    mockStorage = MockStorageService();

    when(() => mockStorage.getUserName()).thenReturn('Ahmad');
    when(() => mockStorage.getUserEmail()).thenReturn('ahmad@example.com');
    when(() => mockStorage.getClassName()).thenReturn('Tunanetra • Kelas 10');
    when(() => mockStorage.getClassCode()).thenReturn('CLS-1234');
    when(() => mockStorage.writeClassCode(any())).thenAnswer((_) async {});
    when(() => mockStorage.writeClassName(any())).thenAnswer((_) async {});
  });

  tearDown(() {
    Get.reset();
  });

  group('StudentDashboardController Tests', () {
    test('Initializes cached state and fetches data successfully', () async {
      when(() => mockClassroomRepo.getClassrooms()).thenAnswer(
        (_) async => mockClassrooms,
      );
      when(() => mockStudentRepo.getDashboard(classroomId: 10)).thenAnswer(
        (_) async => mockDashboard,
      );
      when(
        () => mockStudentRepo.getDashboardTasks(
          classroomId: 10,
          status: any(named: 'status'),
        ),
      ).thenAnswer(
        (_) async => mockTasks,
      );

      final controller = StudentDashboardController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();

      // Verify cached load immediately
      expect(controller.studentName.value, equals('Ahmad'));

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.activeClassroomId.value, equals(10));
      expect(controller.dashboardData.value?.modulesNotDone, equals(2));
      expect(controller.taskModules.length, equals(1));
      expect(controller.taskModules.first.title, equals('Eksponen'));
    });

    test('Handles empty classrooms scenario', () async {
      when(() => mockClassroomRepo.getClassrooms()).thenAnswer(
        (_) async => [],
      );

      final controller = StudentDashboardController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(
        controller.errorMessage.value,
        equals('Anda belum terdaftar di kelas manapun.'),
      );
      expect(controller.dashboardData.value, isNull);
    });

    test('Handles error on fetching classroom list', () async {
      when(() => mockClassroomRepo.getClassrooms()).thenThrow(
        const ApiException(message: 'Gagal memuat kelas'),
      );

      final controller = StudentDashboardController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, equals('Gagal memuat kelas'));
    });

    test('onFilterChanged switches filter and refetches tasks', () async {
      when(() => mockClassroomRepo.getClassrooms()).thenAnswer(
        (_) async => mockClassrooms,
      );
      when(() => mockStudentRepo.getDashboard(classroomId: 10)).thenAnswer(
        (_) async => mockDashboard,
      );
      when(
        () => mockStudentRepo.getDashboardTasks(
          classroomId: 10,
          status: any(named: 'status'),
        ),
      ).thenAnswer(
        (_) async => mockTasks,
      );

      final controller = StudentDashboardController(
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.selectedFilter.value, equals(StudentTaskStatus.semua));

      // Switch to 'Materi'
      await controller.onFilterChanged(StudentTaskStatus.materi);

      expect(controller.selectedFilter.value, equals(StudentTaskStatus.materi));
      verify(
        () => mockStudentRepo.getDashboardTasks(
          classroomId: 10,
          status: StudentTaskStatus.materi,
        ),
      ).called(1);
    });
  });
}
