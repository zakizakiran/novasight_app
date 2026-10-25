import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';

import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../../data/models/exam_review_question_model.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
  });

  final ExamReviewQuestion question;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            label: 'Soal: ${question.question}',
            excludeSemantics: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.question,
                  style: const MainTextTheme().titleMedium?.copyWith(
                    color: ColorConstant.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(question.question, style: const MainTextTheme().bodyLarge),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            context.l10n.answersLabel,
            style: const MainTextTheme().titleMedium?.copyWith(
              color: ColorConstant.textGreyColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(question.options.length, (index) {
            final isUserAnswer = index == question.userAnswerIndex;
            final isCorrectAnswer = index == question.correctAnswerIndex;

            Color bgColor = Colors.transparent;
            Color borderColor = Colors.grey.shade300;
            Color textColor = Colors.black87;
            Widget? trailingIcon;

            if (isCorrectAnswer) {
              bgColor = const Color(0xFFE8F5E9);
              borderColor = const Color(0xFF4CAF50);
              textColor = const Color(0xFF4CAF50);
              trailingIcon = const Icon(Icons.check, color: Color(0xFF4CAF50));
            } else if (isUserAnswer && !isCorrectAnswer) {
              bgColor = const Color(0xFFFFEBEE);
              borderColor = const Color(0xFFF44336);
              textColor = const Color(0xFFF44336);
              trailingIcon = const Icon(Icons.close, color: Color(0xFFF44336));
            }

            final letter = String.fromCharCode(65 + index); // A, B, C, D

            String semanticsStatus = '';
            if (isCorrectAnswer && isUserAnswer) {
              semanticsStatus = 'Jawaban Anda Benar';
            } else if (isCorrectAnswer) {
              semanticsStatus = 'Ini adalah jawaban yang benar';
            } else if (isUserAnswer) {
              semanticsStatus = 'Jawaban Anda Salah';
            }

            return Semantics(
              label:
                  'Pilihan $letter: ${question.options[index]}. $semanticsStatus',
              excludeSemantics: true,
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: borderColor,
                    width: isUserAnswer || isCorrectAnswer ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUserAnswer || isCorrectAnswer
                            ? textColor
                            : Colors.grey.shade200,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter,
                        style: TextStyle(
                          color: isUserAnswer || isCorrectAnswer
                              ? Colors.white
                              : Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        question.options[index].trim().toUpperCase() == letter
                            ? 'Pilihan $letter'
                            : question.options[index],
                        style: const MainTextTheme().bodyLarge?.copyWith(
                          color: textColor,
                          fontWeight: isUserAnswer || isCorrectAnswer
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    ?trailingIcon,
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}