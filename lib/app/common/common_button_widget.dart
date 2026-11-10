import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';

import '../core/dimens.dart';

enum ButtonSize { large, medium, small }

class CommonButtonWidget extends StatelessWidget {
  final String buttonName;
  final double? buttonHeight;
  final double? buttonWidth;
  final double? rounded;
  final Color? buttonColor;
  final Function() onPressed;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Color? textColor;
  final bool isLoading;
  final List<BoxShadow> boxShadows;
  final bool isValid;
  final BorderSide? border;
  final Widget? child;
  final ButtonSize size;

  const CommonButtonWidget({
    super.key,
    required this.buttonName,
    required this.onPressed,
    this.buttonHeight,
    this.rounded = Dimens.radiusMd,
    this.buttonColor = ColorConstant.primary,
    this.textStyle,
    this.buttonWidth,
    this.border,
    this.child,
    this.textColor = ColorConstant.white,
    this.isLoading = false,
    this.isValid = true,
    this.size = ButtonSize.medium,
    this.boxShadows = const [
      BoxShadow(
        color: ColorConstant.primaryShadow,
        offset: Offset(0, 4),
        blurRadius: 10,
        spreadRadius: 2,
      ),
    ],
    this.padding,
  });

  double get _height => switch (size) {
        ButtonSize.large => Dimens.buttonLarge,
        ButtonSize.medium => Dimens.buttonMedium,
        ButtonSize.small => Dimens.buttonSmall,
      };

  double get _paddingX => switch (size) {
        ButtonSize.large => Dimens.spaceLg,
        ButtonSize.medium => Dimens.spaceMd,
        ButtonSize.small => Dimens.radiusMd,
      };

  double get _fontSize => switch (size) {
        ButtonSize.large => 16,
        ButtonSize.medium => 16,
        ButtonSize.small => 14,
      };

  @override
  Widget build(BuildContext context) {
    final effectiveHeight = buttonHeight ?? _height;
    final effectivePadding = padding ??
        EdgeInsets.symmetric(horizontal: _paddingX, vertical: Dimens.spaceSm);

    return Semantics(
      button: true,
      enabled: isValid && !isLoading,
      label: isLoading ? '$buttonName sedang memproses' : buttonName,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: effectiveHeight,
          minWidth: buttonWidth ?? Dimens.minButtonWidth,
        ),
        child: SizedBox(
          width: buttonWidth,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(rounded!),
              boxShadow: boxShadows,
            ),
            child: ElevatedButton(
              onPressed: () {
                if (isValid && !isLoading) {
                  onPressed();
                }
              },
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(effectivePadding),
                minimumSize: WidgetStatePropertyAll(
                  Size(buttonWidth ?? Dimens.minButtonWidth, effectiveHeight),
                ),
                side: WidgetStatePropertyAll(border),
                elevation: const WidgetStatePropertyAll(0),
                shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                backgroundColor: WidgetStatePropertyAll(
                  isValid ? buttonColor : ColorConstant.grey,
                ),
                foregroundColor: WidgetStatePropertyAll(textColor),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(rounded!),
                  ),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3.5,
                        color: ColorConstant.white,
                      ),
                    )
                  : child ??
                      Text(
                        buttonName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: textStyle ??
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontSize: _fontSize,
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
