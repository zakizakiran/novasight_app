import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/quiz_teacher_model.dart';
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
          'Soal Ujian',
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
                label: const Text('Buat Soal (Quizzer)'),
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
                          filter,
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
                          child: const Text('Coba Lagi'),
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
                  isPublish ? 'Publish' : 'Draft',
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
            '${quiz.questionCounts} soal · Durasi ${quiz.maxDurationMinutes} menit',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ColorConstant.textGreyColor),
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
          // Action Row
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.toNamed(Routes.EXAM_TEACHERS_DETAIL, arguments: quiz);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorConstant.textDarkGreyColor,
                    side: const BorderSide(color: ColorConstant.grey),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text('Lihat Soal'),
                ),
              ),
              if (!isPublish) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isPublishingThis
                        ? null
                        : () {
                            controller.onChangeQuizStatus(quiz, "publish");
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primary,
                      foregroundColor: ColorConstant.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
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
                        : const Text('Publish Soal'),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: isDeletingThis
                    ? null
                    : () {
                        DialogHelper.show(
                          title: "Hapus Soal Ujian",
                          description:
                              'Anda yakin ingin menghapus "${quiz.title}"?',
                          colorDescription: ColorConstant.textDarkGreyColor,
                          icon: SvgPicture.asset(
                            SvgConstant.iconTrashConfirmation,
                            width: Dimens.iconBigSize,
                            height: Dimens.iconBigSize,
                          ),
                          actions: CommonButtonWidget(
                            buttonName: "Konfirmasi",
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
                    : const Icon(Icons.delete_outline, size: 16),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
