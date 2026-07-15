import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../core/dimens.dart';

class CommonButtonWidget extends StatelessWidget {
  final String buttonName;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? rounded;
  final Color? buttonColor;
  final Function() onPressed;
  final TextStyle? textStyle;
  final bool isLoading;
  final bool isValid;
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
    this.isLoading = false,
    this.isValid = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
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
          onPressed: (){
            if(isValid && !isLoading){
                onPressed();
            }
          },
          style: ButtonStyle(
            minimumSize: const WidgetStatePropertyAll(Size.zero),
            side: WidgetStatePropertyAll(border),
            elevation: const WidgetStatePropertyAll(0),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            backgroundColor: WidgetStatePropertyAll(isValid ? buttonColor : ColorConstant.grey),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  rounded!,
                ),
              ),
            ),
          ),
          child: Center(
            child: isLoading ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3.5,
                color: ColorConstant.white,
              ),
            ) : child ??
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