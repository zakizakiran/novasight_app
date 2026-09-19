import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/data/models/teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_card_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_filter_status_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_search_bar_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_teacher_appbar.dart';
import '../controllers/module_teacher_controller.dart';

class ModuleTeacherView extends GetView<ModuleTeacherController> {
  const ModuleTeacherView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ModuleTeacherAppbar(),
              const SizedBox(height: Dimens.spacePadding),
              ModuleSearchBarWidget(
                onChange: controller.onChange,
                controller: controller.searchController,
              ),
              const SizedBox(height: Dimens.spacePadding),
              _buildRowStatus(),
              const SizedBox(height: Dimens.spacePadding),
              Expanded(
                child: Obx(() {
                  // State 1: Initial Loading
                  if (controller.isLoading.value &&
                      controller.teacherModules.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  // State 2: Error with Retry
                  if (controller.errorMessage.value.isNotEmpty &&
                      controller.teacherModules.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(Dimens.spacePadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: ColorConstant.redColor,
                            ),
                            const SizedBox(height: Dimens.spaceSmallPadding),
                            Text(
                              controller.errorMessage.value,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ColorConstant.redColor,
                                  ),
                            ),
                            const SizedBox(height: Dimens.spacePadding),
                            CommonButtonWidget(
                              buttonName: "Coba Lagi",
                              onPressed: () => controller.onLoad(),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final modules = controller.teacherModules;

                  // State 3: Empty State
                  if (modules.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.menu_book_outlined,
                            size: 56,
                            color: ColorConstant.textGreyColor,
                          ),
                          const SizedBox(height: Dimens.spaceSmallPadding),
                          Text(
                            "Belum ada modul untuk kelas ini",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.textDarkGreyColor,
                                ),
                          ),
                          const SizedBox(height: Dimens.spaceSmallPadding),
                          Text(
                            "Modul pembelajaran guru akan tampil di sini.",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ColorConstant.textGreyColor,
                                    ),
                          ),
                        ],
                      ),
                    );
                  }

                  // State 4: Success with Pull-to-refresh
                  return RefreshIndicator(
                    onRefresh: () => controller.onLoad(),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: modules.length,
                      itemBuilder: (context, i) {
                        return ModuleTeacherCardWidget(module: modules[i]);
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRowStatus() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TeacherModuleStatus.values.map((status) {
          return Padding(
            padding: const EdgeInsets.only(right: Dimens.spaceSmallPadding),
            child: ModuleFilterStatusWidget(status: status),
          );
        }).toList(),
      ),
    );
  }
}
