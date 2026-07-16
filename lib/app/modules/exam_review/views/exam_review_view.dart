import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/styles/text_theme.dart';
import '../controllers/exam_review_controller.dart';
import 'package:novasight_app/app/data/models/exam_review_model.dart';

class ExamReviewView extends GetView<ExamReviewController> {
  const ExamReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: Obx(() {
          final question = controller.questions[controller.currentIndex.value];
          return Column(
            children: [
              const CommonAppBar(
                title: 'Review Hasil Ujian',
                description: 'UTS Kelas X',
              ),
              const SizedBox(height: Dimens.spaceBigPadding),
              _buildProgressIndicator(context),
              const SizedBox(height: Dimens.spaceBigPadding),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStatusBanner(question),
                      const SizedBox(height: 20),
                      _buildQuestionCard(question),
                      const SizedBox(height: 20),
                      _buildJustificationCard(question),
                    ],
                  ),
                ),
              ),
              _buildBottomNavigation(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
        itemCount: controller.questions.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: Dimens.spaceMediumPadding),
        itemBuilder: (context, index) {
          final isActive = index == controller.currentIndex.value;
          return Semantics(
            label:
                "Soal nomor ${index + 1} dari ${controller.questions.length}",
            button: true,
            child: GestureDetector(
              onTap: () {
                controller.currentIndex.value = index;
              },
              child: Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isActive
                      ? ColorConstant.primary.withOpacity(0.1)
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

  Widget _buildStatusBanner(ExamReviewQuestion question) {
    final bgColor = question.isCorrect
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final textColor = question.isCorrect
        ? const Color(0xFF4CAF50)
        : const Color(0xFFF44336);
    final icon = question.isCorrect ? Icons.check : Icons.close;
    final text = question.isCorrect
        ? 'Jawabanmu Benar!'
        : 'Jawabanmu Kurang Tepat';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withOpacity(0.5)),
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
            'Nilai: +${question.score}',
            style: const MainTextTheme().bodyLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ExamReviewQuestion question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Soal',
            style: const MainTextTheme().titleMedium?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(question.question, style: const MainTextTheme().bodyLarge),
          const SizedBox(height: 20),
          Text(
            'Jawaban',
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

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      question.options[index],
                      style: const MainTextTheme().bodyLarge?.copyWith(
                        color: textColor,
                        fontWeight: isUserAnswer || isCorrectAnswer
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (trailingIcon != null) trailingIcon,
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJustificationCard(ExamReviewQuestion question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Justifikasi & Pembahasan',
            style: const MainTextTheme().titleMedium?.copyWith(
              color: ColorConstant.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (question.userWorkingSteps != null &&
              question.userWorkingSteps!.isNotEmpty) ...[
            Text(
              'Langkah pengerjaan kamu:',
              style: const MainTextTheme().bodyLarge,
            ),
            const SizedBox(height: 12),
            ...List.generate(question.userWorkingSteps!.length, (index) {
              final isErrorStep = index == question.errorStepIndex;
              return Container(
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
                      child: Text(
                        question.userWorkingSteps![index],
                        style: const MainTextTheme().bodyLarge?.copyWith(
                          color: isErrorStep
                              ? const Color(0xFFF44336)
                              : Colors.black87,
                          fontWeight: isErrorStep
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isErrorStep)
                      const Icon(Icons.close, color: Color(0xFFF44336)),
                  ],
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
                    const Text(
                      'Letak kesalahan:',
                      style: TextStyle(
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
              return Padding(
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
              );
            }),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4CAF50)),
              ),
              child: Text(
                'Jawaban benar adalah ${String.fromCharCode(65 + question.correctAnswerIndex)} — ${question.options[question.correctAnswerIndex]}.',
                style: const MainTextTheme().bodyLarge?.copyWith(
                  color: const Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
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
            onPressed: controller.currentIndex.value > 0
                ? controller.previousQuestion
                : null,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Sebelumnya'),
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
              if (controller.currentIndex.value <
                  controller.questions.length - 1) {
                controller.nextQuestion();
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
                  controller.currentIndex.value <
                          controller.questions.length - 1
                      ? 'Selanjutnya'
                      : 'Selesai',
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
