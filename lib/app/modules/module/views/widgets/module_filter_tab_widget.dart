import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/svg/svg_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/core/utils/module_status.dart';
import '../../../../core/styles/colors/color_constant.dart';

class ModuleFilterTabWidget extends StatelessWidget {
  final PublicStatus status;
  final PublicStatus selectedStatus;
  final ValueChanged<PublicStatus> onChanged;
  const ModuleFilterTabWidget({super.key, required this.status, required this.selectedStatus, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final bool condition = selectedStatus == status;
    final title = status.localizedName(context);
    return Semantics(
      button: true,
      label: context.l10n.filterLabel(title),
      child: InkWell(
        onTap: (){
          onChanged(status);
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: condition ? const LinearGradient(
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
          padding: const EdgeInsets.all(Dimens.innerMediumPadding),
          child: Row(
            spacing: Dimens.spaceMediumPadding,
            children: [
              if(condition)
                SvgPicture.asset(
                  SvgConstant.iconCheck,
                  colorFilter: const ColorFilter.mode(
                      ColorConstant.white,
                      BlendMode.srcIn
                  ),
                  height: Dimens.iconRegularSize,
                  width: Dimens.iconRegularSize,
                ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: condition ? ColorConstant.white : ColorConstant.textDarkGreyColor
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
