import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/styles/text_theme.dart';
import '../../exam_review/views/widgets/justification_card.dart';
import '../../exam_review/views/widgets/progress_indicator.dart';
import '../../exam_review/views/widgets/question_card.dart';
import '../../exam_review/views/widgets/review_bottom_navigation.dart';
import '../../exam_review/views/widgets/status_banner.dart';
import '../controllers/exam_teacher_student_progress_detail_controller.dart';

class ExamTeacherStudentProgressDetailView extends GetView<ExamTeacherStudentProgressDetailController> {
  const ExamTeacherStudentProgressDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Detail Progres Murid',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const SizedBox(height: 16),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  color: ColorConstant.primary,
                ),
              );
            }

            if (controller.questions.isEmpty) {
              return Center(
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
                            child: const Text('Kembali'),
                          ),
                          const SizedBox(
                            width: Dimens.spaceMediumPadding,
                          ),
                          ElevatedButton(
                            onPressed: () => controller.fetchResults(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorConstant.primary,
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
              );
            }

            final safeIndex = controller.currentIndex.value.clamp(
              0,
              controller.questions.length - 1,
            );
            final question = controller.questions[safeIndex];

            return Column(
              children: [
                const SizedBox(height: Dimens.spaceBigPadding),
                ProgressIndicatorExamReview(
                  currentIndex: controller.currentIndex.value,
                  questions: controller.questions,
                  goToQuestion: controller.goToQuestion,
                ),
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
                        JustificationCard(
                          question: question,
                          parser: controller.parser,
                          serializer: controller.serializer,
                        ),
                      ],
                    ),
                  ),
                ),
                ReviewBottomNavigation(
                  currentIndex: controller.currentIndex.value,
                  previousQuestion: controller.previousQuestion,
                  nextQuestion: controller.nextQuestion,
                  questions: controller.questions,
                ),
              ],
            );
          }),
        ),
      ],
    ),
    );
  }
}
