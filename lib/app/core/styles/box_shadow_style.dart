import 'package:flutter/cupertino.dart';

import 'colors/color_constant.dart';

class BoxShadowConstant {
  BoxShadowConstant._();

  static const auth = BoxShadow(
    color: ColorConstant.shadowAuthColor,
    blurRadius: 24,
    spreadRadius: 0,
    offset: Offset(0, 8),
  );

  static const module = BoxShadow(
    color: ColorConstant.shadowColor,
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );

  static const subjectPage = BoxShadow(
    color: ColorConstant.shadowAuthColor,
    blurRadius: 10,
    spreadRadius: 0,
    offset: Offset(0, 4),
  );
}