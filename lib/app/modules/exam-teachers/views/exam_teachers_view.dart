import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/args/generate_exam_args.dart';
import '../../../common/common_button_widget.dart';
import '../../../core/dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../common/common_card_widget.dart';
import '../../../core/styles/svg/svg_constant.dart';
import '../../../core/utils/dialog_helper.dart';
import '../controllers/exam_teachers_controller.dart';
import '../models/exam_teacher_model.dart';
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
                label: const Text('Buat Soal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primary,
                  foregroundColor: ColorConstant.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? ColorConstant.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? ColorConstant.primary : ColorConstant.grey,
                          ),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? ColorConstant.white : ColorConstant.textGreyColor,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
              final exams = controller.filteredExams;
              if (exams.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada data ujian',
                    style: TextStyle(color: ColorConstant.textGreyColor),
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                itemCount: exams.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return _buildExamCard(context, exams[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildExamCard(BuildContext context, ExamTeacherModel exam) {
    bool isPublish = exam.status == 'Publish';

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
                  exam.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.textDarkGreyColor,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isPublish ? ColorConstant.green.withValues(alpha: 0.1) : ColorConstant.grey.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exam.status,
                  style: TextStyle(
                    color: isPublish ? ColorConstant.green : ColorConstant.textDarkGreyColor,
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
            '${exam.questionCount} soal · ${exam.type} · ${exam.difficulty}',
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
                  exam.moduleName,
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
                    Get.toNamed(
                        Routes.EXAM_TEACHERS_DETAIL,
                      arguments: exam
                    );
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
                    onPressed: () {
                      controller.onChangeExamStatus(exam,"Publish");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primary,
                      foregroundColor: ColorConstant.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: const Text('Publish Soal'),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  DialogHelper.show(
                    title: "Hapus Soal Ujian",
                    description: "Anda yakin ingin menghapus soal ujian ini?",
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
                        controller.onDeleteExam(exam);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.delete_outline, size: 16),
                label: const Text('Hapus'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
