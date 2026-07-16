import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/Dimens.dart';
import '../core/styles/colors/color_constant.dart';
class CommonTeacherAppbar extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  const CommonTeacherAppbar({
    super.key,
    required this.title,
    this.backgroundColor = ColorConstant.background
  });

  @override
  Widget build(BuildContext context) {
      final height = MediaQuery.of(context).size.height;
      final canGoBack = (Get.key.currentState?.canPop() ?? false);
      return Container(
        constraints: BoxConstraints(
          minHeight: height * 0.1,
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(Dimens.innerPadding),
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [

            if (canGoBack)
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: Get.back,
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.arrow_back_sharp,
                      color: ColorConstant.informationColor,
                      size: Dimens.iconMediumSize,
                    ),
                  ),
                ),
              ),

            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: Dimens.spaceSmallPadding),
              ],
            ),
          ],
        ),
      );
  }
}
