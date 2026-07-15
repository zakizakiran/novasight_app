import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class StepIndicatorWidget extends StatelessWidget {
  final int step;
  final int maxStep;
  const StepIndicatorWidget({super.key, required this.step, required this.maxStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.circle),
        color: ColorConstant.white.withValues(alpha: 0.2)
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.spaceMediumPadding,
        vertical: Dimens.spaceSmallPadding,
      ),
      child: Text(
          "Langkah $step / $maxStep",
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: ColorConstant.white
        ),
      ),
    );
  }
}
