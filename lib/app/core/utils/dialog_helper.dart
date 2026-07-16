import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../common/common_dialog_widget.dart';

class DialogHelper {
  DialogHelper._();

  static Future<T?> show<T>({
    required String title,
    String? description,
    Color? colorDescription,
    Widget? icon,
    Widget? actions,
  }) {
    return Get.dialog<T>(
      CommonDialogWidget(
        title: title,
        description: description,
        icon: icon,
        colorDescription: colorDescription,
        actions: actions,
      ),
    );
  }
}