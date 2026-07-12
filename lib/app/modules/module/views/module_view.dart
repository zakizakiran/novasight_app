import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_card_widget.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_filter_tab_widget.dart';

import '../../../core/utils/module_status.dart';
import '../../../core/utils/ui_state.dart';
import '../controllers/module_controller.dart';

class ModuleView extends GetView<ModuleController> {
  const ModuleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CommonAppBar(description: "Modul Pembelajaran"),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Dimens.spacePadding,
                  children: [
                    Obx(
                            () => _buildRowTab(selectedStatus: controller.selectedStatus.value)
                    ),
                    Expanded(
                      child: Obx(() {
                        final state = controller.state.value;
                        final modules = controller.filteredModules;
                        return switch (state) {
                          UiStateInitial<void>() ||
                          UiStateLoading<void>() =>
                          const Center(
                            child: CircularProgressIndicator(),
                          ),

                          UiStateFailure<void>(:final error) =>
                              Center(
                                child: Text(error),
                              ),

                          UiStateSuccess<void>(:final data) =>
                              _buildModuleColumn(
                                modules: modules,
                                onDetail: controller.onDetail,
                              ),
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

  Widget _buildRowTab({
    required ModuleStatus selectedStatus
  }){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: Dimens.spaceMediumPadding,
        children: [
          ModuleFilterTabWidget(status: ModuleStatus.all, selectedStatus: selectedStatus,onChanged: controller.onChangeStatus,),
          ModuleFilterTabWidget(status: ModuleStatus.notDone, selectedStatus: selectedStatus,onChanged: controller.onChangeStatus),
          ModuleFilterTabWidget(status: ModuleStatus.done, selectedStatus: selectedStatus,onChanged: controller.onChangeStatus)
        ],
      ),
    );
  }

  Widget _buildModuleColumn({
    required List<ModuleModel> modules,
    required void Function(ModuleModel) onDetail
}){
    return ListView.separated(
        itemCount: modules.length,

        itemBuilder: (context, i) {
          return ModuleCardWidget(module: modules[i],onDetail: onDetail,);
        },
      separatorBuilder: (BuildContext context, int index) { 
          return SizedBox(height: Dimens.spacePadding);
      },
    );
  }
}
