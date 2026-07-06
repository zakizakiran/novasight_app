import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/dimens.dart';

class CommonTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final TextStyle? hintStyle;
  final bool? isPassword;
  final String hint;
  final Color? fillColor;
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
    this.prefixIcon,
    required this.hint,
    this.isPassword,
    this.suffixIcon,
    this.fillColor,
    this.borderSide = BorderSide.none,
    this.borderSideEnable = BorderSide.none,
    this.borderSideFocused = BorderSide.none,
    this.hintStyle
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword ?? false,
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius),
          borderSide: borderSide,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius),
          borderSide: borderSideEnable,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius),
          borderSide: borderSideFocused,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: fillColor,
        hintText: hint,
        filled: true,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 12.0,
        ),
      ),
    );
  }
}

