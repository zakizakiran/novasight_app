import 'package:flutter/cupertino.dart';

import '../Dimens.dart';
import 'colors/color_constant.dart';
class BorderStyleConstant {
  BorderStyleConstant._();

  static const outlineBorderCard = Border.fromBorderSide(
    BorderSide(
        color:ColorConstant.borderNormalGrey,
        width: Dimens.border
    )
  );

  static const borderTeacherAppbar = BoxBorder.symmetric(
    horizontal: BorderSide(
      color: ColorConstant.borderBlueGrey,
      width: 1
    )
  );
}