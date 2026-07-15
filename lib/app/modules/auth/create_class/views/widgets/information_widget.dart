import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';

import '../../../../../core/Dimens.dart';
class InformationWidget extends StatelessWidget {
  const InformationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      decoration: const BoxDecoration(
        color: ColorConstant.secondary,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius))
      ),
      child: Row(
        spacing: Dimens.spacePadding,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            SvgConstant.iconInformation,
            width: Dimens.iconRegularSize,
            height: Dimens.iconRegularSize,
          ),
          Expanded(
            child: Text(
                "Kode kelas akan dibuat otomatis setelah kelas dibuat. Bagikan kode ke siswa agar bisa bergabung.",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ColorConstant.primary
                ),
            ),
          )
        ],
      ),
    );
  }
}
