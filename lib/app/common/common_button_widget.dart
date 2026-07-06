import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../core/Dimens.dart';

class CommonButtonWidget extends StatelessWidget {
  final String buttonName;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? rounded;
  final Color? buttonColor;
  final Function() onPressed;
  final TextStyle? textStyle;
  final BorderSide? border;
  final Widget? child;
  const CommonButtonWidget({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.buttonHeight = 50,
    this.rounded = Dimens.radius,
    this.buttonColor = ColorConstant.primary,
    this.textStyle,
    this.buttonWidth,
    this.border,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth ?? double.infinity,
      height: buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rounded!),
          boxShadow: const [
            BoxShadow(
              color: ColorConstant.primaryShadow,
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
            side: WidgetStatePropertyAll(border),
            elevation: const WidgetStatePropertyAll(0),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            backgroundColor: WidgetStatePropertyAll(buttonColor),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  rounded!,
                ),
              ),
            ),
          ),
          child: Center(
            child: child ??
                Text(
                  buttonName,
                  style:
                  textStyle ?? Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ColorConstant.white
                  ),
                  textAlign: TextAlign.center,
                ),
          ),
        ),
      ),
    );
  }
}