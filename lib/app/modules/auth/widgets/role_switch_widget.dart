import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';

import '../../../common/common_switch_widget.dart';
import '../../../core/utils/user_roles.dart';


import 'package:flutter/material.dart';

class RoleSwitchWidget extends StatelessWidget {
  final UserRoles selectedRole;
  final ValueChanged<UserRoles> onChanged;

  const RoleSwitchWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CommonSwitchWidget<UserRoles>(
      selectedValue: selectedRole,
      values: const [
        UserRoles.guru,
        UserRoles.siswa,
      ],
      onChanged: onChanged,
      labelBuilder: (role) {
        switch (role) {
          case UserRoles.guru:
            return context.l10n.teacher;
          case UserRoles.siswa:
            return context.l10n.student;
        }
      },
      height: 50,
      animationDuration: const Duration(milliseconds: 250),
      backgroundColor: ColorConstant.secondary,
      selectedColor: ColorConstant.primary,
      selectedTextColor: ColorConstant.white,
      unselectedTextColor: ColorConstant.textGreyColor,
      borderRadius: const BorderRadius.all(
        Radius.circular(Dimens.radius),
      ),
    );
  }
}



