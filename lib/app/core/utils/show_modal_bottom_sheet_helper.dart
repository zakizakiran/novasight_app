import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_show_modal_bottom_sheet.dart';

class ShowModalBottomSheetHelper {
  static void showCustomBottomSheet(
      Widget child, {
        double? padding,
      }) {
    Get.bottomSheet(
      CommonShowModalBottomSheet(
        padding: padding,
        child: child,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}