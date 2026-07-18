import 'package:flutter/material.dart';

import '../../../../core/dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../controllers/generate_exam_controller.dart';

Widget buildReviewBottomBar(
  BuildContext context,
  GenerateExamController controller,
) {
  return Container(
    padding: const EdgeInsets.all(Dimens.innerPadding),
    decoration: BoxDecoration(
      color: ColorConstant.white,
      boxShadow: [
        BoxShadow(
          color: ColorConstant.shadowColor.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: SafeArea(
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Simpan Draft
                controller.finish(FinishType.draft);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: ColorConstant.primary,
                side: const BorderSide(color: ColorConstant.primary),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radius),
                ),
              ),
              child: const Text(
                'Simpan Draft',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Simpan & Publish
                controller.finish(FinishType.publish);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                foregroundColor: ColorConstant.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.radius),
                ),
              ),
              child: const Text(
                'Simpan & Publish',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildBottomButton(
  BuildContext context,
  String text,
  VoidCallback onPressed,
) {
  return Container(
    padding: const EdgeInsets.all(Dimens.innerPadding),
    decoration: BoxDecoration(
      color: ColorConstant.white,
      boxShadow: [
        BoxShadow(
          color: ColorConstant.shadowColor.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, -5),
        ),
      ],
    ),
    child: SafeArea(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorConstant.primary,
          foregroundColor: ColorConstant.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radius),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
  );
}
