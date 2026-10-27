import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/styles/svg/svg_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/model/module_teacher_model.dart';
import 'package:lydera_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';
import '../../../../../core/Dimens.dart';

class SelectWidget extends GetView<ModuleEvaluationController> {
  final ModuleChunk chunk;
  final int? blockNumber;
  const SelectWidget({super.key, required this.chunk, this.blockNumber});

  @override
  Widget build(BuildContext context) {
    final displayBlock =
        blockNumber != null ? "Block $blockNumber" : "Block #${chunk.id}";
    final isImage = chunk is ImageChunk;
    final imageChunk = isImage ? (chunk as ImageChunk) : null;
    final badgeLabel = imageChunk != null ? imageChunk.displayTypeLabel : "Teks";

    IconData badgeIcon = Icons.text_fields_outlined;
    Color badgeColor = Colors.blue.shade800;
    Color badgeBg = Colors.blue.withValues(alpha: 0.15);

    if (imageChunk != null) {
      if (imageChunk.isTable) {
        badgeIcon = Icons.table_chart_outlined;
        badgeColor = Colors.teal.shade800;
        badgeBg = Colors.teal.withValues(alpha: 0.15);
      } else if (imageChunk.isFormula) {
        badgeIcon = Icons.functions;
        badgeColor = Colors.purple.shade800;
        badgeBg = Colors.purple.withValues(alpha: 0.15);
      } else if (imageChunk.isDiagram) {
        badgeIcon = Icons.insert_chart_outlined;
        badgeColor = Colors.indigo.shade800;
        badgeBg = Colors.indigo.withValues(alpha: 0.15);
      } else {
        badgeIcon = Icons.image_outlined;
        badgeColor = Colors.deepOrange;
        badgeBg = Colors.orange.withValues(alpha: 0.15);
      }
    }

    return Obx(() {
      final selected = controller.selectedChunks.contains(chunk);
      final borderColor =
          selected ? ColorConstant.primary : ColorConstant.borderBlueGrey;
      final backgroundColor =
          selected ? ColorConstant.primary : ColorConstant.white;

      return InkWell(
        onTap: () => controller.onSelectChunk(chunk),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.spacePadding,
            vertical: Dimens.innerMediumPadding,
          ),
          decoration: BoxDecoration(
            color: selected
                ? ColorConstant.primary.withValues(alpha: 0.08)
                : ColorConstant.darkWhite,
            border: Border.all(
              color: selected
                  ? ColorConstant.primary
                  : ColorConstant.borderBlueGrey,
              width: selected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: Dimens.iconMidSize,
                width: Dimens.iconMidSize,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: borderColor,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: selected
                    ? SvgPicture.asset(
                        SvgConstant.iconCheck,
                        colorFilter: const ColorFilter.mode(
                          ColorConstant.white,
                          BlendMode.srcIn,
                        ),
                        height: 14,
                        width: 14,
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(width: 10),
              Text(
                displayBlock,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? ColorConstant.primary
                          : ColorConstant.black,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      badgeIcon,
                      size: 13,
                      color: badgeColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      badgeLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: badgeColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (selected)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isImage ? Colors.deepOrange : ColorConstant.primary,
                    borderRadius: BorderRadius.circular(Dimens.circle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 12, color: ColorConstant.white),
                      const SizedBox(width: 4),
                      Text(
                        isImage ? "Revisi AI" : "Edit Langsung",
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.white,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text(
                  isImage ? context.l10n.selectToRevisionAI : context.l10n.selectToRevisionAI,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: ColorConstant.textGreyColor,
                      ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
