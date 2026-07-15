import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';

import 'icon_auth_app.dart';

class AuthAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String icon;
  final String? iconSvg;
  final double height;
  final String title;
  final String description;
  final VoidCallback? onClickBack;
  const AuthAppbar({super.key,this.icon = IconTxt.chat, this.iconSvg, required this.title, required this.description, this.onClickBack,this.height = 180});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {

    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: ColorConstant.primary,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (onClickBack != null)
              Align(
                alignment: Alignment.centerLeft,
                child: IconAuthApp(
                  icon: "←",
                  onClick: onClickBack,
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconAuthApp(
                    icon: icon,
                    iconSvg : iconSvg,
                    padding: Dimens.innerPadding,
                    size: Dimens.iconMediumSize,
                ),
                const SizedBox(height: Dimens.spacePadding),
                Text(
                    title,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: ColorConstant.white
                  ),
                ),
                Text(description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.white
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class BottomCurveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    double insideHeightClip = size.height * 0.25;


    path.lineTo(0, size.height);

    var controlPoint = Offset(size.width / 2, size.height - insideHeightClip);
    var endPoint = Offset(size.width, size.height);

    path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy
    );
    
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}