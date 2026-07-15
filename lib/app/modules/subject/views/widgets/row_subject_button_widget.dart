

import 'package:flutter/material.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class RowSubjectButtonWidget extends StatelessWidget {
  final Function() onNext;
  final bool enableNext;
  final String next;

  final Function() onPrevious;
  final bool enablePrevious;
  const RowSubjectButtonWidget({super.key,
    required this.onNext,
    required this.onPrevious,
    required this.enableNext,
    required this.enablePrevious,
    required this.next,
  });

  @override
  Widget build(BuildContext context) {
    const String prev = "Sebelumnya";
    const IconData prevIcon = Icons.arrow_back;
    const IconData nextIcon = Icons.arrow_forward;
    const double sizeIcon = Dimens.iconRegularSize;
    final style = Theme.of(context).textTheme.titleLarge?.copyWith(
      color: ColorConstant.white,
      fontWeight: FontWeight.bold
    );
    return Row(
      children: [
        Expanded(
          child: CommonButtonWidget(
            buttonName: prev,
            buttonWidth: double.infinity,
            onPressed: onPrevious,
            isValid: enablePrevious,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(prevIcon, color: ColorConstant.white,size: sizeIcon,),
                const SizedBox(width: Dimens.spacePadding),
                Expanded(child: Text(prev,style: style,)),
              ],
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacePadding),
        Expanded(
          child: CommonButtonWidget(
            buttonName: next,
            onPressed: onNext,
            isValid: enableNext,
            buttonWidth: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Text(next,style: style,)),
                const SizedBox(width: Dimens.spacePadding),
                const Icon(nextIcon, color: ColorConstant.white,size: sizeIcon,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
