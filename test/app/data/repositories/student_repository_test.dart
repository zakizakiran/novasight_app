import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/providers/student_provider.dart';
import 'package:novasight_app/app/data/repositories/student_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class MockStudentProvider extends Mock implements StudentProvider {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStudentProvider mockProvider;
  late MockStorageService mockStorage;
  late StudentRepository repository;

  final testNow = DateTime.parse('2026-09-14T00:00:00.000Z');

  setUp(() {
    mockProvider = MockStudentProvider();
    mockStorage = MockStorageService();
    repository = StudentRepository(
      studentProvider: mockProvider,
      storageService: mockStorage,
    );
  });

  group('StudentRepository Tests', () {
    test('getDashboard returns StudentDashboardModel and caches details', () async {
      final mockDashboard = StudentDashboardModel(
        studentEmail: 'student@example.com',
        classroomInfo: ClassroomInfoModel(
          schoolName: 'SLBN A-Citeureup',
          code: 'CLS-1234',
          gradeClass: 10,
          classroomType: 'Tunanetra',
        ),
        modulesNotDone: 3,
        examNotDone: 1,
      );

      when(() => mockProvider.getDashboard(classroomId: 10)).thenAnswer(
        (_) async => ApiResponse<StudentDashboardModel>(
          message: 'Success',
          data: mockDashboard,
        ),
      );
      when(() => mockStorage.writeClassCode(any())).thenAnswer((_) async {});
      when(() => mockStorage.writeClassName(any())).thenAnswer((_) async {});
      when(() => mockStorage.writeUserEmail(any())).thenAnswer((_) async {});

      final result = await repository.getDashboard(classroomId: 10);

      expect(result.studentEmail, equals('student@example.com'));
      expect(result.modulesNotDone, equals(3));
      expect(result.examNotDone, equals(1));
      expect(result.classroomInfo?.schoolName, equals('SLBN A-Citeureup'));

      verify(() => mockProvider.getDashboard(classroomId: 10)).called(1);
      verify(() => mockStorage.writeClassCode('CLS-1234')).called(1);
      verify(() => mockStorage.writeUserEmail('student@example.com')).called(1);
    });

    test('getDashboard rethrows ApiException on failure', () async {
      when(() => mockProvider.getDashboard(classroomId: 99)).thenThrow(
        const ApiException(message: 'Classroom not found', statusCode: 404),
      );

      expect(
        () => repository.getDashboard(classroomId: 99),
        throwsA(isA<ApiException>()),
      );
    });

    test('getDashboardTasks returns StudentTaskModel', () async {
      final mockTasks = StudentTaskModel(
        modules: [
          StudentModuleModel(
            id: 1,
            title: 'Eksponen dan Logaritma',
            faseId: 1,
            createdAt: testNow,
            progress: ModuleProgressModel(
              id: 101,
              studentId: 5,
              moduleId: 1,
              progressPercentage: 50,
              isDone: false,
            ),
          ),
        ],
        exams: [],
      );

      when(
        () => mockProvider.getDashboardTasks(
          classroomId: 10,
          status: StudentTaskStatus.materi,
        ),
      ).thenAnswer(
        (_) async => ApiResponse<StudentTaskModel>(
          message: 'Success',
          data: mockTasks,
        ),
      );

      final result = await repository.getDashboardTasks(
        classroomId: 10,
        status: StudentTaskStatus.materi,
      );

      expect(result.modules.length, equals(1));
      expect(result.modules.first.title, equals('Eksponen dan Logaritma'));
      expect(result.modules.first.progress?.progressPercentage, equals(50));
      verify(
        () => mockProvider.getDashboardTasks(
          classroomId: 10,
          status: StudentTaskStatus.materi,
        ),
      ).called(1);
    });

    test('getModules returns list of StudentModuleModel', () async {
      final mockModules = [
        StudentModuleModel(
          id: 1,
          title: 'Aljabar',
          faseId: 2,
          createdAt: testNow,
        ),
      ];

      when(
        () => mockProvider.getModules(
          classroomId: 10,
          status: StudentModuleStatus.belumSelesai,
        ),
      ).thenAnswer(
        (_) async => ApiResponse<List<StudentModuleModel>>(
          message: 'Success',
          data: mockModules,
        ),
      );

      final result = await repository.getModules(
        classroomId: 10,
        status: StudentModuleStatus.belumSelesai,
      );

      expect(result.length, equals(1));
      expect(result.first.title, equals('Aljabar'));
      verify(
        () => mockProvider.getModules(
          classroomId: 10,
          status: StudentModuleStatus.belumSelesai,
        ),
      ).called(1);
    });

    test('getModuleDetail returns StudentModuleDetailModel', () async {
      final mockDetail = StudentModuleDetailModel(
        id: 1,
        title: 'Eksponen',
        faseId: 1,
        createdAt: testNow,
        chapters: [
          StudentChapterSummaryModel(
            id: 201,
            title: 'Pengertian Eksponen',
            number: 1,
            chapterProgress: StudentChapterProgressModel(isDone: true),
          ),
        ],
      );

      when(
        () => mockProvider.getModuleDetail(
          moduleId: 1,
          classroomId: 10,
        ),
      ).thenAnswer(
        (_) async => ApiResponse<StudentModuleDetailModel>(
          message: 'Success',
          data: mockDetail,
        ),
      );

      final result = await repository.getModuleDetail(
        moduleId: 1,
        classroomId: 10,
      );

      expect(result.id, equals(1));
      expect(result.chapters.length, equals(1));
      expect(result.chapters.first.title, equals('Pengertian Eksponen'));
      expect(result.chapters.first.chapterProgress?.isDone, isTrue);
      verify(
        () => mockProvider.getModuleDetail(
          moduleId: 1,
          classroomId: 10,
        ),
      ).called(1);
    });

    test('startChapter returns StudentChapterDetailModel with blocks', () async {
      final mockChapter = StudentChapterDetailModel(
        id: 201,
        title: 'Pengertian Eksponen',
        number: 1,
        chapterProgress: StudentChapterProgressModel(isDone: false),
        blocks: [
          BlockResponseModel(
            id: 1,
            readingOrder: 1,
            blockType: 'text',
            readableText: 'Eksponen adalah perkalian berulang.',
            reviewPriority: 'low',
            headingLevel: 1,
            sourceMarkup: null,
            caption: null,
            imageFile: null,
          ),
        ],
      );

      when(() => mockProvider.startChapter(chapterId: 201)).thenAnswer(
        (_) async => ApiResponse<StudentChapterDetailModel>(
          message: 'Success',
          data: mockChapter,
        ),
      );

      final result = await repository.startChapter(chapterId: 201);

      expect(result.id, equals(201));
      expect(result.blocks?.length, equals(1));
      expect(result.blocks?.first.readableText, contains('Eksponen'));
      verify(() => mockProvider.startChapter(chapterId: 201)).called(1);
    });

    test('markChapterComplete returns bool', () async {
      when(() => mockProvider.markChapterComplete(chapterId: 201)).thenAnswer(
        (_) async => ApiResponse<bool>(
          message: 'Marked complete',
          data: true,
        ),
      );

      final result = await repository.markChapterComplete(chapterId: 201);

      expect(result, isTrue);
      verify(() => mockProvider.markChapterComplete(chapterId: 201)).called(1);
    });
  });
}
