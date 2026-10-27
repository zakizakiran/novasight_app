import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: ColorConstant.borderBlueGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: currentIndex > 0
                ? previousQuestion
                : null,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: Text(context.l10n.previous),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.background,
              foregroundColor: Colors.grey.shade600,
              textStyle: const MainTextTheme().bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentIndex <
                  questions.length - 1) {
                nextQuestion();
              } else {
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorConstant.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Text(
                  currentIndex < questions.length - 1
                      ? context.l10n.next
                      : context.l10n.finish,
                  style: const MainTextTheme().bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}