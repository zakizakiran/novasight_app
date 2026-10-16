import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';

class CommonAppBar extends StatelessWidget {
  final String icon;
  final String? iconSvg;
  final double? height;
  final String? title;
  final String description;
  final bool? showBackButton;
  const CommonAppBar({
    super.key,
    this.icon = IconTxt.chat,
    this.iconSvg,
    this.title,
    required this.description,
    this.height,
    this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final canGoBack =
        showBackButton ?? (Get.key.currentState?.canPop() ?? false);
    return Container(
      constraints: BoxConstraints(minHeight: height * 0.16),
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.innerPadding),
      decoration: const BoxDecoration(color: ColorConstant.primary),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: Dimens.spacePadding,
        children: [
          if (canGoBack)
            Semantics(
              button: true,
              label: "Kembali",
              child: GestureDetector(
                onTap: Get.back,
                child: const Icon(
                  Icons.arrow_back_ios_sharp,
                  color: ColorConstant.white,
                  size: Dimens.iconMediumSize,
                ),
              ),
            ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: ColorConstant.white),
                  ),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: ColorConstant.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
