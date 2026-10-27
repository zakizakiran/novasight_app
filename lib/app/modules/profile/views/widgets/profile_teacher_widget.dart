import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/profile/views/widgets/setting_dialog_widget.dart';

import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../data/model/user_profile_model.dart';

class ProfileTeacherWidget extends StatelessWidget {
  const ProfileTeacherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      spacing: Dimens.spacePadding,
      children: [
        _buildField(
          context: context,
          icon: Icons.school,
          title: l10n.schoolOrigin,
          description: teacher.nameSchools,
        ),
        const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
        _buildField(
          context: context,
          icon: Icons.class_,
          title: "Ajar Tingkat Kelas : ",
          description: teacher.grades.map((g) => g.name).join(", "),
        ),
        const Divider(color: ColorConstant.darkGrey, thickness: 0.4),
        _buildField(
          context: context,
          icon: Icons.settings,
          title: l10n.settings,
          onPressed: () {
            SettingsDialogWidget.show(context);
          },
        ),
      ],
    );
  }

  Widget _buildField({
    required IconData icon,
    required String title,
    String? description,
    required BuildContext context,
    VoidCallback? onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: Dimens.spacePadding,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: Dimens.iconMidSize, color: ColorConstant.darkGrey),
          Expanded(
            child: Row(
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
                  Expanded(
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.informationColor,
                        fontWeight: FontWeight.w500,
                      ),
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
