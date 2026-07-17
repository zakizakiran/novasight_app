
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/data/model/city_model.dart';
import 'package:novasight_app/app/data/model/class_model.dart';

import '../../../../data/model/school_model.dart';
import '../../../../routes/app_pages.dart';

class CreateClassController extends GetxController {
  final TextEditingController nameClass = TextEditingController();
  final TextEditingController nameLecture = TextEditingController();
  final RxList<ClassGradeType> listClass = ClassGradeType.values.obs;
  final RxList<ClassGradeType> selectedListClass = <ClassGradeType>[].obs;
  final RxList<CityModel> cities = listCities.obs;
  final Rxn<CityModel> selectedCity = Rxn<CityModel>();
  final RxList<SchoolModel> schools = RxList<SchoolModel>();
  final Rxn<SchoolModel> selectedSchool = Rxn<SchoolModel>();

  final isLoading = false.obs;
  final isValid = false.obs;
  final formKey = GlobalKey<FormState>();

  void onSelectCity(CityModel city){
    if(city != selectedCity.value){
      selectedSchool.value = null;
    }
    selectedCity.value = city;
    schools.value = listSchool.where((s) => s.cityId == city.id).toList();
    onChange(city.name);
  }

  void onSelectSchool(SchoolModel school){
    selectedSchool.value = school;
    onChange(school.name);
  }

  void onSelectGrade(ClassGradeType grade){
    if (selectedListClass.contains(grade)) {
      selectedListClass.remove(grade);
    } else {
      selectedListClass.add(grade);
    }
    onChange(grade.name);
  }

  void onChange(String _){
    isValid.value =
            ValidateHelper.isNormalValidateBool(nameClass.text) &&
            ValidateHelper.isNormalValidateBool(nameLecture.text) &&
            selectedSchool.value != null &&
            selectedListClass.isNotEmpty;
  }


  void onCreateClass(){
    Get.offNamed(Routes.SUCCESS_CREATE_CLASS);
  }

  @override
  void onClose() {
    nameClass.dispose();
    nameLecture.dispose();
    super.onClose();
  }
}
