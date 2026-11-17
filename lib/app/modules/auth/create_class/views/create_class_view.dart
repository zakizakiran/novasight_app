import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/auth/create_class/views/widgets/add_class_widget.dart';
import 'package:lydera_app/app/modules/auth/widgets/step_indicator_widget.dart';
import '../../../../common/common_card_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/icon_txt.dart';
import '../../widgets/auth_appbar.dart';
import '../controllers/create_class_controller.dart';

class CreateClassView extends GetView<CreateClassController> {
  const CreateClassView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.35;
    return Scaffold(
      body: Obx(() {
        // Show loading indicator while initial data is being fetched
        if (controller.isLoadingData.value) {
          return Column(
            children: [
              AuthAppbar(
                icon: IconTxt.classIcon,
                title: context.l10n.createClass,
                description: "Isi informasi kelas untuk memulai",
                height: appBarHeight,
                top: const StepIndicatorWidget(step: 1, maxStep: 2),
              ),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        // Show error and retry if initial data failed to load
        if (controller.classroomTypes.isEmpty &&
            controller.cities.isEmpty &&
            controller.errorMessage.value.isNotEmpty) {
          return Column(
            children: [
              AuthAppbar(
                icon: IconTxt.classIcon,
                title: context.l10n.createClass,
                description: "Isi informasi kelas untuk memulai",
                height: appBarHeight,
                top: const StepIndicatorWidget(step: 1, maxStep: 2),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.innerPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: ColorConstant.redColor,
                        ),
                        const SizedBox(height: Dimens.spacePadding),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Dimens.spacePadding),
                        ElevatedButton(
                          onPressed: controller.retryLoadInitialData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primary,
                            foregroundColor: ColorConstant.white,
                          ),
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              AuthAppbar(
                icon: IconTxt.classIcon,
                title: context.l10n.createClass,
                description: "Isi informasi kelas untuk memulai",
                height: appBarHeight,
                top: const StepIndicatorWidget(step: 1, maxStep: 2),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                child: CommonCardWidget(
                    boxShadow: const [
                      BoxShadowConstant.authPrimary,
                      BoxShadowConstant.auth,
                    ],
                    margin: const EdgeInsets.only(top: Dimens.innerPadding),
                    child: AddClassWidget(controller: controller)
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

