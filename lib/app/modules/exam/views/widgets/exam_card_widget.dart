import 'package:flutter/material.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/modules/exam/controllers/exam_controller.dart';

class ExamCardWidget extends StatelessWidget {
  final ExamDummyModel exam;
  final VoidCallback onDetail;

  const ExamCardWidget({
    super.key,
    required this.exam,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDetail,
      child: CommonCardWidget(
        border: BorderStyleConstant.outlineBorderCard,
        boxShadow: [
          BoxShadowConstant.module,
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.spaceSmallPadding,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Soal Ujian',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorConstant.textPrimaryColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.lightGreen,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ColorConstant.green),
                  ),
                  child: Text(
                    'Nilai: ${exam.nilai}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.spaceSmallPadding),
            Text(
              exam.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: ColorConstant.textDarkGreyColor,
                  ),
            ),
            Text(
              exam.subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.textDarkGreyColor,
                  ),
            ),
            const SizedBox(height: Dimens.spaceMediumPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exam.statusText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Kerjakan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: ColorConstant.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      color: ColorConstant.primary,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
