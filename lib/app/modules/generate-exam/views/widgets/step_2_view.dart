import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../controllers/generate_exam_controller.dart';
import 'shared_widgets.dart';

class Step2View extends GetView<GenerateExamController> {
  const Step2View({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Module Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorConstant.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(Dimens.radius),
              border: Border.all(
                color: ColorConstant.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, color: ColorConstant.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.selectedModuleName.value,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.primary,
                        ),
                      ),
                      Text(
                        'Kelas 10 • 16 Jun 2026',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.primary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Form fields
          buildFieldLabel(context, 'Judul Ujian *'),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              hintText: 'Masukkan Judul Ujian',
              hintStyle: const TextStyle(color: ColorConstant.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius),
                borderSide: const BorderSide(color: ColorConstant.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius),
                borderSide: BorderSide(
                  color: ColorConstant.grey.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimens.radius),
                borderSide: const BorderSide(
                  color: ColorConstant.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),

          buildFieldLabel(context, 'Jumlah Soal *'),
          Row(
            children: [5, 10, 15, 20]
                .map(
                  (val) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Obx(
                        () => buildSelectableButton(
                          context,
                          val.toString(),
                          controller.numberOfQuestions.value == val,
                          () => controller.setQuestions(val),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          buildFieldLabel(context, 'Jumlah Pilihan Jawaban *'),
          Row(
            children: ['A-D', 'A-E']
                .map(
                  (val) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Obx(
                        () => buildSelectableButton(
                          context,
                          val,
                          controller.answerOptions.value == val,
                          () => controller.setAnswerOptions(val),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),

          buildFieldLabel(context, 'Tingkat Kesulitan *'),
          Row(
            children: ['Mudah', 'Sedang', 'Sulit']
                .map(
                  (val) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Obx(
                        () => buildSelectableButton(
                          context,
                          val,
                          controller.difficulty.value == val,
                          () => controller.setDifficulty(val),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),

          // AI Info Box
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD), // Light blue variant
                borderRadius: BorderRadius.circular(Dimens.radius),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: ColorConstant.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI akan membuat ${controller.numberOfQuestions.value} soal pilihan ganda (${controller.answerOptions.value}) dengan tingkat kesulitan ${controller.difficulty.value.toLowerCase()} dari modul yang dipilih.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textDarkGreyColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
