import 'package:flutter/material.dart';
import 'package:lydera_app/app/common/common_card_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/border_style.dart';
import 'package:lydera_app/app/core/styles/box_shadow_style.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/core/utils/module_status.dart';

import '../../../../data/models/exam_model.dart';

class ExamCardWidget extends StatelessWidget {
  final ExamModel exam;
  final VoidCallback onDetail;

  const ExamCardWidget({super.key, required this.exam, required this.onDetail});

  @override
  Widget build(BuildContext context) {
    final isDone = exam.status == PublicStatus.done;

    return Semantics(
      button: true,
      label:
          'Kartu Soal Ujian: ${exam.title}, ${exam.subtitle}, Status: ${isDone ? "${context.l10n.completedStatus}, ${context.l10n.score}: ${exam.score}" : context.l10n.notAttemptedStatus}',
      child: GestureDetector(
        onTap: onDetail,
        child: CommonCardWidget(
          border: BorderStyleConstant.outlineBorderCard,
          boxShadow: const [BoxShadowConstant.module],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.spaceSmallPadding,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.examQuestions,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorConstant.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isDone)
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
                        '${context.l10n.score}: ${exam.score}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.greenText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.linearSecondary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          context.l10n.filterNotAttempted,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConstant.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Dimens.spaceSmallPadding),
              Text(
                exam.title,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorConstant.textDarkGreyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                exam.subtitle,
                softWrap: true,
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
                      isDone
                          ? context.l10n.completedStatus
                          : context.l10n.notAttemptedStatus,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            isDone
                                ? context.l10n.examResultAssessify
                                : context.l10n.startTask,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: ColorConstant.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                            softWrap: true,
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
