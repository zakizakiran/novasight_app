import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/repositories/auth_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/modules/auth/login/controllers/login_controller.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepository;
  late MockStorageService mockStorageService;
  late LoginController controller;

  setUpAll(() {
    registerFallbackValue(UserRoles.guru);
  });

  setUp(() {
    Get.testMode = true;
    mockRepository = MockAuthRepository();
    mockStorageService = MockStorageService();
    when(() => mockRepository.storageService).thenReturn(mockStorageService);
    when(() => mockStorageService.getUserName()).thenReturn('Budi');

    controller = LoginController(repository: mockRepository);
  });

  group('LoginController Tests', () {
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

    test('onChange validates email and password properly', () {
      controller.emailController.text = 'invalid-email';
      controller.passwordController.text = 'short';
      controller.onChange('');
      expect(controller.isValid.value, isFalse);

      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'password123';
      controller.onChange('');
      expect(controller.isValid.value, isTrue);
    });

    test('onLogin failure updates errorMessage and resets isLoading', () async {
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          role: any(named: 'role'),
        ),
      ).thenThrow(const ApiException(message: 'Email atau kata sandi tidak valid.'));

      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'password123';

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);

      // Trigger login
      final future = controller.onLogin();
      await future;

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, equals('Email atau kata sandi tidak valid.'));
    });

    test('onLogin success stores tokenData and resets isLoading', () async {
      Get.testMode = true;
      when(
        () => mockRepository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
          role: any(named: 'role'),
        ),
      ).thenAnswer((_) async => 'jwt_success_token');

      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'password123';

      await controller.onLogin();

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
      expect(controller.tokenData.value, equals('jwt_success_token'));
    });
  });
}
