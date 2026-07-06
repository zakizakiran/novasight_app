import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              'LoginView is working',
              style: TextStyle(fontSize: 20),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: BorderRadius.circular(Dimens.radius),
              ),
              padding: EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                spacing: 10,
                children: [
                  CommonTextFormFieldWidget(
                      controller: controller.fullNameController,
                      hint: "Enter your name",
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
            )
          ],
        ),
      ),
    );
  }
}


