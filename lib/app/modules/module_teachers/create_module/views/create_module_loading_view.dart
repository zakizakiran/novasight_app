import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/controllers/create_module_controller.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/views/widgets/orbiting_head_widget.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/views/widgets/step_tile_widget.dart';

class CreateModuleLoadingView extends GetView<CreateModuleController> {
  const CreateModuleLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            controller.cancelLoadingProcess();
            Get.back();
          },
        ),
        title: Text(
          context.l10n.processingModule,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OrbitingHeaderWidget(),
                const SizedBox(height: 32),

                const Text(
                  "AI Sedang Memproses Modul",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  context.l10n.loadingModuleExtraction,
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorConstant.textGreyColor,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Progress Bar
                Obx(
                  () => Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: controller.progress.value,
                          minHeight: 8,
                          backgroundColor: const Color(0xFFF1F5F9),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            ColorConstant.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${(controller.progress.value * 100).toInt()}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: ColorConstant.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Step Checklist Items
                Column(
                  children: controller.uploadSteps
                      .map((step) => StepTileWidget(step: step))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
