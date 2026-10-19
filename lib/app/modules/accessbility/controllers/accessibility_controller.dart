import 'package:get/get.dart';

class AccessibilityController extends GetxController {
  final RxBool showTextScaleSettings = false.obs;
  final RxDouble textScale = 1.0.obs;

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

  void backToSettings() {
    if(showTextScaleSettings.value){
      showTextScaleSettings.value = false;
      return;
    }

    Get.back();
  }
}