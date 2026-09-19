import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/date_helper.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
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
                "Detail Modul",
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
                            "Fase ${module.faseId}",
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
                    "Daftar Bab / Materi",
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
                          "Belum ada bab atau materi yang ditambahkan pada modul ini.",
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
                                              "Bab ${chapter.number ?? index + 1}",
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
                ],
              ),
            ),
          ),

          // Actions Footer
          const SizedBox(height: Dimens.spacePadding),
          Obx(() {
            final isPublished = (module.status ?? '').toLowerCase() == 'publish';
            final isPublishingThis = controller.isPublishing.value &&
                controller.publishingModuleId.value == module.id;

            if (isPublished) {
              return Row(
                children: [
                  Expanded(
                    child: CommonButtonWidget(
                      buttonName: "Tutup",
                      onPressed: () => Get.back(),
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
            }

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CommonButtonWidget(
                    buttonName: "Tutup",
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
                Expanded(
                  flex: 4,
                  child: isPublishingThis
                      ? Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColorConstant.primary.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(Dimens.radius),
                          ),
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : CommonButtonWidget(
                          buttonName: "Publish Modul",
                          boxShadows: const [],
                          onPressed: () async {
                            await controller.onPublishModule(module);
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
          isPublished ? "Publish" : "Draft",
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
