import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';

import '../core/Dimens.dart';
import '../core/styles/colors/color_constant.dart';
class CommonDialogWidget extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final Widget? actions;

  const CommonDialogWidget({
    super.key,
    required this.title,
    this.description,
    this.icon,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(Dimens.radiusMedium),
          border: BorderStyleConstant.outlineBorderCard,
          boxShadow: const [
            BoxShadowConstant.module,
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: Dimens.spacePadding),
            ],

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: ColorConstant.linearPrimary,
              ),
            ),

            if (description != null) ...[
              const SizedBox(height: Dimens.spacePadding),
              Text(
                description!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: ColorConstant.linearPrimary,
                ),
              ),
            ],

            const SizedBox(height: Dimens.spaceBigPadding),

            if (actions != null)
              Align(
                alignment: Alignment.center,
                child: actions!,
              ),
          ],
        ),
      ),
    );
  }
}