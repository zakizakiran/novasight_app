import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/modules/module/views/widgets/gradient_progress_bar_widget.dart';
class ModuleCardWidget extends StatelessWidget {
  final ModuleModel module;
  final void Function(ModuleModel) onDetail;
  const ModuleCardWidget({super.key, required this.module, required this.onDetail});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        onDetail(module);
      },
      child: Container(
        padding: EdgeInsets.all(Dimens.innerPadding),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          border: BoxBorder.all(
            color:ColorConstant.borderNormalGrey,
            width: Dimens.border
          ),
          boxShadow: [
            BoxShadow(
                color: ColorConstant.shadowColor,
                blurRadius: 4,
                spreadRadius: 0,
                offset: Offset(0, 4)
            )
          ],
          borderRadius: BorderRadius.circular(Dimens.radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.spaceSmallPadding,
          children: [
            Text(
              'Materi',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: ColorConstant.textPrimaryColor
              ),),
            Text(
              module.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: ColorConstant.textDarkGreyColor
              ),
            ),
            Text(
              module.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.textDarkGreyColor
              ),
            ),
            GradientProgressBarWidget(
              percantage: module.toPercentageDone() / 100,
            ),
            Text(
              "${module.toPercentageDone()}% Selesai",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstant.textGreyColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}
