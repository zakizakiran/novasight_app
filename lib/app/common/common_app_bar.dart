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
  const CommonAppBar({super.key,this.icon = IconTxt.chat, this.iconSvg, this.title, required this.description,this.height});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final canGoBack = Get.key.currentState?.canPop() ?? false;
    return Container(
      constraints: BoxConstraints(
        minHeight: height * 0.13
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.innerPadding),
      decoration: const BoxDecoration(
        color: ColorConstant.primary,
      ),
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: Dimens.spacePadding),
              if(title != null)
                Text(
                  title!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ColorConstant.white
                  ),
                ),
              Text(description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
