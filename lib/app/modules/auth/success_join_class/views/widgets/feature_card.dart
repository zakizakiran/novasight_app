import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

class FeatureCard extends StatelessWidget {
  final String iconTxt;
  final String description;
  const FeatureCard({super.key,required this.iconTxt,required this.description});

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            iconTxt,
            style: const TextStyle(
                fontSize: Dimens.iconRegularSize
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
