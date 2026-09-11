import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/providers/classroom_provider.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';

class MockClassroomProvider extends Mock implements ClassroomProvider {}

class FakeClassroomCreateModel extends Fake implements ClassroomCreateModel {}

class FakeJoinClassroomRequestModel extends Fake
    implements JoinClassroomRequestModel {}

void main() {
  late MockClassroomProvider mockProvider;
  late ClassroomRepository repository;

  final testNow = DateTime.now();

  setUpAll(() {
    registerFallbackValue(FakeClassroomCreateModel());
    registerFallbackValue(FakeJoinClassroomRequestModel());
  });

  setUp(() {
    mockProvider = MockClassroomProvider();
    repository = ClassroomRepository(classroomProvider: mockProvider);
  });

  group('ClassroomRepository Tests', () {
    test('getClassroomTypes returns list of ClassroomTypeModel', () async {
      final mockData = [
        ClassroomTypeModel(
          id: 1,
          name: 'Matematika',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      ];

      when(() => mockProvider.getClassroomTypes()).thenAnswer(
        (_) async => ApiResponse<List<ClassroomTypeModel>>(
          message: 'Success',
          data: mockData,
        ),
      );

      final result = await repository.getClassroomTypes();
      expect(result.length, equals(1));
      expect(result.first.name, equals('Matematika'));
      verify(() => mockProvider.getClassroomTypes()).called(1);
    });

    test('getClassroomTypes rethrows ApiException on failure', () async {
      when(() => mockProvider.getClassroomTypes()).thenThrow(
        const ApiException(message: 'Network Error'),
      );

      expect(
        () => repository.getClassroomTypes(),
        throwsA(isA<ApiException>()),
      );
    });

    test('getCities returns list of CityResponseModel', () async {
      final mockData = [
        CityResponseModel(
          id: 10,
          name: 'Jakarta',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      ];

      when(() => mockProvider.getCities()).thenAnswer(
        (_) async => ApiResponse<List<CityResponseModel>>(
          message: 'Success',
          data: mockData,
        ),
      );

      final result = await repository.getCities();
      expect(result.length, equals(1));
      expect(result.first.name, equals('Jakarta'));
      verify(() => mockProvider.getCities()).called(1);
    });

    test('getSchoolsByCity returns list of SchoolResponseModel', () async {
      final mockData = [
        SchoolResponseModel(
          id: 100,
          cityId: 10,
          name: 'SMAN 1 Jakarta',
          createdAt: testNow,
          updatedAt: testNow,
        ),
      ];

      when(() => mockProvider.getSchoolsByCity(10)).thenAnswer(
        (_) async => ApiResponse<List<SchoolResponseModel>>(
          message: 'Success',
          data: mockData,
        ),
      );

      final result = await repository.getSchoolsByCity(10);
      expect(result.length, equals(1));
      expect(result.first.name, equals('SMAN 1 Jakarta'));
      verify(() => mockProvider.getSchoolsByCity(10)).called(1);
    });

    test('createClassroom returns ClassroomResponseModel', () async {
      final mockClassroom = ClassroomResponseModel(
        id: 1,
        teacherId: 2,
        schoolId: 100,
        name: 'Kelas 10 IPA 1',
        code: 'NSG-4821',
        grade: 10,
        classroomType: ClassroomTypeModel(
          id: 1,
          name: 'Matematika',
          createdAt: testNow,
          updatedAt: testNow,
        ),
        createdAt: testNow,
        updatedAt: testNow,
      );

      when(() => mockProvider.createClassroom(any())).thenAnswer(
        (_) async => ApiResponse<ClassroomResponseModel>(
          message: 'Created',
          data: mockClassroom,
        ),
      );

      final result = await repository.createClassroom(
        name: 'Kelas 10 IPA 1',
        classroomTypeId: 1,
        schoolId: 100,
        grade: 10,
      );

      expect(result.id, equals(1));
      expect(result.code, equals('NSG-4821'));
      expect(result.name, equals('Kelas 10 IPA 1'));
      verify(() => mockProvider.createClassroom(any())).called(1);
    });

    test('joinClassroom calls provider joinClassroom', () async {
      when(() => mockProvider.joinClassroom(any())).thenAnswer(
        (_) async => ApiResponse<void>(message: 'Success', data: null),
      );

      await repository.joinClassroom(code: 'NSG4821');
      verify(() => mockProvider.joinClassroom(any())).called(1);
    });

    test('getClassrooms returns list of ClassroomResponseModel', () async {
      final mockData = [
        ClassroomResponseModel(
          id: 1,
          teacherId: 2,
          schoolId: 100,
          name: 'Kelas 10 IPA 1',
          code: 'NSG-4821',
          grade: 10,
          classroomType: ClassroomTypeModel(
            id: 1,
            name: 'Matematika',
            createdAt: testNow,
            updatedAt: testNow,
          ),
          createdAt: testNow,
          updatedAt: testNow,
        ),
      ];

      when(() => mockProvider.getClassrooms()).thenAnswer(
        (_) async => ApiResponse<List<ClassroomResponseModel>>(
          message: 'Success',
          data: mockData,
        ),
      );

      final result = await repository.getClassrooms();
      expect(result.length, equals(1));
      verify(() => mockProvider.getClassrooms()).called(1);
    });
  });
}
