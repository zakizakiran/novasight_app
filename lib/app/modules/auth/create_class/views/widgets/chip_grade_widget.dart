import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';

import '../../../../../core/Dimens.dart';

class ChipGradeWidget extends StatelessWidget {
  final int value;
  final String label;
  final bool isSelected;
  final Function(int) onSelected;

  const ChipGradeWidget({
    super.key,
    required this.value,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final Color color =
        isSelected ? ColorConstant.primary : ColorConstant.grey;

    return Semantics(
      button: true,
      selected: isSelected,
      label: "$label, ${isSelected ? 'terpilih' : 'tidak terpilih'}",
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Dimens.radius),
        child: InkWell(
          onTap: () => onSelected(value),
          borderRadius: BorderRadius.circular(Dimens.radius),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: color, width: 1.5),
              borderRadius: BorderRadius.circular(Dimens.radius),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.innerMediumPadding,
              vertical: Dimens.innerMediumPadding + 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _checkWidget(selected: isSelected, color: color),
                const SizedBox(width: Dimens.spacePadding),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? ColorConstant.primary
                            : ColorConstant.textDarkGreyColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _checkWidget({
    required bool selected,
    required Color color,
  }) {
    final Color checkColor =
        selected ? ColorConstant.primary : ColorConstant.white;
    return Container(
      padding: const EdgeInsets.all(Dimens.spaceSmallPadding),
      decoration: BoxDecoration(
        color: checkColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        border: BoxBorder.all(width: 1.5, color: color),
      ),
      height: 24,
      width: 24,
      child: selected
          ? SvgPicture.asset(
              SvgConstant.iconCheck,
              colorFilter: const ColorFilter.mode(
                ColorConstant.white,
                BlendMode.srcIn,
              ),
              height: Dimens.iconRegularSize,
              width: Dimens.iconRegularSize,
            )
          : const SizedBox.shrink(),
    );
  }
}
