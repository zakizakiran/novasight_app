import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/profile_student_widget.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/profile_teacher_widget.dart';

import '../../../common/common_app_bar.dart';
import '../../../core/Dimens.dart';
import '../../../core/styles/box_shadow_style.dart';
import '../../../data/model/user_profile_model.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          spacing: Dimens.spacePadding,
          children: [
            const CommonAppBar(description: "Profile", showBackButton: false),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 4),
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  SvgConstant.iconProfileDefault,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
                switch (controller.role.value) {
                  UserRoles.guru => teacher.name,
                  UserRoles.siswa => student.name,
                  null => "Kosong",
                },
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorConstant.white,
                  borderRadius: BorderRadius.all(Radius.circular(Dimens.radius)),
                  boxShadow: [
                    BoxShadowConstant.module
                  ]
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Obx(() => switch (controller.role.value) {
                UserRoles.guru => const ProfileTeacherWidget(),
                UserRoles.siswa => const ProfileStudentWidget(),

                null => const SizedBox.shrink(),
              },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceBigPadding),
              child: CommonButtonWidget(
                  buttonName: "Logout",
                  onPressed: controller.onLogout
              ),
            )
          ],
        ),
      ),
    );
  }
}


