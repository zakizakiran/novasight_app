import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

class IconAuthApp extends StatelessWidget {
  final String icon;
  final double? padding;
  final String? iconSvg;
  final double? size;
  final Color color;
  final Color shadowColor;
  final VoidCallback? onClick;
  const IconAuthApp({super.key,this.iconSvg, required this.icon, this.padding, this.onClick, this.size = 12,
    this.color = ColorConstant.white, this.shadowColor = ColorConstant.whiteShadowColor
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.circle)),
        child: Container(
          padding: EdgeInsets.all(padding ?? Dimens.mediumPadding),
          decoration: BoxDecoration(
            color: shadowColor,
            shape: BoxShape.circle,
          ),
          child:
          iconSvg == null ? Text(
              icon,
            style: TextStyle(
              fontSize: size,
              color: color
            ),
          ) : SvgPicture.asset(
            iconSvg!,
            colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn
            ),
            height: size ?? Dimens.iconMediumSize,
            width: size ?? Dimens.iconMediumSize,
          ),
        ),
      ),
    );
  }
}
