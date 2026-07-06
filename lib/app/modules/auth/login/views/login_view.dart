import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/auth_appbar.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';
import 'package:novasight_app/app/modules/auth/login/views/widgets/card_auth_form.dart';
import 'package:novasight_app/app/modules/auth/login/views/widgets/footer_auth_button.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.3;
    return Scaffold(
      appBar: AuthAppbar(icon: IconTxt.eye, title: "NovaSight", description: "Aplikasi Matematika Inklusif",height: appBarHeight,),
      body: Padding(
        padding: EdgeInsets.all(Dimens.innerPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Dimens.innerPadding,
          children: [
            CardAuthForm(
              child: Column(
                spacing: Dimens.spacePadding,
                children: [
                  CommonTextFormFieldWidget(
                      controller: controller.emailController,
                      hint: "Masukkan Email",
                      borderSideFocused: BorderSide(
                        color: ColorConstant.black,
                        width: 1.5
                      ),
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor
                      ),
                      borderSideEnable: BorderSide(
                        color: ColorConstant.grey,
                        width: 1.5
                    ),
                  ),
                  CommonTextFormFieldWidget(
                    controller: controller.passwordController,
                    hint: "Masukkan Password",
                    isPassword: true,
                    borderSideFocused: BorderSide(
                        color: ColorConstant.black,
                        width: 1.5
                    ),
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor
                    ),
                    borderSideEnable: BorderSide(
                        color: ColorConstant.grey,
                        width: 1.5
                    ),
                  ),
                  CommonButtonWidget(buttonName: "Login", onPressed: (){})
                ],
              ),
            ),
            FooterAuthButton()
          ],
        ),
      ),
    );
  }
}


