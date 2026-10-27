import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/module_detail/controllers/module_detail_controller.dart';

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
      id: 1,
      teacherId: 1,
      schoolId: 1,
      name: 'Kelas 10',
      code: 'CLS-10',
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

  final mockDetail = StudentModuleDetailModel(
    id: 10,
    title: 'Modul Aljabar',
    createdAt: testNow,
    chapters: [
      StudentChapterSummaryModel(
        id: 101,
        title: 'Bab 1: Persamaan Linier',
        number: 1,
      ),
      StudentChapterSummaryModel(
        id: 102,
        title: 'Bab 2: Sistem Pertidaksamaan',
        number: 2,
      ),
    ],
  );

  final mockChapterDetail = StudentChapterDetailModel(
    id: 101,
    title: 'Bab 1: Persamaan Linier',
    number: 1,
    blocks: [
      BlockResponseModel(
        id: 1,
        readingOrder: 1,
        blockType: 'text',
        readableText: 'Pengenalan persamaan linier satu variabel.',
        reviewPriority: 'normal',
      ),
    ],
  );

  setUp(() {
    Get.reset();
    Get.testMode = true;
    Get.parameters = {};

    mockStudentRepo = MockStudentRepository();
    mockClassroomRepo = MockClassroomRepository();
    mockStorage = MockStorageService();

    when(() => mockStorage.getClassCode()).thenReturn('CLS-10');
    when(() => mockClassroomRepo.getClassrooms())
        .thenAnswer((_) async => mockClassrooms);
    when(
      () => mockStudentRepo.getModuleDetail(
        moduleId: any(named: 'moduleId'),
        classroomId: any(named: 'classroomId'),
      ),
    ).thenAnswer((_) async => mockDetail);
    when(
      () => mockStudentRepo.startChapter(
        chapterId: any(named: 'chapterId'),
      ),
    ).thenAnswer((_) async => mockChapterDetail);
  });

  group('ModuleDetailController Tests', () {
    test('onLoad fetches module detail and sets studentModule', () async {
      final controller = ModuleDetailController(
        moduleId: 10,
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.hasApiDetail, isTrue);
      expect(controller.studentModule.value?.id, equals(10));
      expect(controller.studentModule.value?.chapters.length, equals(2));
      expect(controller.startingChapterId.value, isNull);

      verify(
        () => mockStudentRepo.getModuleDetail(
          moduleId: 10,
          classroomId: 1,
        ),
      ).called(1);
    });

    test('onChapterStudent tracks startingChapterId during chapter start', () async {
      final controller = ModuleDetailController(
        moduleId: 10,
        studentRepository: mockStudentRepo,
        classroomRepository: mockClassroomRepo,
        storageService: mockStorage,
      );

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      final chapter = mockDetail.chapters.first;
      final future = controller.onChapterStudent(chapter, 0);

      // Verify that startingChapterId is set while loading
      expect(controller.startingChapterId.value, equals(101));

      await future;

      // Verify that startingChapterId resets to null after completion
      expect(controller.startingChapterId.value, isNull);

      verify(
        () => mockStudentRepo.startChapter(chapterId: 101),
      ).called(1);
    });
  });
}
