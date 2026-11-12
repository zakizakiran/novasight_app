import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/args/add_chapter_args.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/date_helper.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/routes/app_pages.dart';
import '../../controllers/module_teacher_controller.dart';

class ModuleDetailBottomSheet extends GetView<ModuleTeacherController> {
  final TeacherModuleModel module;

  const ModuleDetailBottomSheet({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.moduleDetail,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.textDarkGreyColor,
                    ),
              ),
              Semantics(
                button: true,
                label: "Tutup dialog detail modul",
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
          const Divider(),

          // Body
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    module.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ColorConstant.textDarkGreyColor,
                        ),
                  ),
                  const SizedBox(height: Dimens.spaceSmallPadding),

                  // Metadata row: Fase, Date, Status
                  Wrap(
                    spacing: Dimens.spaceSmallPadding,
                    runSpacing: Dimens.spaceSmallPadding,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (module.faseId != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.secondary,
                            borderRadius: BorderRadius.circular(Dimens.radius),
                          ),
                          child: Text(
                            "${context.l10n.fase} ${module.faseId}",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: ColorConstant.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      Text(
                        DateHelper.dateFormat(module.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstant.textGreyColor,
                            ),
                      ),
                      _buildStatusBadge(context),
                    ],
                  ),

                  const SizedBox(height: Dimens.spaceBigPadding),

                  // Chapters Section Header
                  Text(
                    context.l10n.chapterList,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.textDarkGreyColor,
                        ),
                  ),
                  const SizedBox(height: Dimens.spaceSmallPadding),

                  // Chapters List from API
                  Obx(() {
                    if (controller.isLoadingDetail.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.innerPadding),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final detail = controller.selectedModuleDetail.value;
                    final chapters = detail?.chapters ?? [];

                    if (chapters.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimens.spacePadding),
                        decoration: BoxDecoration(
                          color: ColorConstant.grey,
                          borderRadius: BorderRadius.circular(Dimens.radius),
                        ),
                        child: Text(
                          context.l10n.noChaptersInModule,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ColorConstant.textGreyColor,
                                  ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: chapters.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimens.spaceSmallPadding),
                      itemBuilder: (context, index) {
                        final chapter = chapters[index];
                        return Semantics(
                          button: true,
                          label: "Buka detail bab ${chapter.title ?? 'Bab ${index + 1}'}",
                          child: InkWell(
                            onTap: () {
                              controller.showChapterDetailModal(
                                context,
                                chapter.id,
                              );
                            },
                            borderRadius: BorderRadius.circular(Dimens.radius),
                            child: Container(
                              padding: const EdgeInsets.all(Dimens.spacePadding),
                              decoration: BoxDecoration(
                                color: ColorConstant.white,
                                borderRadius:
                                    BorderRadius.circular(Dimens.radius),
                                border: Border.all(
                                  color: ColorConstant.borderBlueGrey,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.primary
                                          .withValues(alpha: 0.1),
                                      borderRadius:
                                          BorderRadius.circular(Dimens.radius),
                                    ),
                                    child: const Icon(
                                      Icons.menu_book,
                                      size: 20,
                                      color: ColorConstant.primary,
                                    ),
                                  ),
                                  const SizedBox(width: Dimens.spacePadding),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                           chapter.title ??
                                               context.l10n.chapterNumber((chapter.number ?? index + 1).toString()),
                                           style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: ColorConstant
                                                    .textDarkGreyColor,
                                              ),
                                        ),
                                        if (chapter.sourceFile != null &&
                                            chapter.sourceFile!.isNotEmpty)
                                          Text(
                                            chapter.sourceFile!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: ColorConstant
                                                      .textGreyColor,
                                                ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: ColorConstant.textGreyColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: Dimens.spaceSmallPadding),
                  Obx(() {
                    final chapters = controller.chaptersJobs;
                    if (!controller.isLoadingDetail.value && chapters.isNotEmpty) {
                      return _buildTrackedChapter(chapters);
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: Dimens.spaceBigPadding),
                  Obx(() {
                    if (!controller.isLoadingDetail.value) {
                      return CommonButtonWidget(
                        buttonName: context.l10n.addChapter,
                        textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        buttonWidth: double.infinity,
                        onPressed: () {
                          Get.toNamed(Routes.ADD_CHAPTER, arguments: AddChapterArgs(module: controller.selectedModuleDetail.value!, onChapterAdded: controller.addChapter));
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),

          // Actions Footer
          const SizedBox(height: Dimens.spacePadding),
          Obx(() {
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CommonButtonWidget(
                    buttonName: context.l10n.close,
                    buttonColor: ColorConstant.white,
                    border: const BorderSide(
                      color: ColorConstant.borderBlueGrey,
                    ),
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor,
                          fontWeight: FontWeight.w500,
                        ),
                    boxShadows: const [],
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: Dimens.spacePadding),
                if(controller.selectedModuleDetail.value != null)
                  Expanded(
                    flex: 4,
                    child: CommonButtonWidget(
                      buttonName: controller.selectedModuleDetail.value!.isPublished ? context.l10n.draftModule : context.l10n.publishModule,
                      boxShadows: const [],
                      onPressed: () async {
                        if(controller.selectedModuleDetail.value!.isPublished){
                          await controller.onDraftModule(module);
                        } else {
                          await controller.onPublishModule(module);
                        }
                      },
                    ),
                  ),
                const SizedBox(width: Dimens.spacePadding),
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: ColorConstant.redColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    border: Border.all(
                      color: ColorConstant.redColor.withValues(alpha: 0.4),
                      width: 1.2,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    onTap: () {
                      Get.back();
                      controller.confirmDeleteModule(context, module);
                    },
                    child: const Center(
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: ColorConstant.redColor,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrackedChapter(List<TeacherChapterSummaryModel> chapters){
    return ListView.separated(
      itemCount: chapters.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) =>
      const SizedBox(height: Dimens.spaceSmallPadding),
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        final job = chapter.job!;
        return InkWell(
          onTap: () {
            if(chapter.needsReview){
              controller.showChapterDetailModal(
                context,
                chapter.id,
              );
            }
            if(job.isInProgress){
              Get.toNamed(Routes.ADD_LOADING_CHAPTER, arguments: job.id);
            }
          },
          borderRadius: BorderRadius.circular(Dimens.radius),
          child: Container(
            padding: const EdgeInsets.all(Dimens.spacePadding),
            decoration: BoxDecoration(
              color: ColorConstant.white,
              borderRadius:
              BorderRadius.circular(Dimens.radius),
              border: Border.all(
                color: ColorConstant.borderBlueGrey,
              ),
            ),
            child: Row(
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
                      "${job.id}",
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
                        chapter.title ?? '',
                        style: Theme.of(context).textTheme.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() {
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
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: ColorConstant.textGreyColor,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    return Obx(() {
      final currentInList = controller.teacherModules.firstWhereOrNull(
        (m) => m.id == module.id,
      );
      final currentStatus = currentInList?.status ?? module.status;
      final isPublished = (currentStatus ?? '').toLowerCase() == 'publish';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPublished ? ColorConstant.lightGreen : ColorConstant.grey,
          borderRadius: BorderRadius.circular(Dimens.radius),
        ),
        child: Text(
          isPublished ? context.l10n.filterPublish : context.l10n.filterDraft,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isPublished
                    ? ColorConstant.green
                    : ColorConstant.textDarkGreyColor,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
    });
  }
}
