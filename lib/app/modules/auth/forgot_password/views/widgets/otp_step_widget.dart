import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/modules/auth/forgot_password/controllers/forgot_password_controller.dart';
import 'package:pinput/pinput.dart';
import '../../../../../core/Dimens.dart';
import '../../../../../core/styles/colors/color_constant.dart';
class OtpStepWidget extends GetView<ForgotPasswordController> {
  const OtpStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PinTheme defaultPinTheme = PinTheme(
      width: 55,
      height: 60,
      textStyle: Theme.of(context).textTheme.headlineSmall,
      decoration: BoxDecoration(
        color: ColorConstant.background,
        borderRadius: BorderRadius.circular(Dimens.radius),
        border: Border.all(
          color: ColorConstant.grey,
          width: 1.5,
        ),
      ),
    );
    return Obx(() => Pinput(
        length: 6,
        controller: controller.otpController,
        focusNode: controller.otpFocusNode,
        showCursor: true,
        readOnly: controller.isLoading.value,
        onSubmitted: controller.onOtpCompleted,
        keyboardType: TextInputType.number,
        onCompleted: controller.onOtpCompleted,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyDecorationWith(
          border: Border.all(
            color: ColorConstant.primary,
            width: 2,
          ),
        ),
        submittedPinTheme: defaultPinTheme.copyDecorationWith(
          border: Border.all(
            color: ColorConstant.primary,
          ),
        ),
        errorPinTheme: defaultPinTheme.copyDecorationWith(
          border: Border.all(
            color: ColorConstant.redColor,
          ),
        ),
      ),
    );
  }
}
