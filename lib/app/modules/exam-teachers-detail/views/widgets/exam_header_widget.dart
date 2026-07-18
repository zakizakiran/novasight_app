import 'package:flutter/material.dart';

import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';

class ExamHeaderWidget extends StatelessWidget {
  final bool isReadOnly;
  final int numberOfQuestions;
  final String answerOptions;
  final String difficulty;
  final TextEditingController controller;

  final Widget? trailing;

  const ExamHeaderWidget({
    super.key,
    required this.controller,
    required this.numberOfQuestions,
    required this.answerOptions,
    required this.difficulty,
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
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Masukkan judul ujian",
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
              '$numberOfQuestions soal · Pilihan Ganda ($answerOptions) · $difficulty',
            ),
          ],
        ),
      ),
    );
  }
}