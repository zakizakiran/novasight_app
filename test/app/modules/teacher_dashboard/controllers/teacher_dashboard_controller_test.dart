import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockTeacherRepository extends Mock implements TeacherRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockClassroomRepo;
  late MockTeacherRepository mockTeacherRepo;
  late MockStorageService mockStorageService;
  late TeacherDashboardController controller;

  final testNow = DateTime.now();

  final mockClassrooms = [
    ClassroomResponseModel(
      id: 1,
      teacherId: 10,
      schoolId: 100,
      name: 'Kelas 10 MIPA 1',
      code: 'NSG-4821',
      grade: 10,
      classroomType: ClassroomTypeModel(
        id: 1,
        name: 'Matematika',
        createdAt: testNow,
        updatedAt: testNow,
      ),
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  final mockDashboard = TeacherDashboardModel(
    teacherEmail: 'guru@example.com',
    classroomInfo: ClassroomInfoModel(
      schoolName: 'SLBN A-Citeureup',
      code: 'NSG-4821',
      gradeClass: 10,
      classroomType: 'Matematika',
    ),
    totalModules: 3,
    totalExams: 1,
    totalStudents: 30,
    newestModules: [
      TeacherNewestModuleModel(
        id: 1,
        title: 'Modul Eksponen',
        faseId: 1,
        createdAt: testNow,
      ),
    ],
    newestExams: [],
  );

  setUp(() {
    Get.testMode = true;
    mockClassroomRepo = MockClassroomRepository();
    mockTeacherRepo = MockTeacherRepository();
    mockStorageService = MockStorageService();

    when(() => mockStorageService.getClassCode()).thenReturn('CACHED-123');
    when(() => mockStorageService.getClassName()).thenReturn('Kelas 10 MIPA 1');
    when(() => mockStorageService.getUserName()).thenReturn('Ibu Guru');
    when(() => mockStorageService.writeClassCode(any()))
        .thenAnswer((_) async {});
    when(() => mockStorageService.writeClassName(any()))
        .thenAnswer((_) async {});

    when(() => mockClassroomRepo.getClassrooms())
        .thenAnswer((_) async => mockClassrooms);

    when(() => mockTeacherRepo.getDashboard(
          classroomId: any(named: 'classroomId'),
          limit: any(named: 'limit'),
        )).thenAnswer((_) async => mockDashboard);

    controller = TeacherDashboardController(
      classroomRepository: mockClassroomRepo,
      teacherRepository: mockTeacherRepo,
      storageService: mockStorageService,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('TeacherDashboardController Tests', () {
    test('Initializes cache from StorageService properly', () {
      controller.onInit();
      expect(controller.classCode.value, equals('CACHED-123'));
      expect(controller.className.value, equals('Kelas 10 MIPA 1'));
      expect(controller.teacherName.value, equals('Ibu Guru'));
    });

    test('fetchClassrooms updates classCode from API and fetches dashboard', () async {
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.classrooms.length, equals(1));
      expect(controller.classCode.value, equals('NSG-4821'));
      expect(controller.classSubtitle.value, equals('Matematika - Kelas 10'));
      expect(controller.isLoadingClassroom.value, isFalse);

      verify(() => mockStorageService.writeClassCode('NSG-4821')).called(1);
      verify(() => mockTeacherRepo.getDashboard(classroomId: 1)).called(1);

      expect(controller.dashboardData.value, isNotNull);
      expect(controller.dashboardData.value?.totalModules, equals(3));
      expect(controller.dashboardData.value?.totalExams, equals(1));
      expect(controller.dashboardData.value?.totalStudents, equals(30));
    });

    test('fetchDashboard sets dashboardErrorMessage on ApiException', () async {
      when(() => mockTeacherRepo.getDashboard(
            classroomId: any(named: 'classroomId'),
            limit: any(named: 'limit'),
          )).thenThrow(const ApiException(message: 'Gagal memuat dashboard guru'));

      final errorController = TeacherDashboardController(
        classroomRepository: mockClassroomRepo,
        teacherRepository: mockTeacherRepo,
        storageService: mockStorageService,
      );

      errorController.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(errorController.isLoadingDashboard.value, isFalse);
      expect(
        errorController.dashboardErrorMessage.value,
        equals('Gagal memuat dashboard guru'),
      );
    });

    test('fetchClassrooms preserves cached code if API fails', () async {
      when(() => mockClassroomRepo.getClassrooms())
          .thenThrow(const ApiException(message: 'Network error'));

      final fallbackController = TeacherDashboardController(
        classroomRepository: mockClassroomRepo,
        teacherRepository: mockTeacherRepo,
        storageService: mockStorageService,
      );

      fallbackController.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(fallbackController.classCode.value, equals('CACHED-123'));
      expect(fallbackController.isLoadingClassroom.value, isFalse);
    });

    test('onCopyClassCode copies code when present', () async {
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      await controller.onCopyClassCode();
      expect(controller.classCode.value, equals('NSG-4821'));
    });
  });
}
