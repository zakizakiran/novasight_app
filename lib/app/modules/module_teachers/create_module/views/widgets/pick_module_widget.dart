import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/file_helper.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/controllers/create_module_controller.dart';

import '../../../../../core/Dimens.dart';
class PickModuleWidget extends GetView<CreateModuleController> {

  const PickModuleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(Dimens.radius),
          ),
          child: InkWell(
            borderRadius: const BorderRadius.all(
              Radius.circular(Dimens.radius),
            ),
            onTap: controller.onPickModule,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorConstant.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.radius),
                ),
                border: Border.all(
                  color: ColorConstant.primary,
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                      SvgConstant.iconCloud,
                      width: Dimens.iconBigSize,
                      height: Dimens.iconBigSize,
                  ),
                  const SizedBox(height: Dimens.spacePadding),
                  Text(
                    "Ketuk untuk unggah file",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: Dimens.spacePadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ModuleTeacherType.values
                        .map((type) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimens.spaceSmallPadding,
                      ),
                      child: _buildAvailableFileType(type: type, context:context),
                    ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(() {
          final pdf = controller.selectedPdf.value;
          return pdf != null ? Container(
            padding: const EdgeInsets.all(
                Dimens.innerPadding
            ),
            decoration: BoxDecoration(
                color: ColorConstant.lightGreen,
                border: BoxBorder.all(
                    color: ColorConstant.green,
                    width: 1
                ),
                borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius))
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    spacing: Dimens.spacePadding,
                    children: [
                      _buildAvailableFileType(
                          type: ModuleTeacherType.pdf,
                          context: context,
                          textColor: ColorConstant.green,
                          backgroundColor: ColorConstant.secondaryLightGreen
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: Dimens.spacePadding,
                          children: [
                            Text(
                                pdf.name,
                              style: Theme.of(context).textTheme.headlineSmall
                            ),
                            Text(
                              "${FileHelper.formatFileSize(pdf.size)} · Siap diunggah",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColorConstant.textGreyColor
                              ),
                            )
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SvgPicture.asset(
                  SvgConstant.iconCheck,
                  colorFilter: const ColorFilter.mode(
                      ColorConstant.green,
                      BlendMode.srcIn
                  ),
                  height: Dimens.iconMediumSize,
                  width: Dimens.iconMediumSize,
                )
              ],
            ),
          ) : const SizedBox.shrink();
        })
      ],
    );
  }
  Widget _buildAvailableFileType({
      required ModuleTeacherType type,
      required BuildContext context,
      Color? textColor,
      Color? backgroundColor,
  }){
    return Container(
      padding: const EdgeInsets.all(Dimens.spacePadding),
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorConstant.secondary,
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
      ),
      child: Text(
        type.name,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: textColor ?? ColorConstant.primary),
      ),
    );
  }
}
