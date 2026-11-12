import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lydera_app/app/core/utils/module_status.dart';
import 'package:lydera_app/app/data/models/exam_model.dart';
import 'package:lydera_app/app/modules/exam/views/widgets/exam_card_widget.dart';

void main() {
  ExamModel buildExam({required bool canRetry}) {
    return ExamModel(
      id: '1',
      title: 'UTS Ujian Semester 1',
      subtitle: 'Matematika Dasar',
      statusText: 'Selesai dikerjakan',
      score: '80',
      status: PublicStatus.done,
      canRetry: canRetry,
    );
  }

  Future<void> pumpCard(
    WidgetTester tester, {
    required ExamModel exam,
    VoidCallback? onDetail,
    VoidCallback? onRetry,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ExamCardWidget(
              exam: exam,
              onDetail: onDetail ?? () {},
              onRetry: onRetry,
            ),
          ),
        ),
      ),
    );
  }

  group('ExamCardWidget retry button', () {
    testWidgets('shows "Ulang Ujian" when canRetry is true', (tester) async {
      await pumpCard(tester, exam: buildExam(canRetry: true), onRetry: () {});

      expect(find.text('Ulang Ujian'), findsOneWidget);
    });

    testWidgets('hides the button when canRetry is false', (tester) async {
      await pumpCard(tester, exam: buildExam(canRetry: false), onRetry: () {});

      expect(find.text('Ulang Ujian'), findsNothing);
    });

    testWidgets('hides the button when onRetry is null', (tester) async {
      await pumpCard(tester, exam: buildExam(canRetry: true));

      expect(find.text('Ulang Ujian'), findsNothing);
    });

    testWidgets('tapping the button calls onRetry, not onDetail', (
      tester,
    ) async {
      var retryCalls = 0;
      var detailCalls = 0;
      await pumpCard(
        tester,
        exam: buildExam(canRetry: true),
        onRetry: () => retryCalls++,
        onDetail: () => detailCalls++,
      );

      await tester.tap(find.text('Ulang Ujian'));
      await tester.pump();

      expect(retryCalls, 1);
      expect(detailCalls, 0);
    });

    testWidgets('button is exposed to screen readers', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpCard(tester, exam: buildExam(canRetry: true), onRetry: () {});

      expect(find.bySemanticsLabel('Ulang Ujian'), findsWidgets);
      handle.dispose();
    });
  });
}
