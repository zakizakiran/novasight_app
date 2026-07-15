import 'package:flutter/material.dart';

import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/styles/svg/svg_constant.dart';
import 'icon_auth_app.dart';

class ValidIconFieldWidget extends StatelessWidget {
  const ValidIconFieldWidget({
    super.key,
    required this.isValid,
  });

  final bool isValid;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: isValid,
        replacement: const SizedBox.shrink(),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.spacePadding),
          child: IconAuthApp(
            icon: "",
            iconSvg: SvgConstant.iconCheck,
            color: ColorConstant.green,
            shadowColor: ColorConstant.lightGreen,
            size: Dimens.iconRegularSize,
            padding: Dimens.spaceMediumPadding,
          ),
        )
    );
  }
}