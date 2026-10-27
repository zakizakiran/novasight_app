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
import 'package:lydera_app/app/modules/module_teachers/module_teacher/controllers/module_teacher_controller.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockTeacherRepository extends Mock implements TeacherRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockClassroomRepo;
  late MockTeacherRepository mockTeacherRepo;
  late MockStorageService mockStorageService;
  late ModuleTeacherController controller;

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

  final mockModules = [
    TeacherModuleModel(
      id: 101,
      title: 'Modul Eksponen dan Logaritma',
      faseId: 1,
      createdAt: testNow,
      status: 'draft',
    ),
    TeacherModuleModel(
      id: 102,
      title: 'Modul Barisan dan Deret',
      faseId: 1,
      createdAt: testNow,
      status: 'publish',
    ),
  ];

  final mockModuleDetail = TeacherModuleDetailModel(
    id: 101,
    title: 'Modul Eksponen dan Logaritma',
    faseId: 1,
    createdAt: testNow,
    status: 'draft',
    chapters: [
      TeacherChapterSummaryModel(
        id: 201,
        moduleId: 101,
        number: 1,
        title: 'Konsep Dasar Eksponen',
        sourceFile: 'eksponen.pdf',
        cpId: 10,
        createdAt: testNow,
      ),
    ],
  );

  final mockChapterDetail = TeacherChapterDetailModel(
    id: 201,
    moduleId: 101,
    number: 1,
    title: 'Konsep Dasar Eksponen',
    sourceFile: 'eksponen.pdf',
    cpId: 10,
    createdAt: testNow,
    blocks: [
      BlockResponseModel(
        readingOrder: 1,
        blockType: 'paragraph',
        readableText: 'Eksponen adalah perkalian berulang suatu bilangan.',
        reviewPriority: 'low',
      ),
    ],
  );

  setUp(() {
    Get.testMode = true;
    mockClassroomRepo = MockClassroomRepository();
    mockTeacherRepo = MockTeacherRepository();
    mockStorageService = MockStorageService();

    when(() => mockStorageService.getClassCode()).thenReturn('NSG-4821');
    when(() => mockClassroomRepo.getClassrooms())
        .thenAnswer((_) async => mockClassrooms);

    when(() => mockTeacherRepo.getModules(
          classroomId: any(named: 'classroomId'),
          search: any(named: 'search'),
          status: any(named: 'status'),
        )).thenAnswer((_) async => mockModules);

    when(() => mockTeacherRepo.getModuleDetail(
          moduleId: any(named: 'moduleId'),
          classroomId: any(named: 'classroomId'),
        )).thenAnswer((_) async => mockModuleDetail);

    when(() => mockTeacherRepo.getChapterDetail(
          chapterId: any(named: 'chapterId'),
        )).thenAnswer((_) async => mockChapterDetail);

    when(() => mockTeacherRepo.publishModule(any()))
        .thenAnswer((_) async => true);

    when(() => mockTeacherRepo.deleteModule(
          moduleId: any(named: 'moduleId'),
          classroomId: any(named: 'classroomId'),
        )).thenAnswer((_) async => true);

    controller = ModuleTeacherController(
      classroomRepository: mockClassroomRepo,
      teacherRepository: mockTeacherRepo,
      storageService: mockStorageService,
    );
  });

  tearDown(() {
    Get.reset();
  });

  group('ModuleTeacherController Tests', () {
    test('onLoad fetches modules successfully for active classroom', () async {
      await controller.onLoad();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.teacherModules.length, equals(2));
      expect(
        controller.teacherModules.first.title,
        equals('Modul Eksponen dan Logaritma'),
      );
      expect(controller.teacherModules.first.status, equals('draft'));

      verify(() => mockTeacherRepo.getModules(
            classroomId: 1,
            search: null,
            status: TeacherModuleStatus.semua,
          )).called(1);
    });

    test('onLoad sets errorMessage on ApiException', () async {
      when(() => mockTeacherRepo.getModules(
            classroomId: any(named: 'classroomId'),
            search: any(named: 'search'),
            status: any(named: 'status'),
          )).thenThrow(const ApiException(message: 'Gagal mengambil modul guru'));

      await controller.onLoad();

      expect(controller.isLoading.value, isFalse);
      expect(
        controller.errorMessage.value,
        equals('Gagal mengambil modul guru'),
      );
    });

    test('onSelectedStatus updates selectedStatus and fetches modules', () async {
      controller.onSelectedStatus(TeacherModuleStatus.draft);
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.selectedStatus.value, equals(TeacherModuleStatus.draft));
      verify(() => mockTeacherRepo.getModules(
            classroomId: 1,
            search: null,
            status: TeacherModuleStatus.draft,
          )).called(1);
    });

    test('onChange updates searchQuery', () {
      controller.onChange('Eksponen');
      expect(controller.searchQuery.value, equals('Eksponen'));
    });

    test('onPublishModule publishes module and updates status to publish', () async {
      await controller.onLoad();
      final target = controller.teacherModules.first;
      expect(target.status, equals('draft'));

      await controller.onPublishModule(target);

      verify(() => mockTeacherRepo.publishModule(101)).called(1);
      final updated = controller.teacherModules.firstWhere((m) => m.id == 101);
      expect(updated.status, equals('publish'));
      expect(controller.isPublishing.value, isFalse);
    });

    test('onPublishModule does not publish already published module', () async {
      await controller.onLoad();
      final publishedModule = controller.teacherModules[1];
      expect(publishedModule.status, equals('publish'));

      await controller.onPublishModule(publishedModule);

      verifyNever(() => mockTeacherRepo.publishModule(any()));
    });

    test('fetchModuleDetail returns detail and updates selectedModuleDetail', () async {
      final detail = await controller.fetchModuleDetail(101);

      expect(detail, isNotNull);
      expect(detail?.id, equals(101));
      expect(detail?.chapters.length, equals(1));
      expect(detail?.chapters.first.title, equals('Konsep Dasar Eksponen'));
      expect(controller.selectedModuleDetail.value, equals(detail));
      expect(controller.isLoadingDetail.value, isFalse);

      verify(() => mockTeacherRepo.getModuleDetail(
            moduleId: 101,
            classroomId: 1,
          )).called(1);
    });

    test('fetchChapterDetail returns chapter detail with content blocks', () async {
      final chapter = await controller.fetchChapterDetail(201);

      expect(chapter, isNotNull);
      expect(chapter?.id, equals(201));
      expect(chapter?.blocks.length, equals(1));
      expect(
        chapter?.blocks.first.readableText,
        contains('Eksponen adalah perkalian berulang'),
      );
      expect(controller.selectedChapterDetail.value, equals(chapter));
      expect(controller.isLoadingChapter.value, isFalse);

      verify(() => mockTeacherRepo.getChapterDetail(chapterId: 201)).called(1);
    });

    test('fetchModuleDetail handles error gracefully', () async {
      when(() => mockTeacherRepo.getModuleDetail(
            moduleId: any(named: 'moduleId'),
            classroomId: any(named: 'classroomId'),
          )).thenThrow(const ApiException(message: 'Modul tidak ditemukan'));

      final detail = await controller.fetchModuleDetail(999);

      expect(detail, isNull);
      expect(controller.isLoadingDetail.value, isFalse);
    });

    test('onDeleteModule deletes module and reloads', () async {
      await controller.onLoad();
      final target = controller.teacherModules.first;

      await controller.onDeleteModule(target);

      verify(() => mockTeacherRepo.deleteModule(
            moduleId: 101,
            classroomId: 1,
          )).called(1);
      expect(controller.isDeleting.value, isFalse);
    });
  });
}
