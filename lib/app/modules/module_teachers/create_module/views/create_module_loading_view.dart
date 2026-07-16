import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/dialog_helper.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/controllers/create_module_controller.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/views/widgets/orbiting_head_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/views/widgets/step_tile_widget.dart';
import '../../../../core/Dimens.dart';
class CreateModuleLoadingView extends GetView<CreateModuleController> {
  const CreateModuleLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        DialogHelper.show(
            title: "Batal anotasi modul",
            description: "Apakah anda yakin ingin membatalkan progress anotasi",
            actions: Row(
              children: [
                Expanded(
                  child: CommonButtonWidget(
                      buttonName: "Iya",
                      buttonColor: ColorConstant.redColor,
                      onPressed: () {
                        Get.back();
                        Get.back();
                        controller.cancelLoadingProcess();
                      }
                  ),
                ),
                const SizedBox(width: Dimens.spacePadding),
                Expanded(
                  child: CommonButtonWidget(
                      buttonName: "Tidak",
                      onPressed: () {
                        Get.back();
                      }
                  ),
                ),
              ],
            )
        );
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OrbitingHeaderWidget(),
                const SizedBox(height: 32),

                const Text(
                  "AI Sedang Memproses Modul",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sedang membaca dan membuat anotasi\nkonten matematika pada modulmu",
                  style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Progress Bar
                Obx(() => Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: controller.progress.value,
                        minHeight: 10,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "${(controller.progress.value * 100).toInt()}%",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                  ],
                )),
                const SizedBox(height: 24),

                // Step Checklist Items
                Column(
                  children: controller.uploadSteps.map((step) => StepTileWidget(step: step)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

