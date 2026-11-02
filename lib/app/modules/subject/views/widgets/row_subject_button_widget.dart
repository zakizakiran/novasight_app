

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/core/dimens.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/modules/subject/views/widgets/show_modal_bottom_sheet_note.dart';

import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/utils/show_modal_bottom_sheet_helper.dart';
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
    final String prev = context.l10n.previous;
    const IconData prevIcon = Icons.arrow_back;
    const IconData nextIcon = Icons.arrow_forward;
    const double sizeIcon = Dimens.iconRegularSize;
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
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
                const SizedBox(width: Dimens.spaceMediumPadding),
                Expanded(child: Text(prev,style: style,)),
              ],
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacePadding),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Dimens.spacePadding),
            child: CommonButtonWidget(
              buttonName: next,
              onPressed: onNext,
              isValid: enableNext,
              buttonWidth: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(next,style: style,)),
                  const SizedBox(width: Dimens.spaceMediumPadding),
                  const Icon(nextIcon, color: ColorConstant.white,size: sizeIcon,),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimens.spacePadding),
        Semantics(
          label: context.l10n.openNoteChapter,
          button: true,
          child: GestureDetector(
            onTap: () {
              ShowModalBottomSheetHelper.showCustomBottomSheet(
                const ShowModalBottomSheetNote(),
                padding: 0,
              );
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: ColorConstant.card,
                borderRadius: BorderRadius.circular(Dimens.radius),
                border: Border.all(color: ColorConstant.primary),
              ),
              child: const Icon(
                Icons.edit_square,
                color: ColorConstant.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
