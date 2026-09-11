import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/modules/auth/register_class/controllers/register_class_controller.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockRepository;
  late RegisterController controller;

  setUp(() {
    Get.testMode = true;
    mockRepository = MockClassroomRepository();
    controller = RegisterController(repository: mockRepository);
  });

  tearDown(() {
    Get.reset();
  });

  group('RegisterController (Join Class) Tests', () {
    test('Initial states are correct', () {
      expect(controller.isValid.value, isFalse);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
    });

    test('onChange validates code length minimum 7 characters', () {
      controller.codeController.text = '12345';
      controller.onChange('12345');
      expect(controller.isValid.value, isFalse);

      controller.codeController.text = 'NSG-482';
      controller.onChange('NSG-482');
      expect(controller.isValid.value, isTrue);
    });

    test('onRegister calls joinClassroom successfully', () async {
      controller.codeController.text = 'NSG-4821';
      when(() => mockRepository.joinClassroom(code: 'NSG-4821'))
          .thenAnswer((_) async {});

      await controller.onRegister();

      verify(() => mockRepository.joinClassroom(code: 'NSG-4821')).called(1);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
    });

    test('onRegister failure sets errorMessage and resets loading', () async {
      controller.codeController.text = 'INVALID';
      when(() => mockRepository.joinClassroom(code: 'INVALID'))
          .thenThrow(const ApiException(message: 'Kode kelas tidak ditemukan'));

      await controller.onRegister();

      expect(controller.errorMessage.value, equals('Kode kelas tidak ditemukan'));
      expect(controller.isLoading.value, isFalse);
    });
  });
}
