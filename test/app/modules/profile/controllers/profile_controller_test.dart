import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lydera_app/app/core/utils/user_roles.dart';
import 'package:lydera_app/app/data/models/user_model.dart';
import 'package:lydera_app/app/data/repositories/auth_repository.dart';
import 'package:lydera_app/app/data/services/local/storage_service.dart';
import 'package:lydera_app/app/modules/profile/controllers/profile_controller.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockStorageService extends Mock implements StorageService {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepo;
  late MockStorageService mockStorage;

  final testNow = DateTime.parse('2026-09-14T00:00:00.000Z');

  final mockProfile = ProfileResponseModel(
    id: 1,
    email: 'siswa@example.com',
    student: StudentResponseModel(
      id: 5,
      nis: '10125289',
      nisn: '0056789123',
      grade: 10,
      createdAt: testNow,
      updatedAt: testNow,
    ),
  );

  setUp(() {
    Get.reset();
    mockAuthRepo = MockAuthRepository();
    mockStorage = MockStorageService();

    when(() => mockAuthRepo.storageService).thenReturn(mockStorage);
    when(() => mockStorage.getRole()).thenReturn(UserRoles.siswa);
    when(() => mockStorage.getUserEmail()).thenReturn('cached@example.com');
    when(() => mockStorage.getUserName()).thenReturn('Ahmad Siswa');
    when(() => mockStorage.getClassName()).thenReturn('SMA/SMK • Kelas 10');
    when(() => mockStorage.writeUserEmail(any())).thenAnswer((_) async {});
    when(() => mockStorage.clearAll()).thenAnswer((_) async {});

    when(() => mockAuthRepo.getProfile()).thenAnswer((_) async => mockProfile);
  });

  group('ProfileController Tests', () {
    test('init reads cache and loadProfile updates profile observables', () async {
      final controller = ProfileController(repository: mockAuthRepo);

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.role.value, equals(UserRoles.siswa));
      expect(controller.className.value, equals('SMA/SMK • Kelas 10'));
      expect(controller.email.value, equals('siswa@example.com'));
      expect(controller.name.value, equals('Ahmad Siswa'));
      expect(controller.profile.value?.student?.nis, equals('10125289'));
      expect(controller.profile.value?.student?.grade, equals(10));

      verify(() => mockAuthRepo.getProfile()).called(1);
    });

    test('loadProfile failure preserves cached email and name', () async {
      when(() => mockAuthRepo.getProfile())
          .thenThrow(Exception('Network error'));

      final controller = ProfileController(repository: mockAuthRepo);

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.email.value, equals('cached@example.com'));
      expect(controller.name.value, equals('Ahmad Siswa'));
      expect(controller.isLoading.value, isFalse);
    });
  });
}
