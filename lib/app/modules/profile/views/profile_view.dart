import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/user_roles.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/profile_app_bar_widget.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/profile_student_widget.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/profile_teacher_widget.dart';
import '../../../core/Dimens.dart';
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
            const ProfileAppBarWidget(),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                spacing: Dimens.spacePadding,
                children: [
                  _buildCard(child: Text("Isi",style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: ColorConstant.textDarkGreyColor
                  ),)),
                  _buildCard(
                      child: Obx(() {
                        final role = controller.role.value;
                        return role == UserRoles.siswa ? const ProfileStudentWidget() : const ProfileTeacherWidget();
                      })
                  )
                ],
              ),
            ),
            Obx(() {
              final isStudent = controller.role.value == UserRoles.siswa;
              return Visibility(
                visible: isStudent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceBigPadding),
                  child: CommonButtonWidget(
                      buttonName: "Keluar Kelas",
                      boxShadows: const [
                        BoxShadowConstant.redShadowColor
                      ],
                      buttonColor: ColorConstant.redColor,
                      onPressed: controller.onLogout
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimens.spaceBigPadding),
              child: CommonButtonWidget(
                  buttonName: "Logout",
                  onPressed: controller.onLogout
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCard({
    required Widget child
}){
    return Container(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ColorConstant.grey,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius))
      ),
      child: child,
    );
  }
}


