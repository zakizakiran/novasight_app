import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/modules/auth/create_class/controllers/create_class_controller.dart';

class MockClassroomRepository extends Mock implements ClassroomRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockClassroomRepository mockRepository;
  late CreateClassController controller;

  final testNow = DateTime.now();

  final mockTypes = [
    ClassroomTypeModel(
      id: 1,
      name: 'Matematika',
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  final mockCities = [
    CityResponseModel(
      id: 10,
      name: 'Jakarta Selatan',
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  final mockSchools = [
    SchoolResponseModel(
      id: 100,
      cityId: 10,
      name: 'SMAN 28 Jakarta',
      createdAt: testNow,
      updatedAt: testNow,
    ),
  ];

  setUp(() {
    Get.testMode = true;
    mockRepository = MockClassroomRepository();

    when(() => mockRepository.getClassroomTypes())
        .thenAnswer((_) async => mockTypes);
    when(() => mockRepository.getCities())
        .thenAnswer((_) async => mockCities);
    when(() => mockRepository.getSchoolsByCity(10))
        .thenAnswer((_) async => mockSchools);

    controller = CreateClassController(repository: mockRepository);
  });

  tearDown(() {
    Get.reset();
  });

  group('CreateClassController Tests', () {
    test('Initial state and data loading success', () async {
      expect(controller.gradeOptions, equals([10, 11, 12]));
      expect(controller.isValid.value, isFalse);

      controller.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.classroomTypes.length, equals(1));
      expect(controller.classroomTypes.first.name, equals('Matematika'));
      expect(controller.cities.length, equals(1));
      expect(controller.cities.first.name, equals('Jakarta Selatan'));
      expect(controller.isLoadingData.value, isFalse);
    });

    test('Initial data loading failure sets errorMessage', () async {
      when(() => mockRepository.getClassroomTypes())
          .thenThrow(const ApiException(message: 'Gagal memuat tipe kelas'));

      final failController = CreateClassController(repository: mockRepository);
      failController.onInit();
      await Future.delayed(const Duration(milliseconds: 50));

      expect(failController.errorMessage.value, isNotEmpty);
      expect(failController.isLoadingData.value, isFalse);
    });

    test('onSelectClassroomType updates selection and triggers validation', () {
      controller.onSelectClassroomType(mockTypes.first);
      expect(controller.selectedClassroomType.value, equals(mockTypes.first));
      expect(controller.isValid.value, isFalse);
    });

    test('onSelectGrade updates and toggles grade', () {
      controller.onSelectGrade(10);
      expect(controller.selectedGrade.value, equals(10));

      // Toggling same grade deselects
      controller.onSelectGrade(10);
      expect(controller.selectedGrade.value, isNull);
    });

    test('onSelectCity loads schools and resets selectedSchool', () async {
      controller.selectedSchool.value = mockSchools.first;

      controller.onSelectCity(mockCities.first);
      expect(controller.selectedCity.value, equals(mockCities.first));
      expect(controller.selectedSchool.value, isNull);

      await Future.delayed(const Duration(milliseconds: 50));
      expect(controller.schools.length, equals(1));
      expect(controller.schools.first.name, equals('SMAN 28 Jakarta'));
      verify(() => mockRepository.getSchoolsByCity(10)).called(1);
    });

    test('Full form validation becomes valid only when all 4 fields are set', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      expect(controller.isValid.value, isFalse);

      // 1. Fill Name
      controller.nameClass.text = 'Kelas 10 MIPA 1';
      controller.onChange('Kelas 10 MIPA 1');
      expect(controller.isValid.value, isFalse);

      // 2. Select Type
      controller.onSelectClassroomType(mockTypes.first);
      expect(controller.isValid.value, isFalse);

      // 3. Select Grade
      controller.onSelectGrade(10);
      expect(controller.isValid.value, isFalse);

      // 4. Select City & School
      controller.onSelectCity(mockCities.first);
      await Future.delayed(const Duration(milliseconds: 50));
      controller.onSelectSchool(mockSchools.first);

      // Now all 4 are fulfilled
      expect(controller.isValid.value, isTrue);
    });

    test('onCreateClass success calls repository and resets loading', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      // Fill valid form
      controller.nameClass.text = 'Kelas 10 MIPA 1';
      controller.onSelectClassroomType(mockTypes.first);
      controller.onSelectGrade(10);
      controller.onSelectCity(mockCities.first);
      await Future.delayed(const Duration(milliseconds: 50));
      controller.onSelectSchool(mockSchools.first);

      final createdResponse = ClassroomResponseModel(
        id: 1,
        teacherId: 5,
        schoolId: 100,
        name: 'Kelas 10 MIPA 1',
        code: 'NSG-9999',
        grade: 10,
        classroomType: mockTypes.first,
        createdAt: testNow,
        updatedAt: testNow,
      );

      when(() => mockRepository.createClassroom(
            name: any(named: 'name'),
            classroomTypeId: any(named: 'classroomTypeId'),
            schoolId: any(named: 'schoolId'),
            grade: any(named: 'grade'),
          )).thenAnswer((_) async => createdResponse);

      await controller.onCreateClass();

      verify(() => mockRepository.createClassroom(
            name: 'Kelas 10 MIPA 1',
            classroomTypeId: 1,
            schoolId: 100,
            grade: 10,
          )).called(1);

      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isEmpty);
    });

    test('onCreateClass failure updates errorMessage and resets loading', () async {
      await Future.delayed(const Duration(milliseconds: 50));

      // Fill valid form
      controller.nameClass.text = 'Kelas 10 MIPA 1';
      controller.onSelectClassroomType(mockTypes.first);
      controller.onSelectGrade(10);
      controller.onSelectCity(mockCities.first);
      await Future.delayed(const Duration(milliseconds: 50));
      controller.onSelectSchool(mockSchools.first);

      when(() => mockRepository.createClassroom(
            name: any(named: 'name'),
            classroomTypeId: any(named: 'classroomTypeId'),
            schoolId: any(named: 'schoolId'),
            grade: any(named: 'grade'),
          )).thenThrow(const ApiException(message: 'Nama kelas sudah digunakan'));

      await controller.onCreateClass();

      expect(controller.errorMessage.value, equals('Nama kelas sudah digunakan'));
      expect(controller.isLoading.value, isFalse);
    });
  });
}
