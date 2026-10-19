import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/modules/exam_review/views/widgets/justification_card.dart';
import 'package:novasight_app/app/modules/exam_review/views/widgets/progress_indicator.dart';
import 'package:novasight_app/app/modules/exam_review/views/widgets/question_card.dart';
import 'package:novasight_app/app/modules/exam_review/views/widgets/review_bottom_navigation.dart';
import 'package:novasight_app/app/modules/exam_review/views/widgets/status_banner.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/styles/text_theme.dart';
import '../controllers/exam_review_controller.dart';

class ExamReviewView extends GetView<ExamReviewController> {

  const ExamReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Column(
              children: [
                CommonAppBar(
                  title: 'Evaluaizer — Review Hasil Ujian',
                  description: controller.quizTitle.value,
                ),
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: ColorConstant.primary,
                    ),
                  ),
                ),
              ],
            );
          }

          if (controller.questions.isEmpty) {
            return Column(
              children: [
                CommonAppBar(
                  title: 'Evaluaizer — Review Hasil Ujian',
                  description: controller.quizTitle.value,
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.spaceBigPadding),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.assignment_outlined,
                            size: 64,
                            color: ColorConstant.textGreyColor,
                          ),
                          const SizedBox(height: Dimens.spaceMediumPadding),
                          Text(
                            controller.errorMessage.value.isNotEmpty
                                ? controller.errorMessage.value
                                : 'Belum ada hasil evaluasi ujian yang tersedia.',
                            textAlign: TextAlign.center,
                            style: const MainTextTheme().bodyLarge?.copyWith(
                              color: ColorConstant.textGreyColor,
                            ),
                          ),
                          const SizedBox(height: Dimens.spaceBigPadding),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () => Get.back(),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Kembali'),
                              ),
                              const SizedBox(width: Dimens.spaceMediumPadding),
                              ElevatedButton(
                                onPressed: () => controller.fetchResults(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Coba Lagi',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          final safeIndex = controller.currentIndex.value.clamp(0, controller.questions.length - 1,);
          final question = controller.questions[safeIndex];
          return Column(
            children: [
              CommonAppBar(
                title: 'Evaluaizer — Review Hasil Ujian',
                description: controller.quizTitle.value,
              ),
              const SizedBox(height: Dimens.spaceBigPadding),
              Obx(() => ProgressIndicatorExamReview(currentIndex: controller.currentIndex.value, questions: controller.questions, goToQuestion: controller.goToQuestion)),
              const SizedBox(height: Dimens.spaceBigPadding),
              Expanded(
                child: SingleChildScrollView(
                  key: ValueKey(safeIndex),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      StatusBanner(question: question),
                      const SizedBox(height: 20),
                      QuestionCard(question: question),
                      const SizedBox(height: 20),
                      JustificationCard(question: question, parser: controller.parser, serializer: controller.serializer)
                    ],
                  ),
                ),
              ),
              Obx(() => ReviewBottomNavigation(currentIndex: controller.currentIndex.value, previousQuestion: controller.previousQuestion, nextQuestion: controller.nextQuestion, questions: controller.questions)),
            ],
          );
        }),
      ),
    );
  }
}








