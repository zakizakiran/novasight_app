import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/accessbility/controllers/accessibility_controller.dart';
import 'package:lydera_app/l10n/app_localizations.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockStorageService mockStorage;

  setUp(() {
    Get.reset();
    mockStorage = MockStorageService();
    when(() => mockStorage.getLanguageCode()).thenReturn('id');
    when(() => mockStorage.writeLanguageCode(any())).thenAnswer((_) async {});
    Get.put<StorageService>(mockStorage);
  });

  tearDown(() {
    Get.reset();
  });

  test('AccessibilityController initializes default locale as id', () {
    final controller = AccessibilityController();
    Get.put(controller);

    expect(controller.locale.value, const Locale('id', 'ID'));
  });

  test('AccessibilityController loads en if saved in storage', () {
    when(() => mockStorage.getLanguageCode()).thenReturn('en');

    final controller = AccessibilityController();
    Get.put(controller);

    expect(controller.locale.value, const Locale('en', 'US'));
  });

  testWidgets('changeLanguage updates locale, Get locale, and writes to storage', (tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(),
      ),
    );

    final controller = AccessibilityController();
    Get.put(controller);

    controller.changeLanguage(const Locale('en', 'US'));
    await tester.pumpAndSettle();

    expect(controller.locale.value, const Locale('en', 'US'));
    verify(() => mockStorage.writeLanguageCode('en')).called(1);
  });

  test('AppLocalizations loads correct translations for id and en', () async {
    final l10nId = await AppLocalizations.delegate.load(const Locale('id'));
    expect(l10nId.settings, 'Pengaturan');
    expect(l10nId.language, 'Bahasa');
    expect(l10nId.filterAll, 'Semua');
    expect(l10nId.learningModules, 'Modul Pembelajaran');
    expect(l10nId.materialsAndExams, 'Materi dan Soal Ujian');
    expect(l10nId.totalModules, 'Total Modul');
    expect(l10nId.examQuestions, 'Soal Ujian');
    expect(l10nId.uploadModule, '+ Unggah Modul');
    expect(l10nId.studentProgressTitle, 'Progres Murid');
    expect(l10nId.score, 'Nilai');
    expect(l10nId.completedStatus, 'Selesai dikerjakan');
    expect(l10nId.notAttemptedStatus, 'Belum dikerjakan');
    expect(l10nId.durationAndQuestions(15, 5), '15 Menit • 5 Soal');

    final l10nEn = await AppLocalizations.delegate.load(const Locale('en'));
    expect(l10nEn.settings, 'Settings');
    expect(l10nEn.language, 'Language');
    expect(l10nEn.filterAll, 'All');
    expect(l10nEn.learningModules, 'Learning Modules');
    expect(l10nEn.materialsAndExams, 'Materials and Exams');
    expect(l10nEn.totalModules, 'Total Modules');
    expect(l10nEn.examQuestions, 'Exam Questions');
    expect(l10nEn.uploadModule, '+ Upload Module');
    expect(l10nEn.studentProgressTitle, 'Student Progress');
    expect(l10nEn.score, 'Score');
    expect(l10nEn.completedStatus, 'Completed');
    expect(l10nEn.notAttemptedStatus, 'Not attempted');
    expect(l10nEn.durationAndQuestions(15, 5), '15 Minutes • 5 Questions');
  });
}
