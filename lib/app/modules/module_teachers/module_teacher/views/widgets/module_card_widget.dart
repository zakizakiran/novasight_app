import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/box_shadow_style.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/date_helper.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import '../../controllers/module_teacher_controller.dart';

class ModuleTeacherCardWidget extends GetView<ModuleTeacherController> {
  final TeacherModuleModel module;

  const ModuleTeacherCardWidget({
    super.key,
    required this.module,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacePadding),
      margin: const EdgeInsets.symmetric(
        vertical: Dimens.spaceSmallPadding,
      ),
      decoration: const BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius)),
        boxShadow: [
          BoxShadowConstant.module,
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFaseBadge(context),
              const SizedBox(width: Dimens.spacePadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      module.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkGreyColor,
                          ),
                    ),
                    const SizedBox(height: Dimens.spaceSmallPadding),
                    Text(
                      DateHelper.dateFormat(module.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConstant.textGreyColor,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimens.spacePadding),
              _buildStatusBadge(context),
            ],
          ),
          const SizedBox(height: Dimens.spacePadding),
          Row(
            children: [
              // Tombol Lihat Modul
              Expanded(
                flex: 4,
                child: Semantics(
                  button: true,
                  label: "Lihat detail modul ${module.title}",
                  child: CommonButtonWidget(
                    buttonName: context.l10n.viewModule,
                    buttonColor: ColorConstant.white,
                    border: const BorderSide(
                      color: ColorConstant.borderBlueGrey,
                      width: 1,
                    ),
                    boxShadows: const [],
                    textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.informationColor,
                          fontWeight: FontWeight.w500,
                        ),
                    onPressed: () {
                      controller.showModuleDetailModal(context, module);
                    },
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spacePadding),

              // Tombol Publish Modul
              Expanded(
                flex: 4,
                child: Obx(() {
                  final isThisPublishing = controller.isPublishing.value &&
                      controller.publishingModuleId.value == module.id;
                  final isPublished =
                      (module.status ?? '').toLowerCase() == 'publish';

                  return Semantics(
                    button: true,
                    enabled: !isPublished && !isThisPublishing,
                    label: isPublished
                        ? "Modul sudah dipublikasikan"
                        : "Publikasikan modul ${module.title}",
                    child: isThisPublishing
                        ? Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color:
                                  ColorConstant.primary.withValues(alpha: 0.7),
                              borderRadius:
                                  BorderRadius.circular(Dimens.radius),
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
                            buttonName:
                                isPublished ? context.l10n.published : context.l10n.publishModule,
                            isValid: !isPublished,
                            boxShadows: const [],
                            onPressed: () {
                              controller.onPublishModule(module);
                            },
                          ),
                  );
                }),
              ),
              const SizedBox(width: Dimens.spacePadding),

              // Tombol Hapus Modul
              Obx(() {
                final isThisDeleting = controller.isDeleting.value &&
                    controller.deletingModuleId.value == module.id;

                return Semantics(
                  button: true,
                  label: "Hapus modul ${module.title}",
                  child: Container(
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
                      onTap: isThisDeleting
                          ? null
                          : () => controller.confirmDeleteModule(context, module),
                      child: Center(
                        child: isThisDeleting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorConstant.redColor,
                                ),
                              )
                            : const Icon(
                                Icons.delete_outline_rounded,
                                color: ColorConstant.redColor,
                                size: 22,
                              ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFaseBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: const BoxDecoration(
        color: ColorConstant.secondary,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius)),
      ),
      child: Text(
        module.faseId != null ? "${context.l10n.fase} ${module.faseId}" : context.l10n.navModule,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final isPublished = (module.status ?? '').toLowerCase() == 'publish';
    final textColor =
        isPublished ? ColorConstant.green : ColorConstant.textDarkGreyColor;
    final backgroundColor =
        isPublished ? ColorConstant.lightGreen : ColorConstant.grey;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
      ),
      child: Text(
        isPublished ? context.l10n.filterPublish : context.l10n.filterDraft,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
