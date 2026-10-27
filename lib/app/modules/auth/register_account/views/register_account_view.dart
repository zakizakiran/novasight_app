import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/constants/app_string_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/routes/app_pages.dart';
import '../../../../common/common_button_widget.dart';
import '../../../../common/common_card_widget.dart';
import '../../../../common/common_text_form_field_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/validate_helper.dart';
import '../../login/views/widgets/footer_auth_button.dart';
import '../../widgets/auth_appbar.dart';
import '../../widgets/role_switch_widget.dart';
import '../../widgets/valid_icon_field_widget.dart';
import '../controllers/register_account_controller.dart';

class RegisterAccountView extends GetView<RegisterAccountController> {
  const RegisterAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthAppbar(
              title: context.l10n.registerAccount,
              description: "Bergabung sebagai ke ${AppStrings.nameApp}",
              height: appBarHeight,
            ),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                children: [
                  CommonCardWidget(
                    boxShadow: const [
                      BoxShadowConstant.authPrimary,
                      BoxShadowConstant.auth,
                    ],
                    margin: const EdgeInsets.only(top: Dimens.innerPadding),
                    child: Column(
                      spacing: Dimens.spacePadding,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => RoleSwitchWidget(
                            selectedRole: controller.selectedRole.value,
                            onChanged: controller.selectedRole.call,
                          ),
                        ),
                        Form(
                          key: controller.formKey,
                          child: Column(
                            spacing: Dimens.spacePadding,
                            children: [
                              Obx(
                                () => CommonTextFormFieldWidget(
                                  title: context.l10n.fullNameField,
                                  controller: controller.fullNameController,
                                  successColor: ColorConstant.green,
                                  hint: context.l10n.enterFullName,
                                  isReadOnly: controller.isLoading.value,
                                  onChanged: controller.onChange,
                                  validator: ValidateHelper.isNormalValidate(
                                    "Nama Lengkap",
                                  ),
                                  suffixIcon: ValidIconFieldWidget(
                                    isValid: controller.isValidFullName.value,
                                  ),
                                  borderSideFocused: const BorderSide(
                                    width: 1.5,
                                  ),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: ColorConstant.textGreyColor,
                                      ),
                                  borderSideEnable: const BorderSide(
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Obx(
                                () => CommonTextFormFieldWidget(
                                  title: context.l10n.emailField,
                                  successColor: ColorConstant.green,
                                  controller: controller.emailController,
                                  suffixIcon: ValidIconFieldWidget(
                                    isValid: controller.isValidEmail.value,
                                  ),
                                  hint: context.l10n.enterEmail,
                                  isReadOnly: controller.isLoading.value,
                                  onChanged: controller.onChange,
                                  validator: ValidateHelper.isEmailValidate(),
                                  borderSideFocused: const BorderSide(
                                    width: 1.5,
                                  ),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: ColorConstant.textGreyColor,
                                      ),
                                  borderSideEnable: const BorderSide(
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Obx(
                                () => CommonTextFormFieldWidget(
                                  controller: controller.passwordController,
                                  title: context.l10n.passwordField,
                                  successColor: ColorConstant.green,
                                  hint: context.l10n.enterPassword,
                                  isPassword: true,
                                  isReadOnly: controller.isLoading.value,
                                  onChanged: controller.onChange,
                                  validator:
                                      ValidateHelper.isPasswordValidate(),
                                  borderSideFocused: const BorderSide(
                                    width: 1.5,
                                  ),
                                  enableLinearPassword: true,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: ColorConstant.textGreyColor,
                                      ),
                                  borderSideEnable: const BorderSide(
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              Obx(
                                () => CommonTextFormFieldWidget(
                                  controller:
                                      controller.confirmPasswordController,
                                  title: context.l10n.confirmPasswordField,
                                  hint: context.l10n.enterConfirmPassword,
                                  successColor: ColorConstant.green,
                                  isPassword: true,
                                  isReadOnly: controller.isLoading.value,
                                  onChanged: controller.onChange,
                                  suffixIcon: ValidIconFieldWidget(
                                    isValid: controller
                                        .isValidConfirmationPassword
                                        .value,
                                  ),
                                  validator:
                                      ValidateHelper.isPasswordConfirmationValidate(
                                        controller.passwordController.text,
                                      ),
                                  borderSideFocused: const BorderSide(
                                    width: 1.5,
                                  ),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: ColorConstant.textGreyColor,
                                      ),
                                  borderSideEnable: const BorderSide(
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimens.spacePadding),
                        Obx(
                          () => CommonButtonWidget(
                            buttonWidth: double.infinity,
                            isLoading: controller.isLoading.value,
                            isValid: controller.isValid.value,
                            buttonName: context.l10n.createAccount,
                            onPressed: controller.onRegister,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.innerPadding),
                  FooterAuthButton(
                    title: context.l10n.signIn,
                    description: context.l10n.alreadyHaveAccount,
                    onClick: () {
                      Get.offNamed(Routes.LOGIN);
                    },
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
