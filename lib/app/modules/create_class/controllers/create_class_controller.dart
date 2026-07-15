import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/model/city_model.dart';
import 'package:novasight_app/app/data/model/class_model.dart';

class CreateClassController extends GetxController {
  final TextEditingController nameClass = TextEditingController();
  final TextEditingController nameLecture = TextEditingController();
  final RxList<ClassType> listClass = <ClassType>[].obs;
  final RxList<CityModel> cities = <CityModel>[].obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
