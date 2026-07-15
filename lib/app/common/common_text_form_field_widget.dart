import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novasight_app/app/common/common_gradient_progress_bar_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/utils/validate_helper.dart';

import '../core/styles/colors/color_constant.dart';

class CommonTextFormFieldWidget extends StatefulWidget {
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
  final bool enableLinearPassword;
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
    this.enableLinearPassword = false,
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
  State<CommonTextFormFieldWidget> createState() => _CommonTextFormFieldWidgetState();
}

class _CommonTextFormFieldWidgetState extends State<CommonTextFormFieldWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.title != null)
          Text("${widget.title}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700
              )
          ),

        ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context,value,_){
              final hasText = value.text.isNotEmpty;
              final color = hasText
                  ? (widget.successColor ?? widget.enableColor)
                  : widget.enableColor;
              return Column(
                spacing: Dimens.spacePadding,
                children: [
                  TextFormField(
                    obscureText: _obscureText,
                    validator: widget.validator,
                    controller: widget.controller,
                    readOnly: widget.isReadOnly,
                    onChanged: widget.onChanged,
                    textAlign: widget.textAlign,
                    style: widget.textStyle ?? Theme.of(context).textTheme.bodyMedium,
                    autovalidateMode: widget.autovalidateMode,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius),
                        borderSide: widget.borderSideEnable.copyWith(
                          color: color
                        ),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius),
                        borderSide: widget.borderSideFocused.copyWith(
                          color: widget.focusedColor
                        ),
                      ),

                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius),
                        borderSide: widget.borderSideEnable.copyWith(
                            color: ColorConstant.redColor
                        ),
                      ),

                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius),
                        borderSide: widget.borderSideFocused.copyWith(
                            color: ColorConstant.redColor
                        ),
                      ),
                      suffixIcon: widget.suffixIcon ?? (widget.isPassword == true
                          ? IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: ColorConstant.informationColor,
                        ),
                      )
                          : null),
                      prefixIcon: widget.prefixIcon == null ? null : Container(margin: const EdgeInsets.all(Dimens.spacePadding),
                        child: widget.prefixIcon,),
                      prefixIconConstraints: const BoxConstraints(
                          minWidth: Dimens.iconRegularSize,
                          minHeight: Dimens.iconRegularSize
                      ),
                      suffixIconConstraints: const BoxConstraints(
                          minWidth: Dimens.iconRegularSize,
                          minHeight: Dimens.iconRegularSize,
                      ),
                      fillColor: widget.fillColor,
                      hintText: widget.hint,
                      filled: true,
                      hintStyle: widget.hintStyle ?? Theme.of(context).textTheme.bodyMedium,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 12.0,
                      ),
                    ),
                    inputFormatters: widget.inputFormatters,
                  ),
                  if(widget.enableLinearPassword)
                    passwordLinear(value: value.text)
                ],
              );
            }
        ),
      ],
    );
  }

  Widget passwordLinear({
    required String value
}){
    double percentage = ValidateHelper.passwordToPercentage(value);
    String indicator = ValidateHelper.passwordIndicator(percentage);
    Color indicatorColor = ValidateHelper.passwordColorIndicator(percentage);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.spaceMediumPadding,
      children: [
        CommonGradientProgressBarWidget(
          percentage: percentage,
          colors: [
            indicatorColor
          ],
          stops: const [
            1.0
          ],
        ),
        Text(
            textAlign: TextAlign.start,
            indicator,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: indicatorColor
            ),
        )
      ],
    );
  }
}

