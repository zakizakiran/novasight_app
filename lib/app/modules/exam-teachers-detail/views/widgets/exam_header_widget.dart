import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lydera_app/app/core/utils/date_helper.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/exam-teachers-detail/controllers/exam_teacher_detail_controller.dart';

import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../generate-exam/views/widgets/shared_widgets.dart';

class ExamHeaderWidget extends StatelessWidget {
  final bool isReadOnly;
  final int numberOfQuestions;
  final String answerOptions;
  final String difficulty;
  final int? durationMinutes;
  final int maxRetry;
  final String? subtitle;
  final DateTime startTime;
  final DateTime endTime;
  final TextEditingController controller;

  final Widget? trailing;

  const ExamHeaderWidget({
    super.key,
    required this.controller,
    required this.numberOfQuestions,
    this.answerOptions = 'A-D',
    this.difficulty = 'Campuran',
    this.durationMinutes,
    this.subtitle,
    required this.isReadOnly,
    this.trailing,
    required this.startTime,
    required this.endTime,
    required this.maxRetry,
  });

  @override
  Widget build(BuildContext context) {
    final examController = Get.find<ExamTeacherDetailController>();
    return Padding(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: Border.all(
            color: ColorConstant.grey.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorConstant.shadowColor.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: isReadOnly,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.textDarkGreyColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: context.l10n.enterExamTitle,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: Dimens.spaceXs),
            if (isReadOnly)
              _buildView(context)
            else
              _buildEdit(context, examController),
          ],
        ),
      ),
    );
  }

  Widget _buildView(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle ??
              (durationMinutes != null
                  ? context.l10n.examSubtitleFormat(numberOfQuestions, durationMinutes!)
                  : '$numberOfQuestions soal · Pilihan Ganda ($answerOptions) · $difficulty'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorConstant.textGreyColor,
          ),
        ),
        const SizedBox(height: Dimens.spaceXs),
        Text(
          'Mulai : ${DateHelper.dateTimeFormat(startTime)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorConstant.textGreyColor,
          ),
        ),
        const SizedBox(height: Dimens.spaceXs),
        Text(
          'Berakhir : ${DateHelper.dateTimeFormat(endTime)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorConstant.textGreyColor,
          ),
        ),

        const SizedBox(height: Dimens.spaceXs),
        Text(
          'Maksimal Pengerjaan : ${maxRetry}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: ColorConstant.textGreyColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEdit(BuildContext context, ExamTeacherDetailController controller){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Durasi Pengerjaan
        buildFieldLabel(context, context.l10n.examDurationField),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [30, 45, 60, 90, 120]
                .map(
                  (val) => Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Obx(
                          () => buildSelectableButton(
                        context,
                        context.l10n.minuteShort(val),
                        controller.maxDurationMinutes.value == val,
                            () => controller.setDuration(val),
                      ),
                    ),
                  ),
            )
                .toList(),
          ),
        ),
        const SizedBox(height: 20),

        // Jadwal Pengerjaan (Waktu Mulai & Waktu Selesai)
        buildFieldLabel(context, context.l10n.examScheduleField),
        Row(
          children: [
            // Start Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.startTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstant.textGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => DateHelper.pickDateTime(context, true, controller.startTime, controller.endTime),
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.grey.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(Dimens.radius),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: ColorConstant.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Obx(
                                  () => Text(
                                DateFormat('dd MMM yyyy, HH:mm')
                                    .format(controller.startTime.value),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.textDarkGreyColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // End Time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.endTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: ColorConstant.textGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => DateHelper.pickDateTime(context, false, controller.startTime, controller.endTime),
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.grey.withValues(alpha: 0.5),
                        ),
                        borderRadius: BorderRadius.circular(Dimens.radius),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.event_available_outlined,
                            size: 16,
                            color: ColorConstant.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Obx(
                                  () => Text(
                                DateFormat('dd MMM yyyy, HH:mm')
                                    .format(controller.endTime.value),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.textDarkGreyColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Maksimal Pengulangan (max_retry)
        buildFieldLabel(context, context.l10n.maxAttempts),
        Row(
          children: [1, 2, 3]
              .map(
                (val) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Obx(
                      () => buildSelectableButton(
                    context,
                    context.l10n.timesCount(val),
                    controller.maxRetry.value == val,
                        () => controller.setMaxRetry(val),
                  ),
                ),
              ),
            ),
          )
              .toList(),
        ),
      ],
    );
  }
}

