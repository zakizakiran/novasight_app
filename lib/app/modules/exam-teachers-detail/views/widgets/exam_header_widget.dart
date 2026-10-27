import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';

import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';

class ExamHeaderWidget extends StatelessWidget {
  final bool isReadOnly;
  final int numberOfQuestions;
  final String answerOptions;
  final String difficulty;
  final int? durationMinutes;
  final String? subtitle;
  final TextEditingController controller;

  final Widget? trailing;

  const ExamHeaderWidget({
    super.key,
    required this.controller,
    required this.numberOfQuestions,
    this.answerOptions = 'A-E',
    this.difficulty = 'Campuran',
    this.durationMinutes,
    this.subtitle,
    required this.isReadOnly,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: Border.all(
            color: ColorConstant.grey.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorConstant.shadowColor.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    readOnly: isReadOnly,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.textDarkGreyColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: context.l10n.enterExamTitle,
                    ),
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle ??
                  (durationMinutes != null
                      ? context.l10n.examSubtitleFormat(numberOfQuestions, durationMinutes!)
                      : '$numberOfQuestions soal · Pilihan Ganda ($answerOptions) · $difficulty'),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}