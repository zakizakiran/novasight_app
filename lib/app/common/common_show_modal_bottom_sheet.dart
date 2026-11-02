import 'package:flutter/material.dart';

import '../core/Dimens.dart';
import '../core/styles/colors/color_constant.dart';

class CommonShowModalBottomSheet extends StatelessWidget {
  final Widget child;
  final double? padding;
  const CommonShowModalBottomSheet({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(padding ?? Dimens.innerPadding),
          child: child,
        ),
      ),
    );
  }
}

