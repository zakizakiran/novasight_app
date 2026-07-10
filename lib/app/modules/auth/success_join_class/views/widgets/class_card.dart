import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  const ClassCard({super.key,required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Dimens.innerPadding),
      decoration: BoxDecoration(
        color: ColorConstant.background,
        border: BoxBorder.all(
          width: 1,
          color: ColorConstant.borderBlueGrey
        ),
        borderRadius: BorderRadius.circular(Dimens.radius)
      ),
      child: Row(
        spacing: Dimens.spacePadding,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            IconTxt.classIcon,
            style: TextStyle(
                fontSize: Dimens.iconMediumSize
            ),
          ),
          Column(
            spacing: Dimens.spaceSmallPadding,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                classModel.className,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                classModel.schoolName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.textGreyColor
                ),
              ),
              Text(
                classModel.teacherName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.textGreyColor
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
