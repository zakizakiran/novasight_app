import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import '../../../core/utils/date_helper.dart';
import '../controllers/exam_detail_controller.dart';

class ExamDetailView extends GetView<ExamDetailController> {
  const ExamDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: Obx(
        () => Column(
          children: [
            CommonAppBar(
              title: controller.title.value,
              description: controller.moduleTitle.value,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                child: Semantics(
                  label:
                      "Informasi sebelum memulai ujian. Ujian ini terdiri dari ${controller.questionCount.value} soal yang mencakup pilihan ganda dan isian singkat, dan kamu memiliki waktu ${controller.durationMinutes.value} menit untuk menyelesaikannya. Bacalah setiap soal dengan cermat, kerjakan dengan tenang, dan pastikan semua jawaban dikirim sebelum waktu habis. Selamat mengerjakan dan semoga sukses!",
                  child: CommonCardWidget(
                    boxShadow: const [BoxShadowConstant.module],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sebelum Memulai Ujian",
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: ColorConstant.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: Dimens.spacePadding),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: ColorConstant.textDarkGreyColor,
                                  height: 1.5,
                                ),
                            children: [
                              const TextSpan(text: "Ujian ini terdiri dari "),
                              TextSpan(
                                text: "${controller.questionCount.value} soal ",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(
                                text:
                                    "yang mencakup pilihan ganda dan isian singkat, dan kamu memiliki waktu ",
                              ),
                              TextSpan(
                                text: "${controller.durationMinutes.value} menit ",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: "untuk menyelesaikannya."),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimens.spaceMediumPadding),
                        Text(
                          "Bacalah setiap soal dengan cermat, kerjakan dengan tenang, dan pastikan semua jawaban dikirim sebelum waktu habis.",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: ColorConstant.textDarkGreyColor,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: Dimens.spaceMediumPadding),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                              color: ColorConstant.textDarkGreyColor,
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(text: "Ujian dimulai pada : "),
                              TextSpan(
                                text: "${DateHelper.dateTimeFormat(controller.quiz.value!.startTime)} ",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: "\nUjian selesai pada : "),
                              TextSpan(
                                text: "${DateHelper.dateTimeFormat(controller.quiz.value!.endTime)} ",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Dimens.spaceMediumPadding),
                        Text(
                          "Selamat mengerjakan dan semoga sukses!",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: ColorConstant.textDarkGreyColor,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: CommonButtonWidget(
                buttonName: "Mulai Ujian",
                onPressed: controller.onStartExam,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
