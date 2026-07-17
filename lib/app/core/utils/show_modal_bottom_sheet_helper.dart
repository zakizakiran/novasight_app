import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_show_modal_bottom_sheet.dart';

class ShowModalBottomSheetHelper {
  static void showCustomBottomSheet(
      Widget child
      ){
    Get.bottomSheet(
      CommonShowModalBottomSheet(child: child),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}