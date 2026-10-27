import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/styles/svg/svg_constant.dart';

class SnackbarHelper {

  static void showSuccess({
    required String title,
    required String message,
    int durationMilliseconds = 2300,
  }) {
    if (Get.context == null) return;
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      backgroundColor: ColorConstant.informationColor,
      borderRadius: Dimens.radius,
      margin: const EdgeInsets.all(Dimens.innerPadding),
      snackPosition: SnackPosition.TOP,
      duration: Duration(milliseconds: durationMilliseconds),
      messageText: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint){
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: Dimens.spacePadding,
            children: [
              Container(
                padding: const EdgeInsets.all(Dimens.spacePadding),
                decoration: const BoxDecoration(
                    color: ColorConstant.lightGreen,
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.circle))
                ),
                child: SvgPicture.asset(
                  SvgConstant.iconCheck,
                  width: Dimens.iconMidSize,
                  height: Dimens.iconMidSize,
                  colorFilter: const ColorFilter.mode(
                    ColorConstant.green,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.snackbarDescColor,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.closeCurrentSnackbar();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: Dimens.iconMidSize,
                  color: ColorConstant.snackbarDescColor,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  static void showError({
    required String title,
    required String message,
    int durationMilliseconds = 3000,
  }) {
    if (Get.context == null) return;
    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      backgroundColor: ColorConstant.informationColor,
      borderRadius: Dimens.radius,
      margin: const EdgeInsets.all(Dimens.innerPadding),
      snackPosition: SnackPosition.TOP,
      duration: Duration(milliseconds: durationMilliseconds),
      messageText: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: Dimens.spacePadding,
            children: [
              Container(
                padding: const EdgeInsets.all(Dimens.spacePadding),
                decoration: const BoxDecoration(
                  color: ColorConstant.lightRedColor,
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.circle)),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: Dimens.iconMidSize,
                  color: ColorConstant.redColor,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.snackbarDescColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.closeCurrentSnackbar();
                },
                child: const Icon(
                  Icons.close_rounded,
                  size: Dimens.iconMidSize,
                  color: ColorConstant.snackbarDescColor,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}