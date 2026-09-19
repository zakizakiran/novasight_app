import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/data/repositories/module_teacher_repository.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/module_evaluation_view.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/show_modal_bottom_sheet_correction_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/show_modal_bottom_sheet_text_edit_widget.dart';

class MockModuleTeacherRepository extends Mock
    implements ModuleTeacherRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockModuleTeacherRepository mockRepo;

  const sampleModule = ModuleTeacherModel(
    id: 1,
    name: 'BAB 1 : Eksponen',
    type: ModuleTeacherType.pdf,
    status: ModuleTeacherStatus.draft,
    gradeType: ClassGradeType.classTen,
    listChunks: [
      TextChunk(
        id: 101,
        text: 'Ini teks materi bab',
        annotation: 'Ini penjelasan anotasi bab',
      ),
      ImageChunk(
        id: 102,
        imagePath: 'sample.png',
        annotation: 'Ini anotasi untuk gambar diagram',
      ),
    ],
  );

  setUp(() {
    Get.reset();
    mockRepo = MockModuleTeacherRepository();
    Get.parameters = {};
    Get.routing.args = sampleModule;
    Get.put(ModuleEvaluationController(repository: mockRepo));
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
      'ModuleEvaluationView handles text direct edit and image AI revision exclusively',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: ModuleEvaluationView(),
      ),
    );
    await tester.pump();

    // 1. Initial unselected state
    expect(find.text('Ubah Anotasi'), findsOneWidget);
    expect(find.text('Simpan ke Modul'), findsOneWidget);
    expect(
      find.textContaining(
        'Centang blok: Teks untuk edit langsung',
      ),
      findsOneWidget,
    );

    // 2. Select Block 1 (Text block)
    await tester.tap(find.text('Block 1'));
    await tester.pump();

    // Verify text mode active
    expect(find.textContaining('Mode Edit Teks Langsung'), findsOneWidget);
    expect(find.text('Edit Teks Anotasi'), findsOneWidget);

    // 3. Open text edit bottom sheet
    await tester.tap(find.text('Edit Teks Anotasi'));
    await tester.pumpAndSettle();

    expect(find.byType(ShowModalBottomSheetTextEditWidget), findsOneWidget);
    expect(find.text('Edit Anotasi Teks'), findsOneWidget);
    expect(find.text('Simpan Anotasi'), findsOneWidget);

    // Close text edit sheet
    Get.back();
    await tester.pumpAndSettle();

    // 4. Select Block 2 (Image block) -> switches automatically to image mode
    await tester.tap(find.text('Block 2'));
    await tester.pump();

    expect(find.textContaining('Mode Revisi AI (1 Blok Khusus)'), findsOneWidget);
    expect(find.text('Revisi (1) dengan AI'), findsOneWidget);

    // 5. Open AI revision bottom sheet
    await tester.tap(find.text('Revisi (1) dengan AI'));
    await tester.pumpAndSettle();

    expect(find.byType(ShowModalBottomSheetCorrectionWidget), findsOneWidget);
    expect(find.text('Block yang Dipilih (1):'), findsOneWidget);
  });
}
