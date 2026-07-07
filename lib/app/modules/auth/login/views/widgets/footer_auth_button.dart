import 'package:flutter/material.dart';

import '../../../../../core/styles/colors/color_constant.dart';

class FooterAuthButton extends StatelessWidget {
  final String title;
  final String description;
  final Function() onClick;
  const FooterAuthButton({super.key,required this.title,required this.description, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(description),
        GestureDetector(
          onTap: onClick,
          child: Text(title,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: ColorConstant.primary
          ),),
        )
      ],
    );
  }
}
