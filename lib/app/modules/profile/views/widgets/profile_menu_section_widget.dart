import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../../../../core/Dimens.dart';
class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({
    super.key,
    required this.items,
  });

  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.white,
        borderRadius: BorderRadius.circular(Dimens.radius),
        boxShadow: [
          BoxShadowConstant.module
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(
          color: ColorConstant.grey,
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) => items[index],
      ),
    );
  }
}


