import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class CommonGradientProgressBarWidget extends StatelessWidget {
  final double percentage;
  final double height;
  final List<Color> colors;
  final List<double> stops;

  const CommonGradientProgressBarWidget({
    super.key,
    required this.percentage,
    this.height = 8,
    this.colors = const [],
    this.stops = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.circle),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(
                    color: ColorConstant.grey,
                  ),
                ),

                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    end: percentage.clamp(0.0, 1.0),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: constraints.maxWidth * value,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: colors,
                            stops: stops,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
