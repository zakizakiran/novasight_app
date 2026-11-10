import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/models/exam_review_question_model.dart';

import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/text_theme.dart';

class ReviewBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final VoidCallback previousQuestion;
  final VoidCallback nextQuestion;
  final List<ExamReviewQuestion> questions;

  const ReviewBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.previousQuestion,
    required this.nextQuestion,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex >= questions.length - 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ColorConstant.borderBlueGrey)),
      ),
      child: Row(
        children: [
          Expanded(
            child: CommonButtonWidget(
              buttonName: context.l10n.previous,
              size: ButtonSize.medium,
              buttonColor: ColorConstant.background,
              textColor: Colors.grey.shade700,
              boxShadows: const [],
              border: const BorderSide(color: ColorConstant.borderNormalGrey),
              isValid: currentIndex > 0,
              onPressed: previousQuestion,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.arrow_back, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      context.l10n.previous,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const MainTextTheme().bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: CommonButtonWidget(
              buttonName: isLast ? context.l10n.finish : context.l10n.next,
              size: ButtonSize.medium,
              onPressed: () {
                if (!isLast) {
                  nextQuestion();
                } else {
                  Get.back();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      isLast ? context.l10n.finish : context.l10n.next,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const MainTextTheme().bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
