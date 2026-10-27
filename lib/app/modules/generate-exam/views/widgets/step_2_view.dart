import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import '../../../../core/dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../controllers/generate_exam_controller.dart';
import '../../models/chapter_exam_config.dart';
import 'shared_widgets.dart';

class Step2View extends GetView<GenerateExamController> {
  const Step2View({super.key});

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? controller.startTime.value
        : controller.endTime.value;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.primary,
              onPrimary: ColorConstant.white,
              onSurface: ColorConstant.textDarkGreyColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorConstant.primary,
              onPrimary: ColorConstant.white,
              onSurface: ColorConstant.textDarkGreyColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return;

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (isStart) {
      if (fullDateTime.isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Waktu mulai tidak boleh di masa lalu.',
        );
        return;
      }
      controller.startTime.value = fullDateTime;
      if (controller.endTime.value.isBefore(fullDateTime)) {
        controller.endTime.value = fullDateTime.add(const Duration(hours: 2));
      }
    } else {
      if (fullDateTime.isBefore(controller.startTime.value)) {
        SnackbarHelper.showError(
          title: 'Perhatian',
          message: 'Waktu selesai harus setelah waktu mulai.',
        );
        return;
      }
      controller.endTime.value = fullDateTime;
    }
  }

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
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          '${controller.chapterConfigs.length} bab tersedia',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorConstant.primary
                                        .withValues(alpha: 0.7),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Judul Ujian
          buildFieldLabel(context, context.l10n.examTitleField),
          TextField(
            controller: controller.titleController,
            decoration: InputDecoration(
              hintText: context.l10n.examTitleHint,
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

          // Durasi Pengerjaan
          buildFieldLabel(context, context.l10n.examDurationField),
          Row(
            children: [30, 45, 60, 90, 120]
                .map(
                  (val) => Expanded(
                    child: Padding(
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
                  ),
                )
                .toList(),
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
                      onTap: () => _pickDateTime(context, true),
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
                      onTap: () => _pickDateTime(context, false),
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
          const SizedBox(height: 24),

          // Distribusi Bab, HOTS & LOTS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: buildFieldLabel(context, context.l10n.selectChaptersDistribution)),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    context.l10n.totalQuestionsCount(controller.totalQuestions),
                    style: const TextStyle(
                      color: ColorConstant.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.distributionDesc,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
          ),
          const SizedBox(height: 12),

          Obx(() {
            if (controller.isLoadingChapters.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(
                    color: ColorConstant.primary,
                  ),
                ),
              );
            }

            if (controller.chapterConfigs.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorConstant.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimens.radius),
                ),
                child: const Center(
                  child: Text(
                    'Tidak ada bab yang ditemukan dalam modul ini.',
                    style: TextStyle(color: ColorConstant.textGreyColor),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.chapterConfigs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final config = controller.chapterConfigs[index];
                return _buildChapterCard(context, config);
              },
            );
          }),
          const SizedBox(height: 20),

          // AI Info Box
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
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
                      'AI akan men-generate ${controller.totalQuestions} soal pilihan ganda (${controller.totalHots} HOTS, ${controller.totalLots} LOTS) dengan stimulus bacaan dan analisis otomatis.',
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildChapterCard(BuildContext context, ChapterExamConfig config) {
    return Obx(() {
      final isSelected = config.isSelected.value;

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: Border.all(
            color: isSelected
                ? ColorConstant.primary
                : ColorConstant.grey.withValues(alpha: 0.3),
            width: isSelected ? 1.5 : 1.0,
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
            // Chapter Title & Checkbox
            InkWell(
              onTap: config.toggleSelect,
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    activeColor: ColorConstant.primary,
                    onChanged: (_) => config.toggleSelect(),
                  ),
                  Expanded(
                    child: Text(
                      config.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? ColorConstant.textDarkGreyColor
                                : ColorConstant.textGreyColor,
                          ),
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstant.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${config.totalQuestions} soal',
                        style: const TextStyle(
                          color: ColorConstant.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (isSelected) ...[
              const Divider(height: 20),
              // HOTS Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.hotsQuestions,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: ColorConstant.textDarkGreyColor,
                        ),
                      ),
                      Text(
                        context.l10n.hotsDesc,
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorConstant.textGreyColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                  _buildCounter(
                    value: config.hotsCount.value,
                    onDecrement: config.decrementHots,
                    onIncrement: config.incrementHots,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // LOTS Counter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.lotsQuestions,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: ColorConstant.textDarkGreyColor,
                        ),
                      ),
                      Text(
                        context.l10n.lotsDesc,
                        style: TextStyle(
                          fontSize: 11,
                          color: ColorConstant.textGreyColor.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                  _buildCounter(
                    value: config.lotsCount.value,
                    onDecrement: config.decrementLots,
                    onIncrement: config.incrementLots,
                  ),
                ],
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildCounter({
    required int value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            color: value > 0
                ? ColorConstant.primary
                : ColorConstant.grey.withValues(alpha: 0.5),
            onPressed: value > 0 ? onDecrement : null,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 30),
            alignment: Alignment.center,
            child: Text(
              value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: ColorConstant.textDarkGreyColor,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            color: ColorConstant.primary,
            onPressed: onIncrement,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
