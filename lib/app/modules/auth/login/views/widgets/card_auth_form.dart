import 'package:flutter/material.dart';

import '../../../../../core/Dimens.dart';
import '../../../../../core/styles/colors/color_constant.dart';

class CardAuthForm extends StatelessWidget {
  final Widget child;
  const CardAuthForm({super.key,required this.child,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: ColorConstant.shadowAuthColor,
              blurRadius: 24,
              spreadRadius: 0,
              offset: Offset(0, 8)
          )
        ],
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(Dimens.radius),
      ),
      margin: EdgeInsets.only(top: Dimens.innerPadding),
      padding: EdgeInsets.all(Dimens.innerPadding),
      child: child,
    );
  }
}
