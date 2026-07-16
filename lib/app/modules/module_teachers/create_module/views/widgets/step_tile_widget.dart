import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../../controllers/create_module_controller.dart';

class StepTileWidget extends StatelessWidget {
  final LoadingStep step;
  const StepTileWidget({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = step.status.value;
      IconData icon = Icons.radio_button_off;
      Color iconColor = Colors.grey;
      String statusText = "Tunggu...";
      Color statusBgColor = Colors.grey.shade100;
      Color statusTextColor = ColorConstant.darkGrey;

      if (status == LoadingStepStatus.processing) {
        icon = Icons.radio_button_checked;
        iconColor = ColorConstant.primary;
        statusText = "Proses...";
        statusBgColor = ColorConstant.secondary;
        statusTextColor = ColorConstant.primary;
      } else if (status == LoadingStepStatus.completed) {
        icon = Icons.check_circle;
        iconColor = ColorConstant.green;
        statusText = "Selesai";
        statusBgColor = ColorConstant.lightGreen;
        statusTextColor = ColorConstant.green;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                step.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: status == LoadingStepStatus.processing ? FontWeight.bold : FontWeight.normal,
                    color: status == LoadingStepStatus.pending ? ColorConstant.grey : ColorConstant.informationColor,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusText,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusTextColor
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}