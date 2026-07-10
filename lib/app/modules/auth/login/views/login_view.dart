import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/modules/auth/widgets/auth_appbar.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/modules/auth/login/views/widgets/card_auth_form.dart';
import 'package:novasight_app/app/modules/auth/login/views/widgets/role_switch_widget.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthAppbar(icon: IconTxt.eye, title: "NovaSight", description: "Aplikasi Matematika Inklusif",height: appBarHeight,),
            Padding(
              padding: EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Dimens.innerPadding,
                children: [
                  CardAuthForm(
                    child: Column(
                      spacing: Dimens.spacePadding,
                      children: [
                        Text(
                          "Selamat Datang",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(
                          "Masuk untuk lanjutkan",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.textGreyColor
                          ),
                        ),
                        Obx(
                            () => RoleSwitchWidget(
                                selectedRole: controller.selectedRole.value,
                                onChanged: controller.selectedRole.call
                            ),
                        ),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              CommonTextFormFieldWidget(
                                title: "Email",
                                controller: controller.emailController,
                                hint: "Masukkan Email",
                                isReadOnly: controller.isLoading.value,
                                onChanged: controller.onChange,
                                validator: ValidateHelper.isEmailValidate(),
                                prefixIcon: SvgPicture.asset(
                                  SvgConstant.iconEmail,
                                  width: Dimens.iconRegularSize,
                                  height: Dimens.iconRegularSize,
                                ),

                                borderSideFocused: BorderSide(
                                    width: 1.5
                                ),
                                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ColorConstant.textGreyColor
                                ),
                                borderSideEnable: BorderSide(
                                    width: 1.5
                                ),
                              ),
                              CommonTextFormFieldWidget(
                                controller: controller.passwordController,
                                title: "Password",
                                hint: "Masukkan Password",
                                isPassword: true,
                                isReadOnly: controller.isLoading.value,
                                onChanged: controller.onChange,
                                validator: ValidateHelper.isPasswordValidate(),
                                prefixIcon: Center(
                                  widthFactor: 1,
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    IconTxt.lock,
                                    style: TextStyle(
                                        fontSize: Dimens.iconRegularSize
                                    ),
                                  ),
                                ),
                                borderSideFocused: BorderSide(
                                    width: 1.5
                                ),
                                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ColorConstant.textGreyColor
                                ),
                                borderSideEnable: BorderSide(
                                    width: 1.5
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Lupa kata sandi?",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColorConstant.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                            () => CommonButtonWidget(
                                isLoading: controller.isLoading.value,
                                isValid: controller.isValid.value,
                                buttonName: "Login",
                                onPressed: controller.onLogin
                            )
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


