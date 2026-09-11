import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_dropdown_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/modules/auth/create_class/controllers/create_class_controller.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/create_class_view.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/widgets/chip_grade_widget.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockRepository;
  late CreateClassController controller;

  final testNow = DateTime.now();

  final mockTypes = [
    ClassroomTypeModel(
      id: 1,
      name: 'Matematika',
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  final mockCities = [
    CityResponseModel(
      id: 10,
      name: 'Jakarta Selatan',
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  setUp(() {
    Get.testMode = true;
    mockRepository = MockClassroomRepository();

    when(() => mockRepository.getClassroomTypes())
        .thenAnswer((_) async => mockTypes);
    when(() => mockRepository.getCities())
        .thenAnswer((_) async => mockCities);

    controller = CreateClassController(repository: mockRepository);
    Get.put<CreateClassController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('CreateClassView renders all dropdowns, chips, and fields properly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: CreateClassView(),
      ),
    );

    // Allow onInit async calls to finish and settle UI
    await tester.pumpAndSettle();

    // Verify Title & Subtitle
    expect(find.text('Buat Kelas Kamu'), findsOneWidget);
    expect(find.text('Isi informasi kelas untuk memulai'), findsOneWidget);

    // Verify Name of class field
    expect(find.byType(CommonTextFormFieldWidget), findsOneWidget);
    expect(find.text('Nama Kelas *'), findsOneWidget);

    // Verify Subject dropdown
    expect(find.text('Mata Pelajaran *'), findsOneWidget);
    expect(find.text('Pilih Mata Pelajaran'), findsOneWidget);

    // Verify Grade chips
    expect(find.text('Tingkat Kelas *'), findsOneWidget);
    expect(find.byType(ChipGradeWidget), findsNWidgets(3));
    expect(find.text('Kelas 10'), findsOneWidget);
    expect(find.text('Kelas 11'), findsOneWidget);
    expect(find.text('Kelas 12'), findsOneWidget);

    // Verify City dropdown
    expect(find.text('Nama Kota *'), findsOneWidget);
    expect(find.text('Pilih Kota'), findsOneWidget);

    // Verify School dropdown (should indicate to choose city first)
    expect(find.text('Nama Sekolah *'), findsOneWidget);
    expect(find.text('Pilih Kota terlebih dahulu'), findsOneWidget);

    // Verify Dropdowns exist
    expect(find.byType(CommonDropdownWidget<ClassroomTypeModel>), findsOneWidget);
    expect(find.byType(CommonDropdownWidget<CityResponseModel>), findsOneWidget);
    expect(find.byType(CommonDropdownWidget<SchoolResponseModel>), findsOneWidget);

    // Verify Submit button
    expect(find.byType(CommonButtonWidget), findsOneWidget);
    expect(find.text('Buat Kelas'), findsOneWidget);
  });
}
