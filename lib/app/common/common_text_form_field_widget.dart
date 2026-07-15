import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novasight_app/app/core/dimens.dart';

import '../core/styles/colors/color_constant.dart';

class CommonTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? title;
  final bool isReadOnly;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final List<TextInputFormatter> inputFormatters;
  final Function(String)? onChanged;
  final TextStyle? hintStyle;
  final bool? isPassword;
  final AutovalidateMode autovalidateMode;
  final String hint;
  final Color? fillColor;
  final Color focusedColor;
  final Color enableColor;
  final Color? successColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BorderSide borderSide;
  final BorderSide borderSideEnable;
  final BorderSide borderSideFocused;

  const CommonTextFormFieldWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.title,
    this.prefixIcon,
    this.isReadOnly = false,
    required this.hint,
    this.isPassword,
    this.inputFormatters = const [],
    this.suffixIcon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.fillColor,
    this.enableColor = ColorConstant.grey,
    this.focusedColor = ColorConstant.black,
    this.successColor,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.borderSide = BorderSide.none,
    this.borderSideEnable = BorderSide.none,
    this.borderSideFocused = BorderSide.none,
    this.hintStyle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title != null)
          Text("$title *",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700
          )),

        ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context,value,_){
              final hasText = value.text.isNotEmpty;
              final color = hasText
                  ? (successColor ?? enableColor)
                  : enableColor;
              return TextFormField(
                obscureText: isPassword ?? false,
                validator: validator,
                controller: controller,
                readOnly: isReadOnly,
                onChanged: onChanged,
                textAlign: textAlign,
                style: textStyle,
                autovalidateMode: autovalidateMode,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    borderSide: borderSideEnable.copyWith(
                      color: color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    borderSide: borderSideFocused.copyWith(
                      color: focusedColor
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    borderSide: borderSideEnable.copyWith(
                        color: ColorConstant.redColor
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    borderSide: borderSideFocused.copyWith(
                        color: ColorConstant.redColor
                    ),
                  ),
                  suffixIcon: suffixIcon,
                  prefixIcon: prefixIcon == null ? null : Container(margin: const EdgeInsets.all(Dimens.spacePadding),
                    child: prefixIcon,),
                  prefixIconConstraints: const BoxConstraints(
                      minWidth: Dimens.iconRegularSize,
                      minHeight: Dimens.iconRegularSize
                  ),
                  fillColor: fillColor,
                  hintText: hint,
                  filled: true,
                  hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyMedium,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 12.0,
                  ),
                ),
                inputFormatters: inputFormatters,
              );
            }
        ),
      ],
    );
  }
}

