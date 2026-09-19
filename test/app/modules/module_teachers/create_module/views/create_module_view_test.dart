import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/data/models/fase_model.dart';
import 'package:novasight_app/app/data/repositories/teacher_repository.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/controllers/create_module_controller.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/views/create_module_view.dart';

class MockTeacherRepository extends Mock implements TeacherRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTeacherRepository mockTeacherRepo;
  late CreateModuleController controller;

  final mockFases = [
    FaseModel(id: 1, kode: 'A'),
    FaseModel(id: 2, kode: 'E'),
  ];

  setUp(() {
    mockTeacherRepo = MockTeacherRepository();
    when(() => mockTeacherRepo.getFases()).thenAnswer((_) async => mockFases);
    controller = CreateModuleController(teacherRepository: mockTeacherRepo);
    Get.put<CreateModuleController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('CreateModuleView renders Fase dropdown title and placeholder', (tester) async {
    controller.listFase.assignAll(mockFases);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CreateModuleView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fase'), findsOneWidget);
    expect(find.text('Pilih Fase'), findsOneWidget);
    expect(find.text('Simpan Modul'), findsOneWidget);
  });

  testWidgets('CreateModuleView renders Step 2 chapter configuration when currentStep is potongChapter', (tester) async {
    controller.listFase.assignAll(mockFases);
    controller.currentStep.value = CreateModuleStep.potongChapter;
    controller.totalPages.value = 50;

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CreateModuleView(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Konfigurasi Pemotongan BAB'), findsOneWidget);
    expect(find.text('BAB Ke-'), findsOneWidget);
    expect(find.text('Judul BAB *'), findsOneWidget);
    expect(find.text('Halaman Awal *'), findsOneWidget);
    expect(find.text('Halaman Akhir *'), findsOneWidget);
    expect(find.text('Proses & Buat Chapter'), findsOneWidget);
    expect(find.text('Kembali'), findsOneWidget);
    expect(find.text('Selesai'), findsOneWidget);
  });

  testWidgets('CreateModuleView hides "Perlu Ditinjau" badge and displays inline loader when chapter is opening', (tester) async {
    controller.listFase.assignAll(mockFases);
    controller.currentStep.value = CreateModuleStep.potongChapter;
    controller.totalPages.value = 50;

    final job = TrackedChapterJob(
      chapterId: 101,
      jobId: 202,
      chapterNumber: 1,
      title: 'BAB 1 Eksponen',
      startPage: 1,
      endPage: 20,
      initialProgress: 100.0,
      initialStatus: 'done',
      isReviewed: false,
    );
    controller.trackedJobs.assignAll([job]);

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CreateModuleView(),
      ),
    );
    await tester.pumpAndSettle();

    // Initially, badge "Perlu Ditinjau" is shown
    expect(find.text('Perlu Ditinjau'), findsOneWidget);

    // When chapter is opening
    controller.openingJobId.value = 202;
    controller.isOpeningChapter.value = true;
    await tester.pump();

    // Badge "Perlu Ditinjau" should now be hidden to prevent crowded layout
    expect(find.text('Perlu Ditinjau'), findsNothing);
    // Single inline CircularProgressIndicator should be visible
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // When opening completes
    controller.openingJobId.value = null;
    controller.isOpeningChapter.value = false;
    await tester.pump();

    // Badge should be restored
    expect(find.text('Perlu Ditinjau'), findsOneWidget);
  });
}
