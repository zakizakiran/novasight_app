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
    return Container(
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(Dimens.radius),
      ),
      child: Material(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(Dimens.radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(Dimens.radius),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              border: border,
              borderRadius: BorderRadius.circular(Dimens.radius),
            ),
            margin: margin,
            padding: const EdgeInsets.all(Dimens.innerPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}
