import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/models/user_model.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/auth/register_account/controllers/register_account_controller.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepository;
  late MockStorageService mockStorageService;
  late RegisterAccountController controller;

  setUpAll(() {
    registerFallbackValue(UserRoles.guru);
  });

  setUp(() {
    Get.testMode = true;
    mockRepository = MockAuthRepository();
    mockStorageService = MockStorageService();
    when(() => mockRepository.storageService).thenReturn(mockStorageService);

    controller = RegisterAccountController(repository: mockRepository);
  });

  group('RegisterAccountController Tests', () {
    test('Initial states are correct', () {
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.isValid.value, isFalse);
      expect(controller.selectedRole.value, equals(UserRoles.guru));
    });

    test('onSelectedRole updates role', () {
      controller.onSelectedRole(UserRoles.siswa);
      expect(controller.selectedRole.value, equals(UserRoles.siswa));
    });

    test('onChange validates full form properly', () {
      controller.fullNameController.text = 'Budi Santoso';
      controller.emailController.text = 'budi@test.com';
      controller.passwordController.text = 'password123';
      controller.confirmPasswordController.text = 'password123';

      controller.onChange('');
      expect(controller.isValid.value, isTrue);

      controller.confirmPasswordController.text = 'differentpassword';
      controller.onChange('');
      expect(controller.isValid.value, isFalse);
    });

    test('onRegister failure updates errorMessage and resets isLoading', () async {
      when(
        () => mockRepository.registerTeacher(
          email: any(named: 'email'),
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
          fullName: any(named: 'fullName'),
        ),
      ).thenThrow(const ApiException(message: 'Email sudah terdaftar.'));

      controller.fullNameController.text = 'Guru Test';
      controller.emailController.text = 'guru@test.com';
      controller.passwordController.text = 'password123';
      controller.confirmPasswordController.text = 'password123';

      await controller.onRegister();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, equals('Email sudah terdaftar.'));
    });

    test('onRegister student success handles auto-login and updates state', () async {
      final student = StudentResponseModel(
        id: 1,
        nis: null,
        nisn: null,
        grade: null,
        createdAt: DateTime.parse('2026-03-08T10:00:00Z'),
        updatedAt: DateTime.parse('2026-03-08T10:00:00Z'),
      );

      when(
        () => mockRepository.registerStudent(
          email: any(named: 'email'),
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
          fullName: any(named: 'fullName'),
        ),
      ).thenAnswer((_) async => student);

      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => 'dummy_token');

      controller.onSelectedRole(UserRoles.siswa);
      controller.fullNameController.text = 'Siswa Test';
      controller.emailController.text = 'siswa@test.com';
      controller.passwordController.text = 'password123';
      controller.confirmPasswordController.text = 'password123';

      await controller.onRegister();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.registeredData.value, equals(student));
    });
  });
}
