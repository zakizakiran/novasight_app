import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class CodeClassWidget extends StatelessWidget {
  final String code;
  const CodeClassWidget({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spaceBigPadding,
      children: [
        Text(
          "Kode Kelasmu",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ColorConstant.textGreyColor
          ),
        ),
        Text(
          code,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.w900
          ),
        ),
        const Divider(
          color: ColorConstant.borderBlueGrey,
          thickness: 2,
        ),
        Text(
          "Berlaku selama kelas aktif",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: ColorConstant.textGreyColor
          ),
        )
      ],
    );
  }
}
