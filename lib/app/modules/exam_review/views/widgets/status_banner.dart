import 'package:flutter/material.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';

import '../../../../core/styles/text_theme.dart';
import '../../../../data/models/exam_review_question_model.dart';

class StatusBanner extends StatelessWidget {
  const StatusBanner({
    super.key,
    required this.question,
  });

  final ExamReviewQuestion question;

  @override
  Widget build(BuildContext context) {
    final bgColor = question.isCorrect
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final textColor = question.isCorrect
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF44336);
    final icon = question.isCorrect ? Icons.check : Icons.close;
    final userNotAnswered = question.userAnswerIndex == -1;
    final text = question.isCorrect
        ? context.l10n.correctAnswerBanner
        : userNotAnswered ? context.l10n.unansweredBanner : context.l10n.wrongAnswerBanner;

    return Semantics(
      container: true,
      label: 'Status: $text, Nilai ditambah ${question.score}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: textColor.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      text,
                      style: const MainTextTheme().bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${context.l10n.score}: +${question.score.toStringAsFixed(1)}',
              style: const MainTextTheme().bodyLarge?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}