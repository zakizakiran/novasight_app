import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teacher/controllers/module_teacher_controller.dart';
class ModuleFilterStatusWidget extends GetView<ModuleTeacherController> {
  final ModuleTeacherStatus status;
  const ModuleFilterStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      final backgroundColor = isSelected ? ColorConstant.primary : ColorConstant.white;
      final color = isSelected ? ColorConstant.white : ColorConstant.textGreyColor;
      final fontWeight = isSelected ? FontWeight.w800 : FontWeight.w500;
      final borderColor = isSelected ? ColorConstant.primary : ColorConstant.borderBlueGrey;
      return GestureDetector(
        onTap: (){
          controller.onSelectedStatus(status);
        },
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 70
          ),
          padding: const EdgeInsets.all(Dimens.spacePadding),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(Dimens.radiusMedium)),
            border: BoxBorder.all(
              color: borderColor,
              width: 1,
            ),
          ),
          child: Text(
              status.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: fontWeight,
              color: color
            ),
          ),
        ),
      );
    });
  }
}
