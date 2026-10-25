import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_filter_tab_widget.dart';
import 'package:novasight_app/app/modules/exam/views/widgets/exam_card_widget.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../controllers/exam_controller.dart';

class ExamView extends GetView<ExamController> {
  const ExamView({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(description: l10n.examQuestions, showBackButton: false),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.spacePadding,
                children: [
                  Obx(
                    () => _buildRowTab(
                      selectedStatus: controller.selectedStatus.value,
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final exams = controller.filteredExams;
                      if (exams.isEmpty) {
                        return Center(
                          child: Text(
                            l10n.noExamsInCategory,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorConstant.textGreyColor,
                                ),
                          ),
                        );
                      }

                      return ListView.separated(
                        itemCount: exams.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, i) {
                          return ExamCardWidget(
                            exam: exams[i],
                            onDetail: () async {
                              final examItem = exams[i];
                              if (examItem.status == PublicStatus.done) {
                                await Get.toNamed(
                                  Routes.EXAM_REVIEW,
                                  arguments: examItem.rawQuiz ?? int.tryParse(examItem.id) ?? examItem.id,
                                );
                              } else {
                                await Get.toNamed(
                                  Routes.EXAM_DETAIL,
                                  arguments: examItem.rawQuiz ?? examItem,
                                );
                              }
                              controller.onLoad();
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: Dimens.spacePadding);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowTab({required PublicStatus selectedStatus}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: Dimens.spaceMediumPadding,
        children: [
          ModuleFilterTabWidget(
            status: PublicStatus.all,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
          ModuleFilterTabWidget(
            status: PublicStatus.notDone,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
          ModuleFilterTabWidget(
            status: PublicStatus.done,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
        ],
      ),
    );
  }
}
