import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/modules/auth/forgot_password/controllers/forgot_password_controller.dart';
import 'package:novasight_app/app/modules/auth/widgets/valid_icon_field_widget.dart';

import '../../../../../common/common_text_form_field_widget.dart';
import '../../../../../core/Dimens.dart';
import '../../../../../core/styles/colors/color_constant.dart';
import '../../../../../core/utils/validate_helper.dart';
class ResetPasswordWidget extends GetView<ForgotPasswordController> {
  const ResetPasswordWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        Obx(() => CommonTextFormFieldWidget(
          controller: controller.passwordController,
          title: "Kata Sandi *",
          successColor: ColorConstant.green,
          hint: "Masukkan Katas Sandi",
          isPassword: true,
          isReadOnly: controller.isLoading.value,
          onChanged: controller.onChange,
          validator: ValidateHelper.isPasswordValidate(),
          borderSideFocused: const BorderSide(
              width: 1.5
          ),
          enableLinearPassword: true,
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstant.textGreyColor
          ),
          borderSideEnable: const BorderSide(
              width: 1.5
          ),
        ),
        ),
        Obx(() => CommonTextFormFieldWidget(
          controller: controller.confirmPasswordController,
          title: "Konfirmasi Kata Sandi *",
          hint: "Masukkan Ulang Katas Sandi",
          successColor: ColorConstant.green,
          isPassword: true,
          isReadOnly: controller.isLoading.value,
          onChanged: controller.onChange,
          suffixIcon: ValidIconFieldWidget(isValid: controller.isValid.value),
          validator: ValidateHelper.isPasswordConfirmationValidate(controller.passwordController.text),
          borderSideFocused: const BorderSide(
              width: 1.5
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstant.textGreyColor
          ),
          borderSideEnable: const BorderSide(
              width: 1.5
          ),
        ),
        ),
      ],
    );
  }
}
