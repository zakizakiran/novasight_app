import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/modules/auth/forgot_password/controllers/forgot_password_controller.dart';
import '../../../../../common/common_text_form_field_widget.dart';
import '../../../../../core/dimens.dart';
import '../../../../../core/styles/colors/color_constant.dart';
import '../../../../../core/utils/validate_helper.dart';
class EmailStepWidget extends GetView<ForgotPasswordController>{

  const EmailStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => CommonTextFormFieldWidget(
        controller: controller.emailController,
        hint: "Masukkan Email",
        isReadOnly: controller.isLoading.value,
        onChanged: controller.onChange,
        validator: ValidateHelper.isEmailValidate(),
        prefixIcon: const Center(
          widthFactor: 1,
          child: Icon(
            Icons.mail_outline_rounded,
            size: Dimens.iconMidSize,
            color: ColorConstant.textGreyColor,
          ),
        ),
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
    );
  }
}
