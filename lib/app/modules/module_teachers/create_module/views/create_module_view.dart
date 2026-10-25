import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_teacher_appbar.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/data/models/cp_model.dart';
import 'package:novasight_app/app/data/models/fase_model.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/views/widgets/pick_module_widget.dart';

import '../../../../common/common_dropdown_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/validate_helper.dart';
import '../controllers/create_module_controller.dart';

class CreateModuleView extends GetView<CreateModuleController> {
  const CreateModuleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => CommonTeacherAppbar(
                  title:
                      controller.currentStep.value ==
                              CreateModuleStep.infoModul
                          ? context.l10n.uploadModule
                          : context.l10n.splitPagesAndChapters,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(context),
                    const SizedBox(height: Dimens.spacePadding),
                    Obx(() {
                      if (controller.currentStep.value ==
                          CreateModuleStep.infoModul) {
                        return _buildModuleInfoForm(context);
                      } else {
                        return _buildChapterSplitForm(context);
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => _buildBottomBar(context)),
    );
  }

  /// Step progress indicator (1. Info Modul -> 2. Potong BAB)
  Widget _buildStepIndicator(BuildContext context) {
    return Obx(() {
      final isStep1 =
          controller.currentStep.value == CreateModuleStep.infoModul;

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.innerPadding,
          vertical: Dimens.spacePadding,
        ),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: Border.all(color: ColorConstant.grey),
        ),
        child: Row(
          children: [
            _buildStepBadge(
              number: "1",
              label: context.l10n.moduleInfo,
              isActive: isStep1,
              isDone: !isStep1,
            ),
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: !isStep1 ? ColorConstant.primary : ColorConstant.grey,
              ),
            ),
            _buildStepBadge(
              number: "2",
              label: context.l10n.splitChapters,
              isActive: !isStep1,
              isDone: false,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStepBadge({
    required String number,
    required String label,
    required bool isActive,
    required bool isDone,
  }) {
    final color = (isActive || isDone)
        ? ColorConstant.primary
        : ColorConstant.textGreyColor;

    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? ColorConstant.primary
                : (isActive ? ColorConstant.primary : ColorConstant.grey),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    number,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.white
                          : ColorConstant.textGreyColor,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  /// Step 1: Form upload file and module metadata
  Widget _buildModuleInfoForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PickModuleWidget(),
        const SizedBox(height: Dimens.spacePadding),
        Obx(() {
          if (controller.totalPages.value > 0) {
            return Container(
              margin: const EdgeInsets.only(bottom: Dimens.spacePadding),
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.innerPadding,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: ColorConstant.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimens.radius),
                border: Border.all(
                  color: ColorConstant.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 20,
                    color: ColorConstant.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.pdfPagesDetected(controller.totalPages.value),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: ColorConstant.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => CommonTextFormFieldWidget(
                  title: context.l10n.moduleTitleField,
                  controller: controller.titleModuleController,
                  hint: context.l10n.moduleTitleHint,
                  successColor: ColorConstant.primary,
                  isReadOnly: controller.isSavingModule.value,
                  onChanged: controller.onChange,
                  validator: ValidateHelper.isNormalValidate("Judul Modul"),
                  borderSideFocused: const BorderSide(width: 1.5),
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
                  borderSideEnable: const BorderSide(width: 1.5),
                ),
              ),
              const SizedBox(height: Dimens.spacePadding),
              Obx(
                () => CommonTextFormFieldWidget(
                  title: context.l10n.moduleDescriptionField,
                  controller: controller.descriptionModuleController,
                  hint: context.l10n.moduleDescriptionHint,
                  minLines: 4,
                  isReadOnly: controller.isSavingModule.value,
                  onChanged: controller.onChange,
                  borderSideFocused: const BorderSide(width: 1.5),
                  hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
                  borderSideEnable: const BorderSide(width: 1.5),
                ),
              ),
              const SizedBox(height: Dimens.spacePadding),
              Obx(
                () => CommonDropdownWidget<FaseModel>(
                  title: context.l10n.fase,
                  listValue: controller.listFase,
                  selectedValue: controller.selectedFase.value,
                  initialLabel: controller.isLoadingFase.value
                      ? context.l10n.loadingFases
                      : context.l10n.selectFase,
                  itemLabel: (f) => f.displayName,
                  onSelect: controller.onSelectFase,
                  isEnabled:
                      !controller.isSavingModule.value &&
                      !controller.isLoadingFase.value,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Step 2: Form cutting page ranges to create BAB (Chapter)
  Widget _buildChapterSplitForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved module summary card
        Container(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade600,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.savedModule.value?.title ??
                          controller.titleModuleController.text,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.totalDocPages(controller.totalPages.value),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstant.textGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimens.spacePadding),

        // Cutting section container
        Container(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(color: ColorConstant.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.chapterSplitConfig,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.chapterSplitDesc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
              ),
              const SizedBox(height: Dimens.spacePadding),

              // Chapter Number & Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.chapter,
                      controller: controller.chapterNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hint: "cth: 1",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.textGreyColor,
                            fontStyle: FontStyle.italic,
                          ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacePadding),
                  Expanded(
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.chapterTitleField,
                      controller: controller.chapterTitleController,
                      hint: "cth: BAB I : Eksponen",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.textGreyColor,
                            fontStyle: FontStyle.italic,
                          ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.spacePadding),

              // Page Range Selection (Start Page -> End Page)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.startPageField,
                      controller: controller.startPageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hint: "cth: 1",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.textGreyColor,
                            fontStyle: FontStyle.italic,
                          ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacePadding),
                  Expanded(
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.endPageField,
                      controller: controller.endPageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hint: "cth: ${controller.totalPages.value > 0 ? controller.totalPages.value : '44'}",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: ColorConstant.textGreyColor,
                            fontStyle: FontStyle.italic,
                          ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Cp dropdown
              Obx(
                    () => CommonDropdownWidget<CpModel>(
                  title: context.l10n.learningCompetency,
                  listValue: controller.listCp,
                  selectedValue: controller.selectedCp.value,
                  initialLabel: controller.isLoadingCp.value
                      ? context.l10n.loadingCompetency
                      : context.l10n.selectCompetency,
                  itemLabel: (c) => c.domain,
                  onSelect: controller.onSelectCp,
                  isEnabled: !controller.isLoadingCp.value,
                ),
              ),

              // Hint info
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorConstant.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: ColorConstant.textGreyColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        context.l10n.exampleChapterRangeHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: ColorConstant.textGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimens.spacePadding),

              // Action button to cut & create chapter
              CommonButtonWidget(
                buttonName: context.l10n.processAndCreateChapter,
                boxShadows: const [],
                isValid: true,
                isLoading: controller.isCreatingChapter.value,
                onPressed: controller.onCreateChapter,
              ),
            ],
          ),
        ),

        // List of created chapters if any
        Obx(() {
          if (controller.trackedJobs.isEmpty &&
              controller.createdChapters.isEmpty) {
            return const SizedBox.shrink();
          }

          final count = controller.trackedJobs.isNotEmpty
              ? controller.trackedJobs.length
              : controller.createdChapters.length;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimens.spacePadding),
              Text(
                context.l10n.createdChaptersList(count),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (controller.trackedJobs.isNotEmpty)
                ...controller.trackedJobs.asMap().entries.map((entry) {
                  return _buildTrackedChapterTile(
                    context,
                    entry.value,
                    entry.key,
                  );
                })
              else
                ...controller.createdChapters.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final ch = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.circular(Dimens.radius),
                      border: Border.all(color: ColorConstant.grey),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: ColorConstant.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${idx + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Chapter ID: ${ch.chapterId} (Job ID: ${ch.jobId})",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ch.status.isNotEmpty ? ch.status : "running",
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildTrackedChapterTile(
    BuildContext context,
    TrackedChapterJob job,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(Dimens.radius),
        border: Border.all(color: ColorConstant.grey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Obx(
          () => InkWell(
            borderRadius: BorderRadius.circular(Dimens.radius),
            onTap: controller.isOpeningChapter.value
                ? null
                : () => controller.onTapChapterItem(job),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: ColorConstant.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "${job.chapterNumber}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.primary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.pagesRange(job.startPage, job.endPage),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: ColorConstant.textGreyColor,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() {
                      final isOpening =
                          controller.openingJobId.value == job.jobId;
                      if (isOpening) {
                        return const SizedBox.shrink();
                      }

                      final isDone = job.isDone;
                      final isFailed = job.isFailed;
                      final progInt = job.progress.value.toInt();

                      if (isDone) {
                        final isReviewed = job.isReviewed.value;
                        if (!isReviewed) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.amber.shade300),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  size: 14,
                                  color: Colors.amber.shade900,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  context.l10n.needsReview,
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 14,
                                color: Colors.green.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                context.l10n.reviewed,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (isFailed) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Text(
                            context.l10n.failed,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          context.l10n.processingProgress(progInt),
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 6),
                    Obx(() {
                      final isOpening =
                          controller.openingJobId.value == job.jobId;
                      if (isOpening) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorConstant.primary,
                            ),
                          ),
                        );
                      }
                      return const Icon(
                        Icons.chevron_right,
                        size: 20,
                        color: ColorConstant.textGreyColor,
                      );
                    }),
                  ],
                ),
                Obx(() {
                  if (job.isDone || job.isFailed) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (job.progress.value / 100.0).clamp(0.0, 1.0),
                        minHeight: 6,
                        backgroundColor: const Color(0xFFF1F5F9),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          ColorConstant.primary,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }

  /// Bottom navigation bar actions
  Widget _buildBottomBar(BuildContext context) {
    final isStep1 = controller.currentStep.value == CreateModuleStep.infoModul;

    if (isStep1) {
      return Padding(
        padding: const EdgeInsets.all(Dimens.innerPadding),
        child: CommonButtonWidget(
          buttonName: context.l10n.saveModule,
          boxShadows: const [],
          isValid: controller.isValid.value,
          isLoading: controller.isSavingModule.value,
          onPressed: controller.onSaveModule,
        ),
      );
    }

    // Step 2: Options to finish or go back
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(() {
          if (controller.trackedJobs.isEmpty) {
            return const SizedBox.shrink();
          }
          if (controller.hasRunningJobs) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: Dimens.innerPadding,
                vertical: 4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(Dimens.radius),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.annotationProgressNotice,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (!controller.allDoneChaptersReviewed) {
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: Dimens.innerPadding,
                vertical: 4,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(Dimens.radius),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: Colors.amber.shade900,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      context.l10n.reviewChaptersNotice,
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.goToPreviousStep,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimens.radius),
                    ),
                    side: const BorderSide(color: ColorConstant.textGreyColor),
                  ),
                  child: Text(
                    context.l10n.back,
                    style: const TextStyle(
                      color: ColorConstant.textGreyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spacePadding),
              Expanded(
                child: Obx(
                  () => CommonButtonWidget(
                    buttonName: context.l10n.finish,
                    boxShadows: const [],
                    isValid: controller.canFinishModule,
                    isLoading: controller.isPublishingModule.value,
                    onPressed: controller.onFinishAndPublishModule,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
