import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/core/utils/text_input_formatter.dart';

import '../../../../core/styles/box_shadow_style.dart';
import '../../widgets/auth_appbar.dart';
import '../../../../common/common_button_widget.dart';
import '../../../../common/common_text_form_field_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/icon_txt.dart';
import '../../../../core/utils/validate_helper.dart';
import '../../../../common/common_card_widget.dart';
import '../controllers/register_class_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthAppbar(icon: IconTxt.key, title: context.l10n.joinClass, description: context.l10n.enterClassCodeFromTeacher,height: appBarHeight,),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: CommonCardWidget(
                boxShadow: const [
                  BoxShadowConstant.authPrimary,
                  BoxShadowConstant.auth,
                ],
                margin: const EdgeInsets.only(top: Dimens.innerPadding),
                child: Column(
                  spacing: Dimens.spacePadding,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo Faris 👋",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "Satu langkah lagi untuk bergabung ke kelasmu.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor
                      ),
                    ),
                    Text(
                      context.l10n.classCode,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      context.l10n.askTeacherForCode,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor
                      ),
                    ),
                    Obx(()
                    => CommonTextFormFieldWidget(
                      controller: controller.codeController,
                      hint: context.l10n.enterClassCode,
                      textAlign: TextAlign.center,
                      isReadOnly: controller.isLoading.value,
                      textStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ColorConstant.primary,
                          letterSpacing: 6
                      ),
                      onChanged: controller.onChange,
                      validator: ValidateHelper.isNormalValidate("Kode Kelas"),
                      inputFormatters: [
                        ClassCodeFormatter()
                      ],
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor
                      ),
                      successColor: ColorConstant.primary,
                      focusedColor: ColorConstant.primary,
                      borderSideFocused: const BorderSide(
                          width: 2
                      ),
                      borderSideEnable: const BorderSide(
                          width: 2
                      ),
                    )
                    ),
                    Obx(
                            () => CommonButtonWidget(
                            buttonWidth: double.infinity,
                            isLoading: controller.isLoading.value,
                            isValid: controller.isValid.value,
                            buttonName: context.l10n.joinClassButton,
                            onPressed: controller.onRegister
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
