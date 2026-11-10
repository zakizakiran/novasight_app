import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';

class FeatureCard extends StatelessWidget {
  final String? iconTxt;
  final IconData? iconData;
  final String description;
  const FeatureCard({
    super.key,
    this.iconTxt,
    this.iconData,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      decoration: BoxDecoration(
        color: ColorConstant.secondary,
        borderRadius: BorderRadius.circular(Dimens.radius),
      ),
      child: Row(
        spacing: Dimens.spacePadding,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconData != null)
            Icon(
              iconData,
              color: ColorConstant.primary,
              size: Dimens.iconMidSize,
            )
          else if (iconTxt != null)
            Text(
              iconTxt!,
              style: const TextStyle(
                fontSize: Dimens.iconRegularSize,
              ),
            ),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }
}
