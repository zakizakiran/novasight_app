import 'package:flutter/material.dart';

import '../../../../../core/styles/colors/color_constant.dart';

class FooterAuthButton extends StatelessWidget {
  const FooterAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Sudah punya akun? "),
        Text("Masuk",style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: ColorConstant.primary
        ),)
      ],
    );
  }
}
