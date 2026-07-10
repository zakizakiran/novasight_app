import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class GradientProgressBarWidget extends StatelessWidget {
  final double percantage;
  final double height;
  const GradientProgressBarWidget({super.key, required this.percantage, this.height = 8});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.circle),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Container(
              color: ColorConstant.grey,
            ),

          //   Filled
            FractionallySizedBox(
              widthFactor: percantage.clamp(0.0, 1.0),
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ColorConstant.linearSecondary,
                        ColorConstant.linearPrimary,
                      ],
                    stops: const [
                      0.2,
                      1.0
                    ]
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
