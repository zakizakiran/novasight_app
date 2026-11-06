import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/data/models/api_response.dart';
import 'package:lydera_app/app/data/models/quiz_teacher_model.dart';
import 'package:lydera_app/app/data/providers/teacher_provider.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/modules/generate-exam/models/generated_question.dart';

class MockTeacherProvider extends Mock implements TeacherProvider {}

void main() {
  late MockTeacherProvider mockProvider;
  late TeacherRepository repository;

  final testNow = DateTime.parse('2026-09-16T12:00:00.000Z');

  setUp(() {
    mockProvider = MockTeacherProvider();
    repository = TeacherRepository(teacherProvider: mockProvider);
  });

  group('TeacherRepository Quiz Endpoints Tests', () {
    test('getQuizzes returns list of QuizRequestTeacherModel', () async {
      final mockQuizzes = [
        QuizRequestTeacherModel(
          id: 1,
          moduleId: 10,
          title: 'Kuis Eksponen',
          statusPublished: 'publish',
          maxDurationMinutes: 60,
          startTime: testNow,
          endTime: testNow.add(const Duration(days: 7)),
          status: 'done',
          questionCounts: 5,
          module: ModuleQuizModel(id: 10, title: 'Modul Eksponen'),
        ),
      ];

      when(() => mockProvider.getQuizzes(classroomId: 1))
          .thenAnswer((_) async => ApiResponse<List<QuizRequestTeacherModel>>(
                message: 'Success',
                data: mockQuizzes,
              ));

      final result = await repository.getQuizzes(classroomId: 1);

      expect(result.length, 1);
      expect(result.first.id, 1);
      expect(result.first.title, 'Kuis Eksponen');
      expect(result.first.isPublished, true);
    });

    test('getQuizDetail returns QuizRequestTeacherDetailModel', () async {
      final mockDetail = QuizRequestTeacherDetailModel(
        id: 1,
        moduleId: 10,
        title: 'Kuis Detail Test',
        statusPublished: 'draft',
        status: 'done',
        maxDurationMinutes: 45,
        startTime: testNow,
        endTime: testNow.add(const Duration(hours: 2)),
        questions: [
          QuizRequestQuestionModel(
            id: 101,
            chapterId: 20,
            stimulus: QuestionStimulusModel(
              id: 5,
              sourceMarkup: '<p>Teks stimulus</p>',
              readableText: 'Teks stimulus',
              reviewStatus: 'approved',
              sourceReadingOrderStart: 0,
              sourceReadingOrderEnd: 1,
            ),
            bloomLevel: 4,
            questionText: 'Soal HOTS 1?',
            correctOption: 'A',
            kesimpulan: 'Jawaban A',
            sourceReadingOrderStart: 0,
            sourceReadingOrderEnd: 1,
            options: [
              QuestionOptionModel(id: 1, label: 'A', opsiText: 'Opsi A'),
              QuestionOptionModel(id: 2, label: 'B', opsiText: 'Opsi B'),
            ],
            explanationSteps: [
              QuestionExplanationStepModel(id: 1, steps: 1, text: 'Langkah 1'),
            ],
          ),
        ],
        quizRequestChapters: [
          QuizRequestChapterDetailModel(
            quizRequestId: 1,
            chapterId: 20,
            hotsCount: 2,
            lotsCount: 3,
          ),
        ],
        module: ModuleQuizModel(id: 10, title: 'Modul 10'),
      );

      when(() => mockProvider.getQuizDetail(quizId: 1, classroomId: 1))
          .thenAnswer((_) async => ApiResponse<QuizRequestTeacherDetailModel>(
                message: 'Success',
                data: mockDetail,
              ));

      final result = await repository.getQuizDetail(quizId: 1, classroomId: 1);

      expect(result.id, 1);
      expect(result.questions.length, 1);
      expect(result.questions.first.isHots, true);
      expect(result.questions.first.options.length, 2);
    });

    test('deleteQuiz returns true on success', () async {
      when(() => mockProvider.deleteQuiz(quizId: 1, classroomId: 1))
          .thenAnswer((_) async => ApiResponse<bool>(
                message: 'Deleted',
                data: true,
              ));

      final result = await repository.deleteQuiz(quizId: 1, classroomId: 1);

      expect(result, true);
    });

    test('updateQuizStatus returns true on success', () async {
      when(() => mockProvider.updateQuizStatus(
            quizId: 1,
            classroomId: 1,
            status: 'publish',
          )).thenAnswer((_) async => ApiResponse<bool>(
            message: 'Updated',
            data: true,
          ));

      final result = await repository.updateQuizStatus(
        quizId: 1,
        classroomId: 1,
        status: 'publish',
      );

      expect(result, true);
    });

    test('createQuizStream yields events', () async {
      final payload = QuizRequestCreatePayload(
        classroomId: 1,
        moduleId: 10,
        title: 'Kuis Baru',
        chapters: [QuizChapterRequest(chapterId: 20, hotsCount: 1, lotsCount: 2)],
        maxDurationMinutes: 30,
        startTime: testNow,
        endTime: testNow.add(const Duration(days: 1)),
      );

      final event = QuizStreamEvent(
        quizRequestId: 99,
        status: 'done',
        completed: 3,
        total: 3,
        message: 'Selesai',
      );

      when(() => mockProvider.createQuizStream(payload))
          .thenAnswer((_) => Stream.value(event));

      final stream = repository.createQuizStream(payload);
      final events = await stream.toList();

      expect(events.length, 1);
      expect(events.first.quizRequestId, 99);
      expect(events.first.status, 'done');
    });

    test('regenerateStimulusSoal returns list of SoalResponseModel', () async {
      final mockSoal = SoalResponseModel(
        id: 101,
        chapterId: 20,
        stimulusId: 5,
        stimulusText: 'Stimulus Baru dari AI',
        bloomLevel: 4,
        questionText: 'Pertanyaan',
        correctOption: 'B',
        kesimpulan: 'Kesimpulan',
        options: [SoalOpsiResponseModel(label: 'A', opsiText: 'Opsi A')],
        langkah: ['Langkah 1'],
        reviewStatus: 'approved',
        reviewPriority: 'normal',
      );

      when(() => mockProvider.regenerateStimulusSoal(
            soalId: 101,
            feedback: 'Lebih kontekstual',
          )).thenAnswer((_) async => ApiResponse<List<SoalResponseModel>>(
            message: 'Regenerated',
            data: [mockSoal],
          ));

      final result = await repository.regenerateStimulusSoal(
        soalId: 101,
        feedback: 'Lebih kontekstual',
      );

      expect(result.length, 1);
      expect(result.first.stimulusText, 'Stimulus Baru dari AI');
    });

    test('editSoal returns updated SoalResponseModel', () async {
      final payload = SoalEditRequest(
        questionText: 'Pertanyaan Diedit',
        kesimpulan: 'Kesimpulan Baru',
        options: {'A': 'Teks Baru'},
        correctOption: 'A',
        langkah: ['Langkah 1'],
      );

      final mockSoal = SoalResponseModel(
        id: 101,
        chapterId: 20,
        stimulusId: 5,
        stimulusText: 'Stimulus',
        bloomLevel: 3,
        questionText: 'Pertanyaan Diedit',
        correctOption: 'A',
        kesimpulan: 'Kesimpulan Baru',
        options: [SoalOpsiResponseModel(label: 'A', opsiText: 'Teks Baru')],
        langkah: ['Langkah 1'],
        reviewStatus: 'approved',
        reviewPriority: 'normal',
      );

      when(() => mockProvider.editSoal(soalId: 101, payload: payload))
          .thenAnswer((_) async => ApiResponse<SoalResponseModel>(
                message: 'Updated',
                data: mockSoal,
              ));

      final result = await repository.editSoal(soalId: 101, payload: payload);

      expect(result.questionText, 'Pertanyaan Diedit');
      expect(result.bloomLevel, 3);
    });

    test('QuizRequestQuestionModel & GeneratedQuestion parse new stimulus (gambar/tabel), source_point, and markup fields', () {
      final gambarJson = {
        'id': 90,
        'chapter_id': 15,
        'stimulus': {
          'id': 38,
          'source_markup': '',
          'readable_text': 'Gambar menunjukkan ruang sampel pelemparan dua dadu.',
          'ringkasan': null,
          'tabel': null,
          'jenis': 'gambar',
          'spesifikasi': {
            'svg': '<svg viewBox="0 0 240 220"></svg>',
            'deskripsi': 'Tabel 6 kali 6 dengan tiga sel diarsir.',
            'skema_versi': 1,
          },
          'review_status': 'pending',
          'source_reading_order_start': 840,
          'source_reading_order_end': 860,
        },
        'bloom_level': 4,
        'question_text': 'Berdasarkan gambar tadi, manakah pernyataan yang tepat?',
        'correct_option': 'D',
        'kesimpulan': 'Peluang diarsir lebih kecil.',
        'source_reading_order_start': 840,
        'source_reading_order_end': 860,
        'review_status': 'pending',
        'review_priority': 'high',
        'validation_notes': 'Jangan memakai kata stimulus.',
        'source_point': 'Tabel ruang sampel untuk peluang.',
        'markup': {
          'langkah': [r'Tabel memuat $6 \times 6 = 36$ sel.'],
          'options': {'A': 'opsi A', 'D': 'opsi D'},
          'question': 'Pertanyaan markup?',
          'kesimpulan': 'Kesimpulan markup.',
        },
        'options': [
          {'id': 369, 'label': 'A', 'opsi_text': 'opsi A'},
          {'id': 370, 'label': 'B', 'opsi_text': 'opsi B'},
          {'id': 371, 'label': 'C', 'opsi_text': 'opsi C'},
          {'id': 372, 'label': 'D', 'opsi_text': 'opsi D'},
        ],
        'explanation_steps': [
          {'id': 328, 'steps': 1, 'text': 'Tabel memuat enam kali enam sel.'},
        ],
      };

      final tabelJson = {
        'id': 91,
        'chapter_id': 15,
        'stimulus': {
          'id': 39,
          'source_markup': '',
          'readable_text': 'Tabel distribusi peluang.',
          'ringkasan': 'Ada 2 kolom dan 2 baris.',
          'tabel': {
            'baris': [
              ['1', 'satu per tiga puluh enam'],
            ],
            'judul': 'Tabel distribusi peluang',
            'kolom': ['Angka', 'Peluang'],
          },
          'jenis': 'tabel',
          'spesifikasi': {
            'baris': [
              ['1', r'$\frac{1}{36}$'],
            ],
            'judul': 'Tabel distribusi peluang',
            'kolom': ['Angka', 'Peluang'],
            'skema_versi': 1,
          },
          'review_status': 'pending',
          'source_reading_order_start': 900,
          'source_reading_order_end': 920,
        },
        'bloom_level': 4,
        'question_text': 'Soal tabel?',
        'correct_option': 'B',
        'kesimpulan': 'Kesimpulan tabel.',
        'source_reading_order_start': 900,
        'source_reading_order_end': 920,
        'review_status': 'pending',
        'review_priority': 'normal',
        'validation_notes': null,
        'source_point': 'Peluang dari tabel.',
        'markup': null,
        'options': [
          {'id': 373, 'label': 'A', 'opsi_text': 'A'},
          {'id': 374, 'label': 'B', 'opsi_text': 'B'},
        ],
        'explanation_steps': [],
      };

      final qGambar = QuizRequestQuestionModel.fromJson(gambarJson);
      expect(qGambar.stimulus?.jenis, 'gambar');
      expect(qGambar.stimulus?.svgMarkup, '<svg viewBox="0 0 240 220"></svg>');
      expect(qGambar.sourcePoint, 'Tabel ruang sampel untuk peluang.');
      expect(qGambar.validationNotes, 'Jangan memakai kata stimulus.');
      expect(qGambar.reviewPriority, 'high');
      expect(qGambar.markup?.langkah.first, r'Tabel memuat $6 \times 6 = 36$ sel.');

      final genGambar = GeneratedQuestion.fromQuizRequestQuestion(qGambar);
      expect(genGambar.hasStimulus, isTrue);
      expect(genGambar.sourcePoint, 'Tabel ruang sampel untuk peluang.');
      expect(genGambar.validationNotes, 'Jangan memakai kata stimulus.');
      expect(genGambar.clone().id, 90);
      expect(genGambar.clone().stimulus?.svgMarkup, isNotNull);

      final qTabel = QuizRequestQuestionModel.fromJson(tabelJson);
      expect(qTabel.stimulus?.jenis, 'tabel');
      expect(qTabel.stimulus?.ringkasan, 'Ada 2 kolom dan 2 baris.');
      expect(qTabel.stimulus?.effectiveTable?.judul, 'Tabel distribusi peluang');
      expect(qTabel.stimulus?.effectiveTable?.baris.first.last, r'$\frac{1}{36}$');
    });
  });
}
