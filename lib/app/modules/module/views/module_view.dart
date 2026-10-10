import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/common/common_gradient_progress_bar_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/models/module_model.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_card_widget.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_filter_tab_widget.dart';
import '../controllers/module_controller.dart';

class ModuleView extends GetView<ModuleController> {
  const ModuleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CommonAppBar(
            description: "Modul Pembelajaran",
            showBackButton: false,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => _buildRowTab(
                      selectedStatus: controller.selectedStatus.value,
                    ),
                  ),
                  const SizedBox(height: Dimens.spacePadding),
                  Expanded(
                    child: Obx(() {
                      final state = controller.state.value;

                      return switch (state) {
                        UiStateInitial<void>() ||
                        UiStateLoading<void>() =>
                          const Center(child: CircularProgressIndicator()),
                        UiStateFailure<void>(:final error) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    size: 48,
                                    color: ColorConstant.redColor,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    error,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: ColorConstant.textDarkGreyColor,
                                        ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: controller.onLoad,
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        UiStateSuccess<void>() => _buildContent(context),
                      };
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

  Widget _buildContent(BuildContext context) {
    if (controller.hasApiModules) {
      return _buildStudentModuleColumn(
        modules: controller.studentModules,
        onDetail: controller.onDetailStudent,
      );
    }

    final localModules = controller.filteredLocalModules;
    if (localModules.isEmpty) {
      return Center(
        child: Text(
          'Belum ada modul pada kategori ini.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstant.textGreyColor,
              ),
        ),
      );
    }

    return _buildLocalModuleColumn(
      modules: localModules,
      onDetail: controller.onDetail,
    );
  }

  Widget _buildRowTab({required ModuleStatus selectedStatus}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ModuleFilterTabWidget(
            status: ModuleStatus.all,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
          const SizedBox(width: Dimens.spaceMediumPadding),
          ModuleFilterTabWidget(
            status: ModuleStatus.notDone,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
          const SizedBox(width: Dimens.spaceMediumPadding),
          ModuleFilterTabWidget(
            status: ModuleStatus.done,
            selectedStatus: selectedStatus,
            onChanged: controller.onChangeStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentModuleColumn({
    required List<StudentModuleModel> modules,
    required void Function(StudentModuleModel) onDetail,
  }) {
    if (modules.isEmpty) {
      return const Center(
        child: Text(
          'Belum ada modul pada kategori ini.',
          style: TextStyle(color: ColorConstant.textGreyColor),
        ),
      );
    }

    return ListView.separated(
      itemCount: modules.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, i) {
        final module = modules[i];
        final percentage = module.progress?.progressPercentage ?? 0;
        final isDone = module.progress?.isDone ?? false;

        return Semantics(
          button: true,
          label:
              'Kartu Modul: ${module.title}, Progres: $percentage% selesai, Status: ${isDone ? "Selesai" : "Belum Selesai"}',
          child: GestureDetector(
            onTap: () => onDetail(module),
            child: CommonCardWidget(
              border: BorderStyleConstant.outlineBorderCard,
              boxShadow: const [BoxShadowConstant.module],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Materi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: ColorConstant.textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (isDone)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorConstant.lightGreen,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Selesai',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ColorConstant.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    module.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: ColorConstant.textDarkGreyColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  CommonGradientProgressBarWidget(
                    percentage: (percentage.clamp(0, 100)) / 100,
                    colors: const [
                      ColorConstant.linearSecondary,
                      ColorConstant.linearPrimary,
                    ],
                    stops: const [0.2, 1.0],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage% Selesai',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) =>
          const SizedBox(height: Dimens.spacePadding),
    );
  }

  Widget _buildLocalModuleColumn({
    required List<ModuleModel> modules,
    required void Function(ModuleModel) onDetail,
  }) {
    return ListView.separated(
      itemCount: modules.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, i) {
        return ModuleCardWidget(
          module: modules[i],
          onDetail: onDetail,
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: Dimens.spacePadding);
      },
    );
  }
}
