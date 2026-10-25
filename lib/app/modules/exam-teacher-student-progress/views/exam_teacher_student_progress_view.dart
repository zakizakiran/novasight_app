import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/data/models/student_progress_quiz.dart';

import '../../../common/common_card_widget.dart';
import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../controllers/exam_teacher_student_progress_controller.dart';

class ExamTeacherStudentProgressView extends GetView<ExamTeacherStudentProgressController> {
  const ExamTeacherStudentProgressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.studentProgressTitle,
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
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.innerPadding,
            ),
            child: Obx(
                  () => Row(
                children: controller.filterOptions.map((filter) {
                  bool isSelected = controller.selectedFilter.value == filter;
                  String displayFilter = filter;
                  if (filter == 'Semua') {
                    displayFilter = context.l10n.filterAll;
                  } else if (filter == 'Selesai') {
                    displayFilter = context.l10n.filterDone;
                  } else if (filter == 'Belum Dikerjakan') {
                    displayFilter = context.l10n.filterNotAttempted;
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => controller.setFilter(filter),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorConstant.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? ColorConstant.primary
                                : ColorConstant.grey,
                          ),
                        ),
                        child: Text(
                          displayFilter,
                          style: TextStyle(
                            color: isSelected
                                ? ColorConstant.white
                                : ColorConstant.textGreyColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Exam List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.quizzesProgress.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primary,
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.quizzesProgress.isEmpty) {
                return Center(
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
                        const SizedBox(height: 12),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: ColorConstant.textDarkGreyColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.fetchQuizzesProgress(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primary,
                            foregroundColor: ColorConstant.white,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final quizzes = controller.quizzesProgress;
              if (quizzes.isEmpty) {
                return RefreshIndicator(
                  color: ColorConstant.primary,
                  onRefresh: () => controller.fetchQuizzesProgress(showLoading: false),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: const Center(
                          child: Text(
                            'Tidak ada data ujian',
                            style: TextStyle(color: ColorConstant.textGreyColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: ColorConstant.primary,
                onRefresh: () => controller.fetchQuizzesProgress(showLoading: false),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Dimens.innerPadding),
                  itemCount: quizzes.length,
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return _buildQuizCard(context, quizzes[index]);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, StudentProgressQuiz quiz) {
    final double? score = quiz.quizProgress?.score;
    final isScored = score != null;

    return CommonCardWidget(
      onPressed: () => controller.onStudentDetailExamProgress(quiz),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  quiz.profileResponse.email,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.textDarkGreyColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isScored
                      ? ColorConstant.green.withValues(alpha: 0.1)
                      : ColorConstant.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${context.l10n.score} : ${isScored ? score.toString() : '-'}',
                  style: TextStyle(
                    color: isScored
                        ? ColorConstant.green
                        : ColorConstant.textDarkGreyColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
