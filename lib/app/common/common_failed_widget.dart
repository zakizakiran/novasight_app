import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class CommonFailedWidget extends StatelessWidget {
  final String message;
  const CommonFailedWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: ColorConstant.redColor
        ),
      ),
    );
  }
}
