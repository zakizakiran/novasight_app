import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import '../../controllers/module_teacher_controller.dart';

class ModuleFilterStatusWidget extends GetView<ModuleTeacherController> {
  final TeacherModuleStatus status;

  const ModuleFilterStatusWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedStatus.value == status;
      final backgroundColor =
          isSelected ? ColorConstant.primary : ColorConstant.white;
      final color =
          isSelected ? ColorConstant.white : ColorConstant.textGreyColor;
      final fontWeight = isSelected ? FontWeight.w800 : FontWeight.w500;
      final borderColor =
          isSelected ? ColorConstant.primary : ColorConstant.borderBlueGrey;

      return Semantics(
        button: true,
        selected: isSelected,
        label: "Filter status ${status.label}",
        child: InkWell(
          onTap: () {
            controller.onSelectedStatus(status);
          },
          borderRadius: const BorderRadius.all(
            Radius.circular(Dimens.radiusMedium),
          ),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 70,
              minHeight: 48,
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spacePadding,
              vertical: Dimens.spaceSmallPadding,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(Dimens.radiusMedium),
              ),
              border: Border.all(
                color: borderColor,
                width: 1,
              ),
            ),
            child: Text(
              status.label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: fontWeight,
                    color: color,
                  ),
            ),
          ),
        ),
      );
    });
  }
}
