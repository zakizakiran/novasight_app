import 'package:flutter/material.dart';

import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../data/models/exam_review_question_model.dart';

class ProgressIndicatorExamReview extends StatelessWidget {
  const ProgressIndicatorExamReview({
    super.key, required this.currentIndex, required this.questions, required this.goToQuestion,
  });

  final int currentIndex;
  final void Function(int) goToQuestion;
  final List<ExamReviewQuestion> questions;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
        itemCount: questions.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: Dimens.spaceMediumPadding),
        itemBuilder: (context, index) {
          final isActive = index == currentIndex;
          return Semantics(
            label:
                "Soal nomor ${index + 1} dari ${questions.length}",
            button: true,
            child: GestureDetector(
              onTap: () => goToQuestion(index),
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive
                      ? ColorConstant.primary.withValues(alpha: 0.1)
                      : ColorConstant.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? ColorConstant.primary
                        : ColorConstant.borderNormalGrey,
                  ),
                ),
                child: Text(
                  "${index + 1}",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isActive
                        ? ColorConstant.primary
                        : ColorConstant.textDarkGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}