import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/text_helper.dart';
import 'package:novasight_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/setting_dialog_widget.dart';

import '../../../../core/Dimens.dart';
import '../../../../data/model/user_profile_model.dart';

class ProfileStudentWidget extends StatelessWidget {
  const ProfileStudentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : null;

    if (controller == null) {
      return _buildStaticContent(context);
    }

    return Obx(() {
      final studentProfile = controller.profile.value?.student;
      final cachedClass = controller.className.value;

      final nisText =
          (studentProfile?.nisn != null && studentProfile!.nisn!.isNotEmpty)
          ? studentProfile.nisn!
          : ((studentProfile?.nis != null && studentProfile!.nis!.isNotEmpty)
                ? studentProfile.nis!
                : student.studentId);

      final schoolOrClass = (cachedClass.isNotEmpty)
          ? cachedClass
          : student.nameSchools;

      final gradeText = studentProfile?.grade != null
          ? 'Kelas ${studentProfile!.grade}'
          : student.grade.name;

      return Column(
        spacing: Dimens.spacePadding,
        children: [
          _buildField(
            context: context,
            icon: Icons.person,
            title: "NIS/NISN : ",
            description: nisText,
            spellDigits: true,
          ),
          const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
          _buildField(
            context: context,
            icon: Icons.school,
            title: "Asal Sekolah / Kelas : ",
            description: schoolOrClass,
          ),
          const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
          _buildField(
            context: context,
            icon: Icons.class_,
            title: "Tingkat Kelas : ",
            description: gradeText,
          ),
          const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
          _buildField(
            context: context,
            icon: Icons.settings,
            title: "Pengaturan",
            onPressed: () {
              SettingsDialogWidget.show(context);
            }
          ),
        ],
      );
    });
  }

  Widget _buildStaticContent(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        _buildField(
          context: context,
          icon: Icons.person,
          title: "NIS/NISN : ",
          description: student.studentId,
          spellDigits: true,
        ),
        const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
        _buildField(
          context: context,
          icon: Icons.school,
          title: "Asal Sekolah : ",
          description: student.nameSchools,
        ),
        const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
        _buildField(
          context: context,
          icon: Icons.class_,
          title: "Tingkat Kelas : ",
        ),
      ],
    );
  }

  Widget _buildField({
    required IconData icon,
    required String title,
    String? description,
    required BuildContext context,
    bool spellDigits = false,
    VoidCallback? onPressed
  }) {
    final semanticDescription = spellDigits
        ? TextHelper.spellDigitsId(description ?? '')
        : description ?? '';
    return Semantics(
      container: true,
      label: [
        title,
        if (semanticDescription.isNotEmpty) semanticDescription,
      ].join('. '),
      button: onPressed != null,
      child: GestureDetector(
        onTap: onPressed,
        child: ExcludeSemantics(
          child: Row(
            spacing: Dimens.spacePadding,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: Dimens.iconMidSize, color: ColorConstant.darkGrey),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.informationColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description != null)
                      Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.informationColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
