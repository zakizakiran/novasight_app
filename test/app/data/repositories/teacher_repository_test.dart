import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/core/errors/api_exception.dart';
import 'package:lydera_app/app/data/models/api_response.dart';
import 'package:lydera_app/app/data/models/block_regenerate_model.dart';
import 'package:lydera_app/app/data/models/chapter_job_stream_model.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/data/providers/teacher_provider.dart';
import 'package:lydera_app/app/data/repositories/teacher_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';

class MockTeacherProvider extends Mock implements TeacherProvider {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockTeacherProvider mockProvider;
  late MockStorageService mockStorage;
  late TeacherRepository repository;

  final testNow = DateTime.parse('2026-09-15T00:00:00.000Z');

  setUp(() {
    mockProvider = MockTeacherProvider();
    mockStorage = MockStorageService();
    repository = TeacherRepository(
      teacherProvider: mockProvider,
      storageService: mockStorage,
    );
  });

  group('TeacherRepository Tests', () {
    test('getDashboard returns TeacherDashboardModel and caches class details and email', () async {
      final mockDashboard = TeacherDashboardModel(
        teacherEmail: 'teacher@example.com',
        classroomInfo: ClassroomInfoModel(
          schoolName: 'SLBN A-Citeureup',
          code: 'NSG-4821',
          gradeClass: 10,
          classroomType: 'Tunanetra',
        ),
        totalModules: 5,
        totalExams: 2,
        totalStudents: 28,
        newestModules: [
          TeacherNewestModuleModel(
            id: 1,
            title: 'Eksponen',
            faseId: 1,
            createdAt: testNow,
          ),
        ],
        newestExams: [],
      );

      when(() => mockProvider.getDashboard(classroomId: 10)).thenAnswer(
        (_) async => ApiResponse<TeacherDashboardModel>(
          message: 'Success',
          data: mockDashboard,
        ),
      );
      when(() => mockStorage.writeClassCode(any())).thenAnswer((_) async {});
      when(() => mockStorage.writeClassName(any())).thenAnswer((_) async {});
      when(() => mockStorage.writeUserEmail(any())).thenAnswer((_) async {});

      final result = await repository.getDashboard(classroomId: 10);

      expect(result.teacherEmail, equals('teacher@example.com'));
      expect(result.totalModules, equals(5));
      expect(result.totalExams, equals(2));
      expect(result.totalStudents, equals(28));
      expect(result.newestModules.length, equals(1));
      expect(result.newestModules.first.title, equals('Eksponen'));

      verify(() => mockProvider.getDashboard(classroomId: 10)).called(1);
      verify(() => mockStorage.writeClassCode('NSG-4821')).called(1);
      verify(() => mockStorage.writeUserEmail('teacher@example.com')).called(1);
    });

    test('getDashboard rethrows ApiException on failure', () async {
      when(() => mockProvider.getDashboard(classroomId: 99)).thenThrow(
        const ApiException(message: 'Classroom not found', statusCode: 404),
      );

      expect(
        () => repository.getDashboard(classroomId: 99),
        throwsA(isA<ApiException>()),
      );
      verify(() => mockProvider.getDashboard(classroomId: 99)).called(1);
    });

    test('getModules returns list of TeacherModuleModel', () async {
      final mockModules = [
        TeacherModuleModel(
          id: 1,
          title: 'Aljabar',
          faseId: 1,
          createdAt: testNow,
          status: 'publish',
        ),
      ];

      when(() => mockProvider.getModules(
            classroomId: 10,
            search: 'Aljabar',
            status: TeacherModuleStatus.publish,
          )).thenAnswer(
        (_) async => ApiResponse<List<TeacherModuleModel>>(
          message: 'Success',
          data: mockModules,
        ),
      );

      final result = await repository.getModules(
        classroomId: 10,
        search: 'Aljabar',
        status: TeacherModuleStatus.publish,
      );

      expect(result.length, equals(1));
      expect(result.first.title, equals('Aljabar'));
      expect(result.first.status, equals('publish'));
      verify(() => mockProvider.getModules(
            classroomId: 10,
            search: 'Aljabar',
            status: TeacherModuleStatus.publish,
          )).called(1);
    });

    test('getModuleDetail returns TeacherModuleDetailModel with chapters', () async {
      final mockDetail = TeacherModuleDetailModel(
        id: 1,
        title: 'Aljabar',
        faseId: 1,
        createdAt: testNow,
        status: 'publish',
        chapters: [
          TeacherChapterSummaryModel(
            id: 101,
            moduleId: 1,
            number: 1,
            title: 'Persamaan Linear',
            createdAt: testNow,
          ),
        ],
      );

      when(() => mockProvider.getModuleDetail(
            moduleId: 1,
            classroomId: 10,
          )).thenAnswer(
        (_) async => ApiResponse<TeacherModuleDetailModel>(
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
      expect(result.chapters.first.title, equals('Persamaan Linear'));
      verify(() => mockProvider.getModuleDetail(
            moduleId: 1,
            classroomId: 10,
          )).called(1);
    });

    test('getChapterDetail returns TeacherChapterDetailModel with blocks', () async {
      final mockChapter = TeacherChapterDetailModel(
        id: 101,
        moduleId: 1,
        number: 1,
        title: 'Persamaan Linear',
        createdAt: testNow,
        blocks: [
          BlockResponseModel(
            id: 1,
            readingOrder: 1,
            blockType: 'paragraph',
            readableText: 'Ini adalah materi persamaan linear.',
            reviewPriority: 'normal',
            headingLevel: null,
            sourceMarkup: null,
            caption: null,
            imageFile: null,
          ),
        ],
      );

      when(() => mockProvider.getChapterDetail(chapterId: 101)).thenAnswer(
        (_) async => ApiResponse<TeacherChapterDetailModel>(
          message: 'Success',
          data: mockChapter,
        ),
      );

      final result = await repository.getChapterDetail(chapterId: 101);

      expect(result.id, equals(101));
      expect(result.blocks.length, equals(1));
      expect(
        result.blocks.first.readableText,
        equals('Ini adalah materi persamaan linear.'),
      );
      verify(() => mockProvider.getChapterDetail(chapterId: 101)).called(1);
    });

    test('previewChapter calls provider and returns list of preview blocks', () async {
      final mockBlocks = [
        BlockPreviewResponseModel(
          readingOrder: 1,
          blockType: 'text',
          readableText: 'Konten preview',
          reviewPriority: 'normal',
        ),
      ];

      when(() => mockProvider.previewChapter(annotationPath: 'path/to/annotated.json'))
          .thenAnswer((_) async => ApiResponse(
                message: 'Success',
                data: mockBlocks,
              ));

      final result = await repository.previewChapter('path/to/annotated.json');

      expect(result.length, equals(1));
      expect(result.first.readableText, equals('Konten preview'));
      verify(() => mockProvider.previewChapter(annotationPath: 'path/to/annotated.json')).called(1);
    });

    test('confirmChapter calls provider with chapterId and annotationPath', () async {
      when(() => mockProvider.confirmChapter(
            chapterId: 101,
            annotationPath: 'path/to/annotated.json',
          )).thenAnswer((_) async => ApiResponse(
            message: 'Chapter confirmed successfully',
            data: 101,
          ));

      final result = await repository.confirmChapter(
        chapterId: 101,
        annotationPath: 'path/to/annotated.json',
      );

      expect(result, isTrue);
      verify(() => mockProvider.confirmChapter(
            chapterId: 101,
            annotationPath: 'path/to/annotated.json',
          )).called(1);
    });

    test('bulkRegenerateSpecial calls provider and returns list of RegenerateDetailResponseModel', () async {
      final mockDetails = [
        RegenerateDetailResponseModel(
          blockId: 2,
          readableText: 'Anotasi AI teregenerasi untuk diagram',
        ),
      ];

      when(() => mockProvider.bulkRegenerateSpecial(
            blockIds: [2],
            feedback: 'Tolong perjelas grafik',
          )).thenAnswer((_) async => ApiResponse(
            message: 'Success',
            data: mockDetails,
          ));

      final result = await repository.bulkRegenerateSpecial(
        blockIds: [2],
        feedback: 'Tolong perjelas grafik',
      );

      expect(result.length, equals(1));
      expect(result.first.blockId, equals(2));
      expect(result.first.readableText, equals('Anotasi AI teregenerasi untuk diagram'));
      verify(() => mockProvider.bulkRegenerateSpecial(
            blockIds: [2],
            feedback: 'Tolong perjelas grafik',
          )).called(1);
    });

    test('bulkRegenerateText calls provider and returns RegenerateResponseModel', () async {
      final mockResponse = RegenerateResponseModel(
        blockIds: [1],
        readableText: 'Anotasi AI teks teregenerasi',
      );

      when(() => mockProvider.bulkRegenerateText(
            blockIds: [1],
            feedback: 'Sederhanakan kalimat',
          )).thenAnswer((_) async => ApiResponse(
            message: 'Success',
            data: mockResponse,
          ));

      final result = await repository.bulkRegenerateText(
        blockIds: [1],
        feedback: 'Sederhanakan kalimat',
      );

      expect(result.blockIds, equals([1]));
      expect(result.readableText, equals('Anotasi AI teks teregenerasi'));
      verify(() => mockProvider.bulkRegenerateText(
            blockIds: [1],
            feedback: 'Sederhanakan kalimat',
          )).called(1);
    });

    test('deleteModule calls provider and returns true on success', () async {
      when(() => mockProvider.deleteModule(
            moduleId: 1,
            classroomId: 10,
          )).thenAnswer((_) async => ApiResponse<bool>(
            message: 'Success',
            data: true,
          ));

      final result = await repository.deleteModule(
        moduleId: 1,
        classroomId: 10,
      );

      expect(result, isTrue);
      verify(() => mockProvider.deleteModule(
            moduleId: 1,
            classroomId: 10,
          )).called(1);
    });
  });
}
