import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import '../../../../core/styles/svg/svg_constant.dart';
import '../../../../data/model/subject_model.dart';
class SubjectCardWidget extends StatelessWidget {
  final SubjectModel subjectModel;
  final int number;
  final void Function() onDetail;
  const SubjectCardWidget({super.key,required this.number, required this.subjectModel, required this.onDetail});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
        onPressed: onDetail,
        border: BorderStyleConstant.outlineBorderCard,
        boxShadow: [
          BoxShadowConstant.module
        ],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Dimens.spacePadding,
          children: [
            _numberWidget(number: number, context: context),
            Expanded(
              child: Text(
                subjectModel.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.textDarkGreyColor
                ),
              ),
            ),
            _checkWidget(isDone: subjectModel.isDone, context: context)
          ],
        ),
      );
    }

  Widget _numberWidget({
    required int number,
    required BuildContext context
}){
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ColorConstant.linearSecondary,
                ColorConstant.linearPrimary,
              ],
              stops: const [
                0.1,
                1.0
              ]
          ),
        shape: BoxShape.circle
      ),
      child: Text(
          number.toString(),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: ColorConstant.white
        ),
      ),
    );
  }

  Widget _checkWidget({
    required bool isDone,
    required BuildContext context,
  }) {
    final backgroundColor = isDone ? ColorConstant.green : ColorConstant.white;
    final shadowColor = isDone ? ColorConstant.greenShadow : ColorConstant.shadowColor;
    final borderColor = isDone ? ColorConstant.green : ColorConstant.borderNormalGrey;
    final double borderWidth = isDone ? 0 : Dimens.border;
    final double blur = isDone ? 8 : 10;
    return Semantics(
      label: isDone ? "Selesai" : 'Belum Selesai',
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
              color: borderColor,
              width: borderWidth
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: blur,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Visibility(
          visible: isDone,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: SvgPicture.asset(
            SvgConstant.iconCheck,
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              ColorConstant.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

