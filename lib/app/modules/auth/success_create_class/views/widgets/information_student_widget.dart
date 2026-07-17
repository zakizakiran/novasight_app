import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class InformationStudentWidget extends StatelessWidget {
  final String code;
  const InformationStudentWidget({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dimens.innerPadding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
        color: ColorConstant.white,
        border: BoxBorder.all(
          color: ColorConstant.grey
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacePadding,
        children: [
          Text(
              "Cara siswa bergabung:",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorConstant.textDarkGreyColor
            ),
          ),
          Text(
            '1. Buka aplikasi Lydera\n2. Pilih "Masuk ke Kelas"\n3. Masukkan kode $code',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstant.textGreyColor
            ),
          )
        ],
      ),
    );
  }
}
