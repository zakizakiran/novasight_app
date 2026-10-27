import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/auth/forgot_password/views/widgets/email_step_widget.dart';
import 'package:lydera_app/app/modules/auth/forgot_password/views/widgets/otp_step_widget.dart';
import 'package:lydera_app/app/modules/auth/forgot_password/views/widgets/reset_password_widget.dart';
import 'package:lydera_app/app/modules/auth/widgets/step_indicator_widget.dart';

import '../../../../common/common_button_widget.dart';
import '../../../../common/common_card_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/icon_txt.dart';
import '../../widgets/auth_appbar.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    print("LoginView controllers: ${controller.hashCode}");
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => AuthAppbar(icon: IconTxt.lock, title: context.l10n.forgotPassword, description: controller.step.value.description,height: appBarHeight,
                  top:  StepIndicatorWidget(step: controller.step.value.step,maxStep: 3,)),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: Dimens.innerPadding,
                children: [
                  CommonCardWidget(
                    boxShadow: const [
                      BoxShadowConstant.authPrimary,
                      BoxShadowConstant.auth,
                    ],
                    child: Column(
                      spacing: Dimens.spacePadding,
                      children: [
                        Form(
                          key: controller.formKey,
                          child: Obx(() {
                            switch(controller.step.value){
                              case ForgotPasswordStep.email:
                                return const EmailStepWidget();
                              case ForgotPasswordStep.otp:
                                return const OtpStepWidget();
                              case ForgotPasswordStep.resetPassword:
                                return const ResetPasswordWidget();
                            }
                          }),
                        ),
                        Obx(() => CommonButtonWidget(
                                buttonWidth: double.infinity,
                                isLoading: controller.isLoading.value,
                                isValid: controller.isValid.value,
                                buttonName: controller.step.value.title,
                                onPressed: controller.nextStep
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
