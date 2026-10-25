import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/services/local/storage_service.dart';

class AccessibilityController extends GetxController {
  final RxBool showTextScaleSettings = false.obs;
  final RxBool showLanguageSettings = false.obs;
  final RxDouble textScale = 1.0.obs;
  final Rx<Locale> locale = const Locale('id', 'ID').obs;

  StorageService? get _storageService =>
      Get.isRegistered<StorageService>() ? Get.find<StorageService>() : null;

  @override
  void onInit() {
    super.onInit();
    final langCode = _storageService?.getLanguageCode();
    if (langCode == 'en') {
      locale.value = const Locale('en', 'US');
    } else {
      locale.value = const Locale('id', 'ID');
    }
  }

  void changeLanguage(Locale newLocale) {
    locale.value = newLocale;
    Get.updateLocale(newLocale);
    _storageService?.writeLanguageCode(newLocale.languageCode);
  }

  void increaseTextScale() {
    setTextScale(textScale.value + 0.1);
  }

  void decreaseTextScale() {
    setTextScale(textScale.value - 0.1);
  }

  void resetTextScale() {
    textScale.value = 1.0;
  }

  void setTextScale(double value) {
    textScale.value = value.clamp(0.8, 2.0).toDouble();
  }

  void openTextScaleSettings() {
    showTextScaleSettings.value = true;
  }

  void openLanguageSettings() {
    showLanguageSettings.value = true;
  }

  void backToSettings() {
    if (showTextScaleSettings.value) {
      showTextScaleSettings.value = false;
      return;
    }
    if (showLanguageSettings.value) {
      showLanguageSettings.value = false;
      return;
    }

    Get.back();
  }
}