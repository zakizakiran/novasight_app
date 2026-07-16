import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_card_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_filter_status_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_search_bar_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_teacher/views/widgets/module_teacher_appbar.dart';
import '../../../../core/utils/ui_state.dart';
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
              spacing: Dimens.spacePadding,
              children: [
                const ModuleTeacherAppbar(),
                const ModuleSearchBarWidget(),
                _buildRowStatus(),
                Expanded(
                  child: Obx(() {
                    final state = controller.state.value;
                    final modules = controller.filteredModules;
                    return switch (state) {
                      UiStateInitial<void>() || UiStateLoading<void>() =>
                      const Center(child: CircularProgressIndicator()),

                      UiStateFailure<void>(:final error) => Center(
                        child: Text(error),
                      ),

                      UiStateSuccess<void>() => ListView.builder(
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, i){
                            return ModuleTeacherCardWidget(module: modules[i]);
                          },
                          itemCount: modules.length
                      ),
                    };
                  }),
                ),
              ],
            ),
        ),
      ),
    );
  }
  Widget _buildRowStatus(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: Dimens.spacePadding,
        children: ModuleTeacherStatus.values.map((status) =>
        ModuleFilterStatusWidget(status: status)).toList(),
      ),
    );
  }
}
