import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/data/model/selected_pdf_model.dart';
import 'package:lydera_app/app/data/models/chapter_create_response_model.dart';
import 'package:lydera_app/app/data/models/fase_model.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/controllers/create_module_controller.dart';

class MockTeacherRepository extends Mock implements TeacherRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockTeacherRepository mockTeacherRepo;
  late CreateModuleController controller;

  final mockFases = [
    FaseModel(id: 1, kode: 'A'),
    FaseModel(id: 2, kode: 'B'),
    FaseModel(id: 5, kode: 'E'),
  ];

  // Helper to generate a dummy 5-page PDF for test
  Uint8List generateTestPdf(int pageCount) {
    final doc = PdfDocument();
    for (int i = 0; i < pageCount; i++) {
      final page = doc.pages.add();
      page.graphics.drawString(
        'Test Page ${i + 1}',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
      );
    }
    final bytes = doc.saveSync();
    doc.dispose();
    return Uint8List.fromList(bytes);
  }

  setUp(() {
    Get.testMode = true;
    mockTeacherRepo = MockTeacherRepository();
    when(() => mockTeacherRepo.getFases()).thenAnswer((_) async => mockFases);
    controller = CreateModuleController(teacherRepository: mockTeacherRepo);
  });

  tearDown(() {
    Get.reset();
  });

  group('CreateModuleController Tests', () {
    test('onInit fetches fases from TeacherRepository successfully', () async {
      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.listFase.length, equals(3));
      expect(controller.listFase.first.kode, equals('A'));
      expect(controller.listFase.first.displayName, equals('Fase A'));
      expect(controller.isLoadingFase.value, isFalse);
    });

    test('fetchFases falls back to defaultFases when API throws ApiException', () async {
      when(() => mockTeacherRepo.getFases())
          .thenThrow(const ApiException(message: 'Network error'));

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.listFase.length, equals(FaseModel.defaultFases.length));
      expect(controller.listFase.first.kode, equals('A'));
      expect(controller.isLoadingFase.value, isFalse);
    });

    test('onSelectFase updates selectedFase and triggers validation', () {
      final selected = mockFases[2]; // Fase E
      controller.onSelectFase(selected);

      expect(controller.selectedFase.value, equals(selected));
      expect(controller.selectedFase.value?.displayName, equals('Fase E'));
    });

    test('onSaveModule creates module and transitions to potongChapter step', () async {
      final createdModule = TeacherNewestModuleModel(
        id: 42,
        title: 'Matematika Aljabar',
        faseId: 5,
        createdAt: DateTime.now(),
      );

      when(() => mockTeacherRepo.createModule(
            title: any(named: 'title'),
            description: any(named: 'description'),
            faseId: any(named: 'faseId'),
            classroomId: any(named: 'classroomId'),
            status: any(named: 'status'),
          )).thenAnswer((_) async => createdModule);

      controller.titleModuleController.text = 'Matematika Aljabar';
      controller.descriptionModuleController.text = 'Deskripsi Modul';
      controller.selectedFase.value = mockFases[2];
      controller.selectedPdf.value = SelectedPdfModel(
        name: 'test.pdf',
        bytes: generateTestPdf(3),
        size: 1000,
      );
      controller.isValid.value = true;

      await controller.onSaveModule();

      expect(controller.savedModule.value?.id, equals(42));
      expect(controller.currentStep.value, equals(CreateModuleStep.potongChapter));
      expect(controller.chapterTitleController.text, contains('BAB 1 : Matematika Aljabar'));
    });

    test('slicePdfPages correctly extracts specified page range', () {
      final originalPdf = generateTestPdf(10);
      final sliced = controller.slicePdfPages(
        originalBytes: originalPdf,
        startPage: 2,
        endPage: 5,
      );

      final doc = PdfDocument(inputBytes: sliced);
      expect(doc.pages.count, equals(4)); // pages 2, 3, 4, 5
      doc.dispose();
    });

    test('onCreateChapter slices PDF and calls TeacherRepository.createChapter', () async {
      controller.savedModule.value = TeacherNewestModuleModel(
        id: 42,
        title: 'Matematika Aljabar',
        faseId: 5,
        createdAt: DateTime.now(),
      );
      final pdfBytes = generateTestPdf(10);
      controller.selectedPdf.value = SelectedPdfModel(
        name: 'full_module.pdf',
        bytes: pdfBytes,
        size: pdfBytes.length,
      );
      controller.totalPages.value = 10;

      controller.chapterNumberController.text = '1';
      controller.chapterTitleController.text = 'BAB I : Eksponen';
      controller.startPageController.text = '1';
      controller.endPageController.text = '4';

      final mockChapterResponse = ChapterCreateResponseModel(
        chapterId: 101,
        jobId: 202,
        status: 'running',
      );

      when(() => mockTeacherRepo.createChapter(
            fileBytes: any(named: 'fileBytes'),
            fileName: any(named: 'fileName'),
            moduleId: 42,
            title: 'BAB I : Eksponen',
            cpId: any(named: 'cpId'),
            number: 1,
          )).thenAnswer((_) async => mockChapterResponse);

      when(() => mockTeacherRepo.streamChapterJob(any()))
          .thenAnswer((_) => const Stream.empty());

      await controller.onCreateChapter();

      expect(controller.createdChapters.length, equals(1));
      expect(controller.createdChapters.first.chapterId, equals(101));
      expect(controller.createdChapters.first.jobId, equals(202));
      expect(controller.trackedJobs.length, equals(1));
      expect(controller.trackedJobs.first.chapterId, equals(101));
      expect(controller.trackedJobs.first.jobId, equals(202));
      expect(controller.chapterNumberController.text, equals('2'));
      expect(controller.startPageController.text, equals('5'));
    });

    test('updateLoadingSteps updates step checklist based on progress percentage', () {
      controller.updateLoadingSteps(20.0);
      expect(controller.uploadSteps[0].status.value, equals(LoadingStepStatus.processing));
      expect(controller.uploadSteps[1].status.value, equals(LoadingStepStatus.pending));
      expect(controller.uploadSteps[2].status.value, equals(LoadingStepStatus.pending));

      controller.updateLoadingSteps(55.0);
      expect(controller.uploadSteps[0].status.value, equals(LoadingStepStatus.completed));
      expect(controller.uploadSteps[1].status.value, equals(LoadingStepStatus.processing));
      expect(controller.uploadSteps[2].status.value, equals(LoadingStepStatus.pending));

      controller.updateLoadingSteps(85.0);
      expect(controller.uploadSteps[0].status.value, equals(LoadingStepStatus.completed));
      expect(controller.uploadSteps[1].status.value, equals(LoadingStepStatus.completed));
      expect(controller.uploadSteps[2].status.value, equals(LoadingStepStatus.processing));

      controller.updateLoadingSteps(100.0);
      expect(controller.uploadSteps[0].status.value, equals(LoadingStepStatus.completed));
      expect(controller.uploadSteps[1].status.value, equals(LoadingStepStatus.completed));
      expect(controller.uploadSteps[2].status.value, equals(LoadingStepStatus.completed));
    });

    test('onTapChapterItem sets activeInspectedJob and updates progress when running', () {
      final job = TrackedChapterJob(
        chapterId: 10,
        jobId: 20,
        chapterNumber: 1,
        title: 'BAB 1',
        startPage: 1,
        endPage: 10,
        initialProgress: 45.0,
        initialStatus: 'running',
      );

      controller.onTapChapterItem(job);

      expect(controller.activeInspectedJob.value, equals(job));
      expect(controller.progress.value, closeTo(0.45, 0.01));
      expect(controller.uploadSteps[0].status.value, equals(LoadingStepStatus.completed));
      expect(controller.uploadSteps[1].status.value, equals(LoadingStepStatus.processing));
    });

    test('canFinishModule requires all chapters done and reviewed', () {
      final job1 = TrackedChapterJob(
        chapterId: 10,
        jobId: 20,
        chapterNumber: 1,
        title: 'BAB 1',
        startPage: 1,
        endPage: 5,
        initialProgress: 50.0,
        initialStatus: 'running',
      );

      controller.trackedJobs.add(job1);
      expect(controller.canFinishModule, isFalse);

      // Job 1 done but not yet reviewed
      job1.progress.value = 100.0;
      job1.status.value = 'done';
      expect(controller.canFinishModule, isFalse);

      // Mark Job 1 reviewed
      controller.markChapterAsReviewed(10);
      expect(job1.isReviewed.value, isTrue);
      expect(controller.canFinishModule, isTrue);

      // Add another running job
      final job2 = TrackedChapterJob(
        chapterId: 11,
        jobId: 21,
        chapterNumber: 2,
        title: 'BAB 2',
        startPage: 6,
        endPage: 10,
        initialProgress: 20.0,
        initialStatus: 'running',
      );
      controller.trackedJobs.add(job2);
      expect(controller.canFinishModule, isFalse);

      // Complete job 2 and review
      job2.progress.value = 100.0;
      job2.status.value = 'done';
      expect(controller.canFinishModule, isFalse);

      controller.markChapterAsReviewed(11);
      expect(controller.canFinishModule, isTrue);
    });

    test('onTapChapterItem sets isOpeningChapter and openingJobId during execution', () async {
      final job = TrackedChapterJob(
        chapterId: 10,
        jobId: 20,
        chapterNumber: 1,
        title: 'BAB 1',
        startPage: 1,
        endPage: 10,
        initialProgress: 100.0,
        initialStatus: 'done',
      );

      when(() => mockTeacherRepo.getChapterDetail(chapterId: 10)).thenAnswer(
        (_) async => TeacherChapterDetailModel(
          id: 10,
          moduleId: 1,
          title: 'BAB 1',
          number: 1,
          createdAt: DateTime.now(),
          blocks: [],
        ),
      );

      final future = controller.onTapChapterItem(job);
      expect(controller.isOpeningChapter.value, isTrue);
      expect(controller.openingJobId.value, equals(20));

      await future;
      expect(controller.isOpeningChapter.value, isFalse);
      expect(controller.openingJobId.value, isNull);
    });
  });
}
