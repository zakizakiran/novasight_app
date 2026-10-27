import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';

import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/text_theme.dart';
import '../../../../core/utils/math_latex_parser.dart';
import '../../../../core/utils/math_semantic_serializer.dart';
import '../../../../data/models/exam_review_question_model.dart';

class JustificationCard extends StatelessWidget {
  const JustificationCard({
    super.key,
    required this.question,
    required this.parser,
    required this.serializer,
  });

  final ExamReviewQuestion question;
  final MathLatexParser parser;
  final MathSemanticSerializer serializer;

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
          Text(
            context.l10n.justificationDiscussion,
            style: const MainTextTheme().titleMedium?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (question.userStep.isNotEmpty) ...[
            Text(
              context.l10n.yourSolutionSteps,
              style: const MainTextTheme().bodyLarge,
            ),
            const SizedBox(height: 12),
            ...List.generate(question.userStep.length, (index) {
              final step = question.userStep[index];
              final isErrorStep = step.steps == question.errorStepIndex;
              final nodes = parser.parse(step.text);
              final semantic = serializer.serializeNodes(nodes);
              return Semantics(
                label:
                    'Langkah ${index + 1}: $semantic ${isErrorStep ? '.Terdapat kesalahan pada langkah ini.' : ''}',
                excludeSemantics: true,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isErrorStep ? const Color(0xFFFFEBEE) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isErrorStep
                          ? const Color(0xFFF44336)
                          : ColorConstant.primary,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isErrorStep
                              ? const Color(0xFFF44336)
                              : ColorConstant.primary,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Math.tex(
                          step.text,
                          mathStyle: MathStyle.text,
                          textStyle: const MainTextTheme().bodyLarge?.copyWith(
                              color: isErrorStep
                                  ? const Color(0xFFF44336)
                                  : Colors.black87,
                              fontWeight: isErrorStep
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                        ),
                        // child: Text(
                        //   step.text,

                        // ),
                      ),
                      if (isErrorStep)
                        const Icon(Icons.close, color: Color(0xFFF44336)),
                    ],
                  ),
                ),
              );
            }),
            if (question.errorExplanation != null)
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0), // Light orange
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFF9800)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.improvementNotes,
                      style: const TextStyle(
                        color: Color(0xFFE65100),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question.errorExplanation!,
                      style: const MainTextTheme().bodyMedium,
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2196F3)),
              ),
              child: Text(
                'Jawaban yang benar adalah ${String.fromCharCode(65 + question.correctAnswerIndex)} — ${question.options[question.correctAnswerIndex]}.',
                style: const MainTextTheme().bodyLarge?.copyWith(
                  color: const Color(0xFF1565C0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ] else ...[
            ...List.generate(question.explanationSteps.length, (index) {
              return Semantics(
                label:
                    'Langkah ${index + 1}: ${question.explanationSteps[index]}',
                excludeSemantics: true,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstant.primary,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          question.explanationSteps[index],
                          style: const MainTextTheme().bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            if (question.correction != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF4CAF50)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seharusnya:',
                      style: TextStyle(
                        color: Color(0xFF2E7D32),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question.correction!,
                      style: const MainTextTheme().bodyMedium,
                    ),
                  ],
                ),
              ),
            Builder(
              builder: (context) {
                final correctIdx = question.correctAnswerIndex.clamp(
                  0,
                  question.options.isEmpty ? 0 : question.options.length - 1,
                );
                final correctOptionText = question.options.isNotEmpty
                    ? question.options[correctIdx]
                    : '-';
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: Text(
                    'Jawaban benar adalah ${String.fromCharCode(65 + correctIdx)} — $correctOptionText.',
                    style: const MainTextTheme().bodyLarge?.copyWith(
                      color: const Color(0xFF2E7D32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}