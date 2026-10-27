import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/models/quiz_teacher_model.dart';
import '../../../common/common_button_widget.dart';
import '../../../core/dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../common/common_card_widget.dart';
import '../../../core/styles/svg/svg_constant.dart';
import '../../../core/utils/dialog_helper.dart';
import '../controllers/exam_teachers_controller.dart';
import '../../../routes/app_pages.dart';

class ExamTeachersView extends GetView<ExamTeachersController> {
  const ExamTeachersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.examQuestions,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Dimens.innerPadding),
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed(Routes.GENERATE_EXAM);
                },
                icon: const Icon(Icons.add, size: 16),
                label: Text(context.l10n.createExamQuizzer),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primary,
                  foregroundColor: ColorConstant.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
          ),
        ],
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
                  final displayFilter = filter == 'Semua' ? context.l10n.filterAll : filter;
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
              if (controller.isLoading.value && controller.quizzes.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primary,
                  ),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.quizzes.isEmpty) {
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
                          onPressed: () => controller.fetchQuizzes(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primary,
                            foregroundColor: ColorConstant.white,
                          ),
                          child: Text(context.l10n.tryAgain),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final quizzes = controller.quizzes;
              if (quizzes.isEmpty) {
                return RefreshIndicator(
                  color: ColorConstant.primary,
                  onRefresh: () => controller.fetchQuizzes(showLoading: false),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Center(
                          child: Text(
                            context.l10n.noExamsForClass,
                            style: const TextStyle(color: ColorConstant.textGreyColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                color: ColorConstant.primary,
                onRefresh: () => controller.fetchQuizzes(showLoading: false),
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

  Widget _buildQuizCard(BuildContext context, QuizRequestTeacherModel quiz) {
    final isPublish = quiz.isPublished;
    final isPublishingThis = controller.publishingQuizId.value == quiz.id;
    final isDeletingThis = controller.deletingQuizId.value == quiz.id;

    final moduleTitle = quiz.module.title.isNotEmpty
        ? quiz.module.title
        : 'Modul #${quiz.moduleId}';

    return CommonCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  quiz.title,
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
                  color: isPublish
                      ? ColorConstant.green.withValues(alpha: 0.1)
                      : ColorConstant.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPublish ? context.l10n.filterPublish : context.l10n.filterDraft,
                  style: TextStyle(
                    color: isPublish
                        ? ColorConstant.green
                        : ColorConstant.textDarkGreyColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            context.l10n.examSubtitleFormat(quiz.questionCounts, quiz.maxDurationMinutes),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: ColorConstant.textGreyColor,
            ),
          ),
          const SizedBox(height: 4),
          // Attachment
          Row(
            children: [
              const Icon(
                Icons.attach_file,
                size: 14,
                color: ColorConstant.textGreyColor,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  moduleTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildExamButton(context, context.l10n.viewExamQuestions, () => controller.onDetailExam(quiz),),
                    const SizedBox(height: 8),
                    _buildExamButton(context, context.l10n.viewStudentProgress, () => controller.onStudentExamProgress(quiz)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Right: delete and publish actions
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: TextButton.icon(
                          onPressed: isDeletingThis
                              ? null
                              : () {
                            DialogHelper.show(
                              title: context.l10n.deleteExam,
                              description:
                              context.l10n.deleteExamConfirm(quiz.title),
                              colorDescription:
                              ColorConstant.textDarkGreyColor,
                              icon: SvgPicture.asset(
                                SvgConstant.iconTrashConfirmation,
                                width: Dimens.iconBigSize,
                                height: Dimens.iconBigSize,
                              ),
                              actions: CommonButtonWidget(
                                buttonName: context.l10n.confirm,
                                buttonColor: ColorConstant.redColor,
                                onPressed: () {
                                  controller.onDeleteQuiz(quiz);
                                },
                              ),
                            );
                          },
                          icon: isDeletingThis
                              ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                              : const Icon(
                            Icons.delete_outline,
                            size: 16,
                          ),
                          label: Text(context.l10n.delete),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            minimumSize: const Size(0, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    ),

                    if (!isPublish) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isPublishingThis
                              ? null
                              : () {
                            controller.onChangeQuizStatus(
                              quiz,
                              'publish',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primary,
                            foregroundColor: ColorConstant.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                          ),
                          child: isPublishingThis
                              ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorConstant.white,
                            ),
                          )
                              : Text(
                            context.l10n.publishExam,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExamButton(BuildContext context, String title, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: ColorConstant.textDarkGreyColor,
        side: const BorderSide(color: ColorConstant.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(title),
    );
  }

}

