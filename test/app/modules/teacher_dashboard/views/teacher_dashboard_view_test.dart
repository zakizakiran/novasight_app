import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';
import 'package:novasight_app/app/modules/teacher-dashboard/views/teacher_dashboard_view.dart';

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

    when(() => mockStorageService.getClassCode()).thenReturn('NSG-4821');
    when(() => mockStorageService.getClassName()).thenReturn('Kelas 10 MIPA 1');
    when(() => mockStorageService.getUserName()).thenReturn('Budi Santoso');
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
    Get.put<TeacherDashboardController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('TeacherDashboardView displays dynamic class code and greeting', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: TeacherDashboardView(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify Teacher name in greeting
    expect(find.text('Budi Santoso'), findsOneWidget);

    // Verify Class subtitle
    expect(find.text('Matematika - Kelas 10'), findsOneWidget);

    // Verify Class code title and dynamic code
    expect(find.text('Kode Kelas'), findsOneWidget);
    expect(find.text('NSG-4821'), findsOneWidget);

    // Verify Copy button
    expect(find.text('Salin Kode Kelas'), findsOneWidget);
  });
}
