import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_filter_tab_widget.dart';
import 'package:novasight_app/app/modules/exam/views/widgets/exam_card_widget.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../controllers/exam_controller.dart';

class ExamView extends GetView<ExamController> {
  const ExamView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CommonAppBar(description: "Soal Ujian", showBackButton: false),
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
                      final exams = controller.filteredExams;
                      return ListView.separated(
                        itemCount: exams.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, i) {
                          return ExamCardWidget(
                            exam: exams[i],
                            onDetail: () {
                              Get.toNamed(Routes.EXAM_DETAIL, arguments: exams[i].id);
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

  Widget _buildRowTab({required ModuleStatus selectedStatus}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: Dimens.spaceMediumPadding,
        children: [
          ModuleFilterTabWidget(
            status: ModuleStatus.all,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
          ModuleFilterTabWidget(
            status: ModuleStatus.notDone,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
          ModuleFilterTabWidget(
            status: ModuleStatus.done,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
        ],
      ),
    );
  }
}
