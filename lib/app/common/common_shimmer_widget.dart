import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final Widget? child;
  final double height;
  final double? width;
  final double? radius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const ShimmerWidget({
    super.key,
    this.child,
    required this.height,
    this.width,
    this.radius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      width: width ?? double.infinity,
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      child: Shimmer.fromColors(
        baseColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300,
        highlightColor:
        isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
        child: child ??
            Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(radius ?? 10),
              ),
            ),
      ),
    );
  }
}