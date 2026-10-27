import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/views/teacher_dashboard_view.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockTeacherRepository extends Mock implements TeacherRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockClassroomRepo;
  late MockTeacherRepository mockTeacherRepo;
  late MockStorageService mockStorageService;
  late TeacherDashboardController controller;

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

  final mockDashboard = TeacherDashboardModel(
    teacherEmail: 'Budi Santoso',
    classroomInfo: ClassroomInfoModel(
      schoolName: 'SLBN A-Citeureup',
      code: 'NSG-4821',
      gradeClass: 10,
      classroomType: 'Matematika',
    ),
    totalModules: 8,
    totalExams: 3,
    totalStudents: 32,
    newestModules: [
      TeacherNewestModuleModel(
        id: 1,
        title: 'BAB 1 : Eksponen dan Logaritma',
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

    when(() => mockStorageService.getClassCode()).thenReturn('NSG-4821');
    when(() => mockStorageService.getClassName()).thenReturn('Kelas 10 MIPA 1');
    when(() => mockStorageService.getUserName()).thenReturn('Budi Santoso');
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
    Get.put<TeacherDashboardController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('TeacherDashboardView displays dynamic class code and greeting', (
    WidgetTester tester,
  ) async {
    await controller.fetchClassrooms();

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

    // Verify dynamic stats from TeacherDashboardModel
    expect(find.text('8'), findsOneWidget); // totalModules
    expect(find.text('3'), findsOneWidget); // totalExams
    expect(find.text('32'), findsOneWidget); // totalStudents

    // Verify module item title
    expect(find.text('BAB 1 : Eksponen dan Logaritma'), findsOneWidget);
  });
}
