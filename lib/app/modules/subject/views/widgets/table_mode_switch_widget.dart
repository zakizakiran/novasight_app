import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/utils/table_mode.dart';

import '../../../../common/common_switch_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/l10n_extension.dart';

class TableModeSwitchWidget extends StatelessWidget {
  final TableMode selectedMode;
  final ValueChanged<TableMode> onChanged;

  const TableModeSwitchWidget({
    super.key,
    required this.selectedMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CommonSwitchWidget<TableMode>(
      selectedValue: selectedMode,
      values: const [
        TableMode.cell,
        TableMode.sentence,
      ],
      onChanged: onChanged,
      labelBuilder: (isDetailModeCell) {
        switch (isDetailModeCell) {
          case TableMode.cell:
            return context.l10n.modeDetailCell;
          case TableMode.sentence:
            return context.l10n.modeDetailSentences;
        }
      },
      height: 50,
      animationDuration: const Duration(milliseconds: 250),
      backgroundColor: ColorConstant.secondary,
      selectedColor: ColorConstant.primary,
      selectedTextColor: ColorConstant.white,
      unselectedTextColor: ColorConstant.textGreyColor,
      borderRadius: const BorderRadius.all(
        Radius.circular(Dimens.radius),
      ),
    );
  }
}
