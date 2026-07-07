import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/text_input_formatter.dart';

import '../../../../common/auth_appbar.dart';
import '../../../../common/common_button_widget.dart';
import '../../../../common/common_text_form_field_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/icon_txt.dart';
import '../../../../core/utils/validate_helper.dart';
import '../../login/views/widgets/card_auth_form.dart';
import '../controllers/register_controller.dart';

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
            AuthAppbar(icon: IconTxt.key, title: "Masuk ke Kelas", description: "Masukkan kode kelas dari gurumu",height: appBarHeight,),
            Padding(
              padding: EdgeInsets.all(Dimens.innerPadding),
              child: CardAuthForm(
                child: Column(
                  spacing: Dimens.spacePadding,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo Shade 👋",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "Satu langkah lagi untuk bergabung ke kelasmu.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor
                      ),
                    ),
                    Text(
                      "Kode Kelas",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      "Minta kode ini dari gurumu",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor
                      ),
                    ),
                    Obx(()
                    => CommonTextFormFieldWidget(
                      controller: controller.codeController,
                      hint: "Masukkan Kode Kelas",
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
                      borderSideFocused: BorderSide(
                          width: 2
                      ),
                      borderSideEnable: BorderSide(
                          width: 2
                      ),
                    )
                    ),
                    Obx(
                            () => CommonButtonWidget(
                            isLoading: controller.isLoading.value,
                            isValid: controller.isValid.value,
                            buttonName: "Bergabung ke kelas",
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
