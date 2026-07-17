import 'package:flutter/material.dart';
import '../../../../core/dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';

Widget buildFieldLabel(BuildContext context, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: ColorConstant.textDarkGreyColor,
      ),
    ),
  );
}

Widget buildSelectableButton(
  BuildContext context,
  String label,
  bool isSelected,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? ColorConstant.primary : ColorConstant.white,
        borderRadius: BorderRadius.circular(Dimens.radius),
        border: Border.all(
          color: isSelected
              ? ColorConstant.primary
              : ColorConstant.grey.withValues(alpha: 0.5),
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? ColorConstant.white
              : ColorConstant.textDarkGreyColor,
        ),
      ),
    ),
  );
}
