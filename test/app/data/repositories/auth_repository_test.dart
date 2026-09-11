import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/models/api_response.dart';
import 'package:novasight_app/app/data/models/auth_request_model.dart';
import 'package:novasight_app/app/data/models/user_model.dart';
import 'package:novasight_app/app/data/providers/auth_provider.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockStorageService extends Mock implements StorageService {}

class FakeLoginRequestModel extends Fake implements LoginRequestModel {}

class FakeRegisterStudentRequestModel extends Fake
    implements RegisterStudentRequestModel {}

class FakeRegisterTeacherRequestModel extends Fake
    implements RegisterTeacherRequestModel {}

void main() {
  late MockAuthProvider mockAuthProvider;
  late MockStorageService mockStorageService;
  late AuthRepository repository;

  setUpAll(() {
    registerFallbackValue(FakeLoginRequestModel());
    registerFallbackValue(FakeRegisterStudentRequestModel());
    registerFallbackValue(FakeRegisterTeacherRequestModel());
    registerFallbackValue(UserRoles.guru);
  });

  setUp(() {
    mockAuthProvider = MockAuthProvider();
    mockStorageService = MockStorageService();
    repository = AuthRepository(
      authProvider: mockAuthProvider,
      storageService: mockStorageService,
    );
  });

  group('AuthRepository Tests', () {
    test('login success saves token, role, password, and returns token', () async {
      const token = 'jwt_test_token';
      when(() => mockAuthProvider.login(any())).thenAnswer(
        (_) async => ApiResponse<String>(message: 'Success', data: token),
      );
      when(() => mockStorageService.writeAccessToken(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writeUserRole(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writePassword(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writeUserEmail(any()))
          .thenAnswer((_) async {});
      when(() => mockAuthProvider.getProfile()).thenAnswer(
        (_) async => ApiResponse<ProfileResponseModel>(
          message: 'Success',
          data: ProfileResponseModel(
            id: 1,
            email: 'guru@test.com',
            teacher: TeacherResponseModel(
              id: 1,
              createdAt: DateTime.parse('2026-03-08T10:00:00Z'),
              updatedAt: DateTime.parse('2026-03-08T10:00:00Z'),
            ),
          ),
        ),
      );
      when(() => mockStorageService.getUserName()).thenReturn(null);
      when(() => mockStorageService.writeUserName(any())).thenAnswer((_) async {});

      final result = await repository.login(
        email: 'guru@test.com',
        password: 'password123',
        role: UserRoles.guru,
      );

      expect(result, equals(token));
      verify(() => mockStorageService.writeAccessToken(token)).called(1);
      verify(() => mockStorageService.writeUserRole(UserRoles.guru)).called(1);
      verify(() => mockStorageService.writePassword('password123')).called(1);
    });

    test('login failure rethrows ApiException', () async {
      when(() => mockAuthProvider.login(any())).thenThrow(
        const ApiException(message: 'Email atau kata sandi salah.'),
      );

      expect(
        () => repository.login(
          email: 'wrong@test.com',
          password: 'password123',
          role: UserRoles.guru,
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('registerStudent success saves role and returns StudentResponseModel', () async {
      final student = StudentResponseModel(
        id: 10,
        nis: '12345',
        nisn: '67890',
        grade: 10,
        createdAt: DateTime.parse('2026-03-08T10:00:00Z'),
        updatedAt: DateTime.parse('2026-03-08T10:00:00Z'),
      );
      when(() => mockAuthProvider.registerStudent(any())).thenAnswer(
        (_) async => ApiResponse<StudentResponseModel>(
          message: 'Created',
          data: student,
        ),
      );
      when(() => mockStorageService.writeUserName(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writeUserRole(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writePassword(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writeUserEmail(any()))
          .thenAnswer((_) async {});

      final result = await repository.registerStudent(
        email: 'siswa@test.com',
        password: 'password123',
        confirmPassword: 'password123',
        fullName: 'Budi Santoso',
      );

      expect(result.id, equals(10));
      expect(result.nis, equals('12345'));
      verify(() => mockStorageService.writeUserName('Budi Santoso')).called(1);
      verify(() => mockStorageService.writeUserRole(UserRoles.siswa)).called(1);
    });

    test('registerTeacher success saves role and returns TeacherResponseModel', () async {
      final teacher = TeacherResponseModel(
        id: 5,
        createdAt: DateTime.parse('2026-03-08T10:00:00Z'),
        updatedAt: DateTime.parse('2026-03-08T10:00:00Z'),
      );
      when(() => mockAuthProvider.registerTeacher(any())).thenAnswer(
        (_) async => ApiResponse<TeacherResponseModel>(
          message: 'Created',
          data: teacher,
        ),
      );
      when(() => mockStorageService.writeUserName(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writeUserRole(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writePassword(any()))
          .thenAnswer((_) async {});
      when(() => mockStorageService.writeUserEmail(any()))
          .thenAnswer((_) async {});

      final result = await repository.registerTeacher(
        email: 'guru@test.com',
        password: 'password123',
        confirmPassword: 'password123',
        fullName: 'Ibu Ani',
      );

      expect(result.id, equals(5));
      verify(() => mockStorageService.writeUserName('Ibu Ani')).called(1);
      verify(() => mockStorageService.writeUserRole(UserRoles.guru)).called(1);
    });

    test('isLoggedIn checks token correctly', () async {
      when(() => mockStorageService.getAccessToken())
          .thenAnswer((_) async => 'valid_token');
      expect(await repository.isLoggedIn(), isTrue);

      when(() => mockStorageService.getAccessToken())
          .thenAnswer((_) async => null);
      expect(await repository.isLoggedIn(), isFalse);
    });
  });
}
