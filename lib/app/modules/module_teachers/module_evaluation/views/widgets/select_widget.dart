import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';
import '../../../../../core/Dimens.dart';

class SelectWidget extends GetView<ModuleEvaluationController> {
  final ModuleChunk chunk;
  const SelectWidget({super.key, required this.chunk});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedChunks.contains(chunk);
      final borderColor = selected ? ColorConstant.primary : ColorConstant.borderBlueGrey;
      final backgroundColor = selected ? ColorConstant.primary : ColorConstant.white;

      return Container(
        padding: const EdgeInsets.all(Dimens.innerMediumPadding),
        decoration: BoxDecoration(
          color: ColorConstant.darkWhite,
          border: Border.all(
            color: ColorConstant.borderBlueGrey,
            width: 1.5,
          ),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              controller.onSelectChunk(chunk);
            },
            child: Container(
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
          ),
        ),
      );
    });
  }
}
