import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockRepository;
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

  setUp(() {
    Get.testMode = true;
    mockRepository = MockClassroomRepository();
    mockStorageService = MockStorageService();

    when(() => mockStorageService.getClassCode()).thenReturn('CACHED-123');
    when(() => mockStorageService.getClassName()).thenReturn('Kelas 10 MIPA 1');
    when(() => mockStorageService.getUserName()).thenReturn('Ibu Guru');
    when(() => mockStorageService.writeClassCode(any()))
        .thenAnswer((_) async {});
    when(() => mockStorageService.writeClassName(any()))
        .thenAnswer((_) async {});

    when(() => mockRepository.getClassrooms())
        .thenAnswer((_) async => mockClassrooms);

    controller = TeacherDashboardController(
      classroomRepository: mockRepository,
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

    test('fetchClassrooms updates classCode from API and writes to storage', () async {
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.classrooms.length, equals(1));
      expect(controller.classCode.value, equals('NSG-4821'));
      expect(controller.classSubtitle.value, equals('Matematika - Kelas 10'));
      expect(controller.isLoadingClassroom.value, isFalse);

      verify(() => mockStorageService.writeClassCode('NSG-4821')).called(1);
    });

    test('fetchClassrooms preserves cached code if API fails', () async {
      when(() => mockRepository.getClassrooms())
          .thenThrow(const ApiException(message: 'Network error'));

      final fallbackController = TeacherDashboardController(
        classroomRepository: mockRepository,
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
