import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

class IconAuthApp extends StatelessWidget {
  final String icon;
  final double? padding;
  final String? iconSvg;
  final double size;
  final VoidCallback? onClick;
  const IconAuthApp({super.key,this.iconSvg, required this.icon, this.padding, this.onClick, this.size = 12});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: EdgeInsets.all(padding ?? Dimens.mediumPadding),
          decoration: BoxDecoration(
            color: ColorConstant.whiteShadowColor,
            shape: BoxShape.circle,
          ),
          child:
          iconSvg == null ? Text(
              icon,
            style: TextStyle(
              fontSize: size
            ),
          ) : SvgPicture.asset(
            iconSvg!,
            colorFilter: ColorFilter.mode(
                ColorConstant.white,
                BlendMode.srcIn
            ),
            height: Dimens.iconMediumSize,
            width: Dimens.iconMediumSize,
            // color: ColorConstant.white,
            // size: Dimens.iconMediumSize,
          ),
        ),
      ),
    );
  }
}
