import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';

import 'package:novasight_app/app/routes/app_pages.dart';
import '../controllers/exam_active_controller.dart';

class ExamActiveView extends GetView<ExamActiveController> {
  const ExamActiveView({super.key});

  @override
  Widget build(BuildContext context) {
    const examTitle = "Soal Ujian";
    const examDescription = "UTS Kelas X";

    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: Column(
          children: [
            const CommonAppBar(title: examTitle, description: examDescription),
            const SizedBox(height: Dimens.spaceBigPadding),
            _buildNumberIndicators(context),
            const SizedBox(height: Dimens.spaceBigPadding),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.innerPadding,
                ),
                child: Obx(() {
                  if (controller.questions.isEmpty) return const SizedBox();
                  final currentQuestion =
                      controller.questions[controller.currentIndex.value];
                  return Column(
                    children: [
                      CommonCardWidget(
                        boxShadow: [BoxShadowConstant.module],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Soal ${controller.currentIndex.value + 1}",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: ColorConstant.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: Dimens.spaceSmallPadding),
                            Text(
                              currentQuestion.questionText,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: ColorConstant.textDarkGreyColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: Dimens.spacePadding),
                            Text(
                              "Jawaban",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: ColorConstant.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: Dimens.spaceSmallPadding),
                            ...currentQuestion.options.map((option) {
                              final isSelected =
                                  currentQuestion.selectedOptionId == option.id;
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimens.spaceMediumPadding,
                                ),
                                child: _buildOptionCard(
                                  context,
                                  option: option,
                                  isSelected: isSelected,
                                  onTap: () => controller.selectOption(
                                    currentQuestion.id,
                                    option.id,
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
            _buildBottomNavigation(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberIndicators(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Obx(() {
        // Read observables here so Obx registers them as dependencies
        final currentIndex = controller.currentIndex.value;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
          itemCount: controller.questions.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: Dimens.spaceMediumPadding),
          itemBuilder: (context, index) {
            final isActive = currentIndex == index;
            final isAnswered =
                controller.questions[index].selectedOptionId != null;
            return Semantics(
              label:
                  "Soal nomor ${index + 1} dari ${controller.questions.length}",
              button: true,
              child: GestureDetector(
                onTap: () => controller.goToQuestion(index),
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isActive
                        ? ColorConstant.primary.withOpacity(0.1)
                        : (isAnswered
                              ? ColorConstant.lightGreen
                              : ColorConstant.white),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? ColorConstant.primary
                          : (isAnswered
                                ? ColorConstant.green
                                : ColorConstant.borderNormalGrey),
                    ),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: isActive
                          ? ColorConstant.primary
                          : (isAnswered
                                ? ColorConstant.green
                                : ColorConstant.textDarkGreyColor),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required ExamOptionModel option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      checked: isSelected,
      label: "Pilihan ${option.letter}. ${option.text}",
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(Dimens.innerMediumPadding),
          decoration: BoxDecoration(
            color: isSelected ? ColorConstant.card : ColorConstant.background,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(
              color: isSelected
                  ? ColorConstant.primary
                  : ColorConstant.borderNormalGrey,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? ColorConstant.primary
                        : ColorConstant.borderNormalGrey,
                  ),
                ),
                child: Text(
                  option.letter,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isSelected
                        ? ColorConstant.primary
                        : ColorConstant.textDarkGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spaceMediumPadding),
              Expanded(
                child: Text(
                  option.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.textDarkGreyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      decoration: const BoxDecoration(
        color: ColorConstant.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.shadowColor,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final isFirst = controller.currentIndex.value == 0;
        final isLast =
            controller.currentIndex.value == controller.questions.length - 1;

        return Row(
          children: [
            Expanded(
              child: CommonButtonWidget(
                buttonName: "Sebelumnya",
                buttonColor: isFirst
                    ? ColorConstant.grey
                    : ColorConstant.borderNormalGrey,
                textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: isFirst
                      ? ColorConstant.textGreyColor
                      : ColorConstant.textDarkGreyColor,
                  fontWeight: FontWeight.bold,
                ),
                onPressed: controller.previousQuestion,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: isFirst
                            ? ColorConstant.textGreyColor
                            : ColorConstant.textDarkGreyColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Sebelumnya",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isFirst
                                  ? ColorConstant.textGreyColor
                                  : ColorConstant.textDarkGreyColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimens.spaceMediumPadding),
            Expanded(
              child: CommonButtonWidget(
                buttonName: "Selanjutnya",
                buttonColor: isLast
                    ? ColorConstant.grey
                    : ColorConstant.primary,
                onPressed: isLast ? () {} : controller.nextQuestion,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Selanjutnya",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: isLast
                                  ? ColorConstant.textGreyColor
                                  : ColorConstant.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: isLast
                            ? ColorConstant.textGreyColor
                            : ColorConstant.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: Dimens.spaceMediumPadding),
            Semantics(
              label: "Buka Catatan Pengerjaan",
              button: true,
              child: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.NOTE, arguments: {
                    'question': controller.questions[controller.currentIndex.value],
                    'index': controller.currentIndex.value + 1,
                    'total': controller.questions.length,
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorConstant.card,
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    border: Border.all(color: ColorConstant.primary),
                  ),
                  child: const Icon(
                    Icons.edit_square,
                    color: ColorConstant.primary,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
