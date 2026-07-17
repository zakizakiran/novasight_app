import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/data/model/user_profile_model.dart';
import 'package:novasight_app/app/modules/profile/controllers/profile_controller.dart';

import '../../../../core/styles/svg/svg_constant.dart';
class ProfileAppBarWidget extends GetView<ProfileController> {
  const ProfileAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 50,
        bottom: Dimens.innerPadding
      ),
      decoration: const BoxDecoration(
        color: ColorConstant.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Dimens.radius),
          bottomRight: Radius.circular(Dimens.radius)
        )
      ),
      child: Column(
        spacing: Dimens.spaceSmallPadding,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: ColorConstant.white,
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white24,
                  width: 4
              ),
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                SvgConstant.iconProfileDefault,
                height: 100,
                width: 100,
                colorFilter: ColorFilter.mode(
                    ColorConstant.grey,
                    BlendMode.srcIn
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Obx(() {
            final data = controller.role.value == UserRoles.siswa ? student : teacher;
            return Column(
              spacing: Dimens.spaceSmallPadding,
              children: [
                Text(data.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: ColorConstant.white
                ),),
                Text(data.email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.white
                  ),),
              ],
            );
          })
        ],
      ),
    );
  }
}
