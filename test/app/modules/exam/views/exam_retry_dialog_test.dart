import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/common/common_dialog_widget.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/data/repositories/classroom_repository.dart';
import 'package:lydera_app/app/data/repositories/student_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/exam/controllers/exam_controller.dart';
import 'package:lydera_app/app/routes/app_pages.dart';

class MockStudentRepository extends Mock implements StudentRepository {}

class MockClassroomRepository extends Mock implements ClassroomRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late ExamController controller;

  final quiz = QuizRequestStudentResponse(
    id: 5,
    moduleId: 12,
    title: 'UTS Ujian Semester 1',
    statusPublished: 'publish',
    maxDurationMinutes: 60,
    maxRetry: 2,
    startTime: DateTime.now().subtract(const Duration(days: 1)),
    endTime: DateTime.now().add(const Duration(days: 7)),
    module: ModuleQuizResponse(id: 12, title: 'Matematika', description: ''),
    progress: QuizRequestStudentProgressResponse(
      isDone: true,
      attemptCount: 1,
      score: 70,
    ),
  );

  setUp(() {
    Get.testMode = true;
    controller = ExamController(
      studentRepository: MockStudentRepository(),
      classroomRepository: MockClassroomRepository(),
      storageService: MockStorageService(),
    );
  });

  tearDown(Get.reset);

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => controller.confirmRetryExam(quiz),
              child: const Text('open'),
            ),
          ),
        ),
        getPages: [
          GetPage(
            name: Routes.EXAM_ACTIVE,
            page: () => Scaffold(
              body: Text(
                'active:${(Get.arguments as QuizRequestStudentResponse).id}',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Finder dialogButton(String label) => find.descendant(
        of: find.byType(CommonDialogWidget),
        matching: find.text(label),
      );

  group('ExamController.confirmRetryExam', () {
    testWidgets('shows remaining attempts in the dialog', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Ulang Ujian?'), findsOneWidget);
      expect(
        find.text(
          'Kamu masih punya 1 dari 2 kesempatan. Mulai ulang ujian sekarang?',
        ),
        findsOneWidget,
      );
    });

    testWidgets('"Batal" closes the dialog without navigating', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(dialogButton('Batal'));
      await tester.pumpAndSettle();

      expect(find.byType(CommonDialogWidget), findsNothing);
      expect(find.textContaining('active:'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('confirming opens the exam page with the quiz', (
      tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(dialogButton('Ulang Ujian'));
      await tester.pumpAndSettle();

      expect(find.byType(CommonDialogWidget), findsNothing);
      expect(find.text('active:5'), findsOneWidget);
    });

    testWidgets('confirming still works while a snackbar is visible', (
      tester,
    ) async {
      await pumpApp(tester);
      Get.snackbar('Pengerjaan Selesai!', 'Silahkan review hasil pengerjaan');
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(dialogButton('Ulang Ujian'));
      await tester.pumpAndSettle();

      expect(find.byType(CommonDialogWidget), findsNothing);
      expect(find.text('active:5'), findsOneWidget);

      // Biarkan timer snackbar selesai agar tidak ada timer yang tertinggal.
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    });
  });
}
