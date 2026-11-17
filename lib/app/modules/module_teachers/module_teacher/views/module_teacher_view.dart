import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/models/teacher_model.dart';
import 'package:lydera_app/app/modules/module_teachers/module_teacher/views/widgets/module_card_widget.dart';
import 'package:lydera_app/app/modules/module_teachers/module_teacher/views/widgets/module_filter_status_widget.dart';
import 'package:lydera_app/app/modules/module_teachers/module_teacher/views/widgets/module_search_bar_widget.dart';
import 'package:lydera_app/app/modules/module_teachers/module_teacher/views/widgets/module_teacher_appbar.dart';
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
                  final modules = controller.teacherModules;

                  Widget content;

                  // State 1: Initial Loading
                  if (controller.isLoading.value && modules.isEmpty) {
                    content = ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ],
                    );
                  }

                  // State 2: Error
                  else if (controller.errorMessage.value.isNotEmpty &&
                      modules.isEmpty) {
                    content = ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 300,
                          child: Center(
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
                                  const SizedBox(
                                    height: Dimens.spaceSmallPadding,
                                  ),
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
                                    buttonName: context.l10n.tryAgain,
                                    onPressed: () => controller.onLoad(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // State 3: Empty
                  else if (modules.isEmpty) {
                    content = ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 300,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.menu_book_outlined,
                                  size: 56,
                                  color: ColorConstant.textGreyColor,
                                ),
                                const SizedBox(
                                  height: Dimens.spaceSmallPadding,
                                ),
                                Text(
                                  context.l10n.noModulesForClass,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.textDarkGreyColor,
                                  ),
                                ),
                                const SizedBox(
                                  height: Dimens.spaceSmallPadding,
                                ),
                                Text(
                                  "Modul pembelajaran guru akan tampil di sini.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                    color: ColorConstant.textGreyColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  // State 4: Success
                  else {
                    content = ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: modules.length,
                      itemBuilder: (context, i) {
                        return ModuleTeacherCardWidget(
                          module: modules[i],
                        );
                      },
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.onLoad,
                    child: content,
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
