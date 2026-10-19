import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/chunk_card_widget.dart';

class MockModuleTeacherRepository extends Mock {}


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockModuleTeacherRepository mockRepo;
  late ModuleEvaluationController controller;

  const testModule = ModuleTeacherModel(
    id: 1,
    name: 'BAB 1 : Test Modul',
    type: ModuleTeacherType.pdf,
    status: ModuleTeacherStatus.draft,
    gradeType: ClassGradeType.classTen,
    listChunks: [],
  );

  setUp(() {
    Get.reset();
    mockRepo = MockModuleTeacherRepository();
    Get.parameters = {};
    // Set arguments before putting controllers
    Get.replace<dynamic>(testModule);
    // Actually Get.arguments is passed via route, in test we set directly:
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildTestableWidget(Widget child) {
    return GetMaterialApp(
      initialRoute: '/evaluation',
      getPages: [
        GetPage(
          name: '/evaluation',
          page: () => Scaffold(body: child),
        ),
      ],
    );
  }

  testWidgets('ChunkCardWidget renders TextChunk properly',
      (WidgetTester tester) async {
    Get.routing.args = testModule;
    controller = Get.put(ModuleEvaluationController());

    const textChunk = TextChunk(
      id: 1,
      text: 'Teks asal dari materi modul',
      annotation: 'Anotasi penjelasan untuk siswa',
    );

    await tester.pumpWidget(buildTestableWidget(
      const ChunkCardWidget(chunk: textChunk),
    ));
    await tester.pump();

    expect(find.text('Teks asal dari materi modul'), findsOneWidget);
    expect(find.text('Anotasi penjelasan untuk siswa'), findsOneWidget);
  });

  testWidgets(
      'ChunkCardWidget handles ImageChunk with backend filename without crashing',
      (WidgetTester tester) async {
    Get.routing.args = testModule;
    controller = Get.put(ModuleEvaluationController());

    const imageChunk = ImageChunk(
      id: 2,
      imagePath: 'ae0e9218233dd50bdef2eeee2f80891f91b4af94eb73d8eacac7d59bb9aa2817.jpg',
      annotation: 'Anotasi visual untuk gambar diagram',
    );

    await tester.pumpWidget(buildTestableWidget(
      const ChunkCardWidget(chunk: imageChunk),
    ));
    await tester.pump();

    // Verify it didn't throw an assertion or crash
    expect(find.byType(ChunkCardWidget), findsOneWidget);
    expect(find.text('Anotasi visual untuk gambar diagram'), findsOneWidget);
  });

  testWidgets(
      'ChunkCardWidget renders ImageChunk with extracted PDF imageBytes properly',
      (WidgetTester tester) async {
    Get.routing.args = testModule;
    controller = Get.put(ModuleEvaluationController());

    // Transparent 1x1 PNG bytes
    final dummyBytes = Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
      0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
      0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
      0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
      0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
      0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
    ]);

    final imageChunkWithBytes = ImageChunk(
      id: 3,
      imagePath: 'extracted_from_pdf.png',
      imageBytes: dummyBytes,
      page: 1,
      annotation: 'Anotasi gambar dari PDF',
    );

    await tester.pumpWidget(buildTestableWidget(
      ChunkCardWidget(chunk: imageChunkWithBytes),
    ));
    await tester.pump();

    expect(find.byType(ChunkCardWidget), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Anotasi gambar dari PDF'), findsOneWidget);
  });

  testWidgets(
      'ChunkCardWidget renders ImageChunk with network imageUrl properly',
      (WidgetTester tester) async {
    Get.routing.args = testModule;
    controller = Get.put(ModuleEvaluationController());

    const networkImageChunk = ImageChunk(
      id: 4,
      imagePath: 'http://72.61.215.214:8003/static/images/diagram.png',
      annotation: 'Anotasi visual gambar dari network URL',
    );

    await tester.pumpWidget(buildTestableWidget(
      const ChunkCardWidget(chunk: networkImageChunk),
    ));
    await tester.pump();

    expect(find.byType(ChunkCardWidget), findsOneWidget);
    expect(find.text('Anotasi visual gambar dari network URL'), findsOneWidget);
  });

  testWidgets(
      'ChunkCardWidget displays block number, type badge, and Block Dipilih when selected',
      (WidgetTester tester) async {
    Get.routing.args = testModule;
    controller = Get.put(ModuleEvaluationController());

    const textChunk = TextChunk(
      id: 5,
      text: 'Sample text chunk',
      annotation: 'Sample annotation',
    );

    await tester.pumpWidget(buildTestableWidget(
      const ChunkCardWidget(chunk: textChunk, blockNumber: 1),
    ));
    await tester.pump();

    // Verify initial unselected state
    expect(find.text('Block 1'), findsOneWidget);
    expect(find.text('Teks'), findsOneWidget);
    expect(find.text('Pilih untuk edit teks'), findsOneWidget);
    expect(find.text('Edit Langsung'), findsNothing);

    // Tap to select
    await tester.tap(find.text('Block 1'));
    await tester.pump();

    // Verify selected state
    expect(find.text('Edit Langsung'), findsOneWidget);
    expect(controller.selectedChunks.contains(textChunk), isTrue);
  });
}
