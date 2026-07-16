import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../controllers/generate_exam_controller.dart';

class StepperIndicator extends GetView<GenerateExamController> {
  const StepperIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int step = controller.currentStep.value;
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepItem(context, 0, 'Pilih Modul', step),
          _buildStepDivider(step >= 1),
          _buildStepItem(context, 1, 'Konfigurasi', step),
          _buildStepDivider(step >= 2),
          _buildStepItem(context, 2, 'Review & Simpan', step),
        ],
      );
    });
  }

  Widget _buildStepItem(
    BuildContext context,
    int index,
    String label,
    int currentStep,
  ) {
    bool isActive = index == currentStep;
    bool isCompleted = index < currentStep;

    Color color = (isActive || isCompleted)
        ? ColorConstant.primary
        : ColorConstant.grey;

    return GestureDetector(
      onTap: () {
        if (index < currentStep && !controller.isGenerating.value) {
          controller.currentStep.value = index;
        }
      },
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 16),
      width: 40,
      height: 2,
      color: isActive
          ? ColorConstant.primary
          : ColorConstant.grey.withValues(alpha: 0.5),
    );
  }
}
