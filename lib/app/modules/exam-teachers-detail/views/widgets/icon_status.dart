import 'package:flutter/material.dart';

import '../../../../core/styles/colors/color_constant.dart';
class IconStatus extends StatelessWidget {
  final IconStatusType type;
  final Function() toggle;
  const IconStatus({super.key, required this.toggle, required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => toggle(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: type.color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: type.borderColor),
        ),
        child: Row(
          children: [
            Icon(
              type.iconData,
              size: 14,
              color: type.color,
            ),
            const SizedBox(width: 4),
            Text(
              type.title,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(
                color: type.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum IconStatusType{
  edit(
      ColorConstant.yellowColor,
      title: "Edit",
      iconData: Icons.edit,
      color: ColorConstant.yellowColor,
  ),
  submit(
    ColorConstant.primary,
    title: "Submit",
    iconData: Icons.add,
    color: ColorConstant.primary,
  );

  final IconData iconData;
  final String title;
  final Color color;
  final Color borderColor;
  const IconStatusType(this.borderColor, {required this.iconData, required this.title, required this.color});
}