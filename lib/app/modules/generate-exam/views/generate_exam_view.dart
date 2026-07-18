import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../controllers/generate_exam_controller.dart';
import 'widgets/bottom_action_bars.dart';
import 'widgets/step_1_view.dart';
import 'widgets/step_2_view.dart';
import 'widgets/step_3_view.dart';
import 'widgets/stepper_indicator.dart';

class GenerateExamView extends GetView<GenerateExamController> {
  const GenerateExamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        title: const Text('Buat Soal Ujian'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.previousStep,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const StepperIndicator(),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                if (controller.currentStep.value == 0) {
                  return const Step1View();
                } else if (controller.currentStep.value == 1) {
                  return const Step2View();
                } else {
                  return const Step3View();
                }
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (controller.currentStep.value == 2 &&
            !controller.isGenerating.value &&
            controller.generatedQuestions.isNotEmpty) {
          return buildReviewBottomBar(context, controller);
        }
        if(!controller.isGenerating.value){
          return buildBottomButton(
            context,
            controller.currentStep.value == 0 ? 'Selanjutnya' : 'Buat Soal',
            controller.nextStep,
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
