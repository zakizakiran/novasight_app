import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/modules/auth/success_create_class/views/widgets/code_class_widget.dart';
import 'package:novasight_app/app/modules/auth/success_create_class/views/widgets/copy_code_widget.dart';
import 'package:novasight_app/app/modules/auth/success_create_class/views/widgets/information_student_widget.dart';

import '../../../../common/common_button_widget.dart';
import '../../../../common/common_card_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/svg/svg_constant.dart';
import '../../create_class/views/widgets/step_indicator_widget.dart';
import '../../widgets/auth_appbar.dart';
import '../controllers/success_create_class_controller.dart';

class SuccessCreateClassView extends GetView<SuccessCreateClassController> {
  const SuccessCreateClassView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.35;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthAppbar(iconSvg: SvgConstant.iconCheck, title: "Kelas Berhasil Dibuat!", description: "Bagikan kode dibawah ke siswamu", height: appBarHeight,
              top: const StepIndicatorWidget(step: 2),),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                spacing: Dimens.spacePadding,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonCardWidget(
                    boxShadow: const [
                      BoxShadowConstant.authSpecialCard,
                    ],
                    margin: const EdgeInsets.only(top: Dimens.innerPadding),
                    child: CodeClassWidget(code: controller.code.value),
                  ),
                  CopyCodeWidget(copyCode: controller.onCopyCode),
                  InformationStudentWidget(code: controller.code.value),
                  CommonButtonWidget(
                    buttonName: "Bagikan Kode",
                    isValid: true,
                    boxShadows: const [],
                    buttonWidth: double.infinity,
                    buttonColor: ColorConstant.white,
                    border: const BorderSide(
                      color: ColorConstant.primary,
                      width: 1.5
                    ),
                    onPressed: controller.onManageClass,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Mulai Kelola Kelas",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.primary
                          ),
                        ),
                        const SizedBox(width: Dimens.spaceMediumPadding),
                        const Icon(Icons.arrow_forward, color: ColorConstant.primary, size: Dimens.iconRegularSize,),
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
