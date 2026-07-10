import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import '../../../../core/styles/colors/color_constant.dart';

class ModuleFilterTabWidget extends StatelessWidget {
  final ModuleStatus status;
  final ModuleStatus selectedStatus;
  final ValueChanged<ModuleStatus> onChanged;
  const ModuleFilterTabWidget({super.key, required this.status, required this.selectedStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool condition = selectedStatus == status;
    return InkWell(
      onTap: (){
        onChanged(status);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: condition ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorConstant.linearSecondary,
                ColorConstant.linearPrimary,
              ],
              stops:[
                0.2,
                1.0
              ]
          ) : null,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: BoxBorder.all(
            color: condition ? ColorConstant.linearBorder : ColorConstant.grey,
            width: 2
          )
        ),
        padding: EdgeInsets.all(Dimens.innerMediumPadding),
        child: Row(
          spacing: Dimens.spaceMediumPadding,
          children: [
            if(condition)
              SvgPicture.asset(
                SvgConstant.iconCheck,
                colorFilter: ColorFilter.mode(
                    ColorConstant.white,
                    BlendMode.srcIn
                ),
                height: Dimens.iconRegularSize,
                width: Dimens.iconRegularSize,
              ),
            Text(
              status.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: condition ? ColorConstant.white : ColorConstant.textDarkGreyColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
