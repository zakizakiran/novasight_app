import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/controllers/module_teacher_controller.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/module_teacher_view.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_card_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_filter_status_widget.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockTeacherRepository extends Mock implements TeacherRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockClassroomRepo;
  late MockTeacherRepository mockTeacherRepo;
  late MockStorageService mockStorageService;
  late ModuleTeacherController controller;

  final testNow = DateTime.parse('2026-06-07T00:00:00.000Z');

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

    when(() => mockTeacherRepo.publishModule(any()))
        .thenAnswer((_) async => true);

    controller = ModuleTeacherController(
      classroomRepository: mockClassroomRepo,
      teacherRepository: mockTeacherRepo,
      storageService: mockStorageService,
    );
    Get.put<ModuleTeacherController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildTestableWidget() {
    return const GetMaterialApp(
      home: ModuleTeacherView(),
    );
  }

  group('ModuleTeacherView Widget Tests', () {
    testWidgets('Renders appbar, search bar, and filter chips',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Modul'), findsOneWidget);
      expect(find.text('+ Unggah Modul'), findsOneWidget);
      expect(find.text('Cari modul...'), findsOneWidget);
      expect(find.widgetWithText(ModuleFilterStatusWidget, 'Semua'), findsOneWidget);
      expect(find.widgetWithText(ModuleFilterStatusWidget, 'Draft'), findsOneWidget);
      expect(find.widgetWithText(ModuleFilterStatusWidget, 'Publish'), findsOneWidget);
    });

    testWidgets('Renders module cards with title and action buttons',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ModuleTeacherCardWidget), findsNWidgets(2));
      expect(find.text('Modul Eksponen dan Logaritma'), findsOneWidget);
      expect(find.text('Modul Barisan dan Deret'), findsOneWidget);

      expect(find.text('Lihat Modul'), findsNWidgets(2));
      expect(find.text('Publish Modul'), findsOneWidget);
      expect(find.text('Terpublikasi'), findsOneWidget);
    });

    testWidgets('Tapping filter chip triggers controllers reload',
        (tester) async {
      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      final draftFilter = find.widgetWithText(ModuleFilterStatusWidget, 'Draft');
      expect(draftFilter, findsOneWidget);

      await tester.tap(draftFilter);
      await tester.pumpAndSettle();

      expect(controller.selectedStatus.value, equals(TeacherModuleStatus.draft));
    });

    testWidgets('Renders empty state when module list is empty',
        (tester) async {
      when(() => mockTeacherRepo.getModules(
            classroomId: any(named: 'classroomId'),
            search: any(named: 'search'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => []);

      final emptyController = ModuleTeacherController(
        classroomRepository: mockClassroomRepo,
        teacherRepository: mockTeacherRepo,
        storageService: mockStorageService,
      );
      Get.replace<ModuleTeacherController>(emptyController);

      await tester.pumpWidget(buildTestableWidget());
      await tester.pumpAndSettle();

      expect(find.text('Belum ada modul untuk kelas ini'), findsOneWidget);
      expect(find.byType(ModuleTeacherCardWidget), findsNothing);
    });
  });
}
