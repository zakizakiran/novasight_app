import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/modules/auth/forgot_password/controllers/forgot_password_controller.dart';
import 'package:novasight_app/app/modules/auth/login/views/widgets/footer_auth_button.dart';
import 'package:novasight_app/app/modules/auth/widgets/auth_appbar.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/modules/auth/widgets/role_switch_widget.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

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
            AuthAppbar(icon: IconTxt.eye, title: "Lydera", description: "Aplikasi Matematika Inklusif",height: appBarHeight,showBack: false,),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Dimens.innerPadding,
                children: [
                  CommonCardWidget(
                    margin: const EdgeInsets.only(top: Dimens.innerPadding),
                    boxShadow: const [
                      BoxShadowConstant.authPrimary,
                      BoxShadowConstant.auth,
                    ],
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
                            spacing: Dimens.spacePadding,
                            children: [
                              Obx(() => CommonTextFormFieldWidget(
                                  title: "Email",
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
                              ),
                              Obx(() => CommonTextFormFieldWidget(
                                  controller: controller.passwordController,
                                  title: "Kata Sandi",
                                  hint: "Masukkan Kata Sandi",
                                  isPassword: true,
                                  isReadOnly: controller.isLoading.value,
                                  onChanged: controller.onChange,
                                  validator: ValidateHelper.isPasswordValidate(),
                                  prefixIcon: const Center(
                                    widthFactor: 1,
                                    child: Icon(
                                      Icons.lock_outline_rounded,
                                      color: ColorConstant.textGreyColor,
                                      size: Dimens.iconMidSize,
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
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                  Routes.FORGOT_PASSWORD,
                                  arguments: ForgotPasswordStep.email
                              );
                            },
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
                                buttonWidth: double.infinity,
                                isLoading: controller.isLoading.value,
                                isValid: controller.isValid.value,
                                buttonName: "Masuk",
                                onPressed: controller.onLogin
                            )
                        )
                      ],
                    ),
                  ),
                  FooterAuthButton(
                      title: "Daftar",
                      description: "Belum punya akun? ",
                      onClick: (){
                        Get.toNamed(Routes.REGISTER_ACCOUNT);
                      }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


