import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/validate_helper.dart';
import 'package:lydera_app/app/data/models/classroom_model.dart';

abstract class BaseCreateClassController extends GetxController {
  final TextEditingController nameClass = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxList<ClassroomTypeModel> classroomTypes = <ClassroomTypeModel>[].obs;
  final Rxn<ClassroomTypeModel> selectedClassroomType = Rxn<ClassroomTypeModel>();

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

  // Default UI selection & validation methods (inherited automatically!)
  void onSelectClassroomType(ClassroomTypeModel type) {
    selectedClassroomType.value = type;
    validateForm();
  }

  void onSelectGrade(int grade) {
    selectedGrade.value = (selectedGrade.value == grade) ? null : grade;
    validateForm();
  }

  void onSelectCity(CityResponseModel city) {
    if (city != selectedCity.value) {
      selectedSchool.value = null;
      schools.clear();
    }
    selectedCity.value = city;
    loadSchools(city.id);
    validateForm();
  }

  void onSelectSchool(SchoolResponseModel school) {
    selectedSchool.value = school;
    validateForm();
  }

  void onChange(String _) {
    validateForm();
  }

  void validateForm() {
    isValid.value =
        ValidateHelper.isNormalValidateBool(nameClass.text) &&
            selectedClassroomType.value != null &&
            selectedGrade.value != null &&
            selectedSchool.value != null;
  }

  Future<void> retryLoadInitialData();
  Future<void> loadSchools(int cityId);
  Future<void> onCreateClass();

  @override
  void onClose() {
    nameClass.dispose();
    super.onClose();
  }
}