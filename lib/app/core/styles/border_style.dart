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
}