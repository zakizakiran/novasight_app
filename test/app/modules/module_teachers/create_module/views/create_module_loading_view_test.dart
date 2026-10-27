import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/controllers/create_module_controller.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/views/create_module_loading_view.dart';

class MockTeacherRepository extends Mock implements TeacherRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTeacherRepository mockTeacherRepo;
  late CreateModuleController controller;

  setUp(() {
    Get.testMode = true;
    mockTeacherRepo = MockTeacherRepository();
    when(() => mockTeacherRepo.getFases()).thenAnswer((_) async => []);
    controller = CreateModuleController(teacherRepository: mockTeacherRepo);
    Get.put<CreateModuleController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('CreateModuleLoadingView renders AppBar title, header, and step items', (tester) async {
    controller.progress.value = 0.65;
    controller.updateLoadingSteps(65.0);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CreateModuleLoadingView(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Memproses Modul'), findsOneWidget);
    expect(find.text('AI Sedang Memproses Modul'), findsOneWidget);
    expect(find.text('65%'), findsOneWidget);
    expect(find.text('Membaca dokumen'), findsOneWidget);
    expect(find.text('Menganalisis konten'), findsOneWidget);
    expect(find.text('Membuat anotasi'), findsOneWidget);
  });
}
