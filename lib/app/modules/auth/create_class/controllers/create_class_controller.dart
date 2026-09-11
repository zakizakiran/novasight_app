import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/errors/api_exception.dart';
import 'package:novasight_app/app/core/utils/snackbar_helper.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/data/repositories/classroom_repository.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

class CreateClassController extends GetxController {
  final ClassroomRepository repository;

  CreateClassController({required this.repository});

  final TextEditingController nameClass = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxList<ClassroomTypeModel> classroomTypes = <ClassroomTypeModel>[].obs;
  final Rxn<ClassroomTypeModel> selectedClassroomType =
      Rxn<ClassroomTypeModel>();

  final RxList<int> gradeOptions = <int>[10, 11, 12].obs;
  final Rxn<int> selectedGrade = Rxn<int>();

  final RxList<CityResponseModel> cities = <CityResponseModel>[].obs;
  final Rxn<CityResponseModel> selectedCity = Rxn<CityResponseModel>();

  final RxList<SchoolResponseModel> schools = <SchoolResponseModel>[].obs;
  final Rxn<SchoolResponseModel> selectedSchool = Rxn<SchoolResponseModel>();

  final RxBool isLoading = false.obs;
  final RxBool isValid = false.obs;
  final RxBool isLoadingData = false.obs;
  final RxBool isLoadingSchools = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> retryLoadInitialData() => _loadInitialData();

  Future<void> _loadInitialData() async {
    try {
      isLoadingData.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        repository.getClassroomTypes(),
        repository.getCities(),
      ]);

      classroomTypes.value = results[0] as List<ClassroomTypeModel>;
      cities.value = results[1] as List<CityResponseModel>;
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(title: "Gagal Memuat Data", message: e.message);
    } catch (e) {
      errorMessage.value = 'Gagal memuat data awal.';
      SnackbarHelper.showError(
        title: "Gagal Memuat Data",
        message: 'Terjadi kesalahan saat memuat data. Silakan coba lagi.',
      );
    } finally {
      isLoadingData.value = false;
    }
  }

  void onSelectClassroomType(ClassroomTypeModel type) {
    selectedClassroomType.value = type;
    _validateForm();
  }

  void onSelectGrade(int grade) {
    if (selectedGrade.value == grade) {
      selectedGrade.value = null;
    } else {
      selectedGrade.value = grade;
    }
    _validateForm();
  }

  void onSelectCity(CityResponseModel city) {
    if (city != selectedCity.value) {
      selectedSchool.value = null;
      schools.clear();
    }
    selectedCity.value = city;
    _loadSchools(city.id);
    _validateForm();
  }

  Future<void> _loadSchools(int cityId) async {
    try {
      isLoadingSchools.value = true;
      final result = await repository.getSchoolsByCity(cityId);
      schools.value = result;
    } on ApiException catch (e) {
      SnackbarHelper.showError(
        title: "Gagal Memuat Sekolah",
        message: e.message,
      );
    } catch (_) {
      SnackbarHelper.showError(
        title: "Gagal Memuat Sekolah",
        message: 'Terjadi kesalahan saat memuat daftar sekolah.',
      );
    } finally {
      isLoadingSchools.value = false;
    }
  }

  void onSelectSchool(SchoolResponseModel school) {
    selectedSchool.value = school;
    _validateForm();
  }

  void onChange(String _) {
    _validateForm();
  }

  void _validateForm() {
    isValid.value =
        ValidateHelper.isNormalValidateBool(nameClass.text) &&
        selectedClassroomType.value != null &&
        selectedGrade.value != null &&
        selectedSchool.value != null;
  }

  Future<void> onCreateClass() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }
    if (!isValid.value) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final createdClass = await repository.createClassroom(
        name: nameClass.text.trim(),
        classroomTypeId: selectedClassroomType.value!.id,
        schoolId: selectedSchool.value!.id,
        grade: selectedGrade.value!,
      );

      try {
        if (Get.isRegistered<StorageService>()) {
          final storage = Get.find<StorageService>();
          await storage.writeClassCode(createdClass.code);
          await storage.writeClassName(createdClass.name);
        }
      } catch (_) {}

      SnackbarHelper.showSuccess(
        title: "Kelas Berhasil Dibuat!",
        message: "Kelas baru telah berhasil dibuat.",
      );

      Get.offNamed(Routes.SUCCESS_CREATE_CLASS, arguments: createdClass.code);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      SnackbarHelper.showError(
        title: "Gagal Membuat Kelas",
        message: e.message,
      );
    } catch (e) {
      errorMessage.value = 'Terjadi kesalahan tidak terduga.';
      SnackbarHelper.showError(
        title: "Gagal Membuat Kelas",
        message: 'Terjadi kesalahan tidak terduga. Silakan coba lagi.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameClass.dispose();
    super.onClose();
  }
}
