import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../../../../../core/utils/user_roles.dart';

class RoleSwitchWidget extends StatelessWidget {
  final UserRoles selectedRole;
  final ValueChanged<UserRoles> onChanged;

  const RoleSwitchWidget({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });
  static const _animationDuration = Duration(milliseconds: 250);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 60,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ColorConstant.secondary,
        borderRadius: BorderRadius.circular(Dimens.radius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: selectedRole == UserRoles.guru
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: constraints.maxWidth / 2,
                  decoration: BoxDecoration(
                    color: ColorConstant.primary,
                    borderRadius: BorderRadius.circular(Dimens.radius),
                  ),
                ),
              ),

              Row(
                children: [
                  _buildRoleButton(context: context, textTheme: textTheme, role: UserRoles.guru),
                  _buildRoleButton(context: context, textTheme: textTheme, role: UserRoles.siswa)
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required TextTheme textTheme,
    required UserRoles role,
  }) {
    final isSelected = role == selectedRole;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.radius),
        onTap: () => onChanged(role),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: _animationDuration,
            curve: Curves.easeInOut,
            style: textTheme.titleMedium!.copyWith(
              fontWeight:
              isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? ColorConstant.white
                  : ColorConstant.textGreyColor,
            ),
            child: Text(role.roleName),
          ),
        ),
      ),
    );
  }
}


