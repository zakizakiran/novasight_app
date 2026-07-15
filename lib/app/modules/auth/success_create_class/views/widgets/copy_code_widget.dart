import 'package:flutter/material.dart';

import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';
class CopyCodeWidget extends StatelessWidget {
  final Function() copyCode;
  const CopyCodeWidget({super.key, required this.copyCode});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CommonButtonWidget(
              buttonName: "Bagikan Kode",
              onPressed: copyCode
          ),
        ),
        const SizedBox(width: Dimens.spacePadding,),
        GestureDetector(
          onTap: copyCode,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.innerPadding
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(Dimens.radius)),
              color: ColorConstant.secondary
            ),
            child: const Text(
                IconTxt.copyIcon,
              style: TextStyle(
                fontSize: Dimens.iconMediumSize,
                color: ColorConstant.primary
              ),
            ),
          ),
        )
      ],
    );
  }
}
