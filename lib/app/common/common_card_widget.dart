import 'package:flutter/material.dart';

import '../core/Dimens.dart';
import '../core/styles/colors/color_constant.dart';

class CommonCardWidget extends StatelessWidget {
  final Widget child;
  final BoxBorder? border;
  final EdgeInsets? margin;
  final List<BoxShadow>? boxShadow;
  final void Function()? onPressed;
  const CommonCardWidget({super.key,required this.child, this.border, this.margin, this.boxShadow, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorConstant.white,
      borderRadius: BorderRadius.circular(Dimens.radius),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(Dimens.radius),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: boxShadow,
            border: border,
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
          ),
          margin: margin,
          padding: EdgeInsets.all(Dimens.innerPadding),
          child: child,
        ),
      ),
    );
  }
}
