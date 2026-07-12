import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/modules/module_detail/views/widgets/subject_card_widget.dart';

import '../../../core/Dimens.dart';
import '../../../data/model/subject_model.dart';
import '../controllers/module_detail_controller.dart';

class ModuleDetailView extends GetView<ModuleDetailController> {
  const ModuleDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final state = controller.state.value;
              final module = controller.module;

              return switch (state) {
                UiStateInitial<void>() ||
                UiStateLoading<void>() => Center(
                  child: const CircularProgressIndicator(),
                ),

                UiStateFailure<void>(:final error) => Center(
                  child: Text(error),
                ),

                UiStateSuccess<void>() => Column(
                    children: [
                      CommonAppBar(
                        title: "${module.subjects.length} Materi",
                        description: module.title,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(Dimens.innerPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: Dimens.spacePadding,
                          children: [
                            Text(
                              "Daftar Isi",
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: ColorConstant.informationColor,
                                fontWeight: FontWeight.w800
                              ),
                            ),
                            _buildModuleColumn(
                              module: module,
                              onDetail: controller.onSubject,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                };
            })
          ],
        ),
      ),
    );
  }
  Widget _buildModuleColumn({
    required ModuleModel module,
    required void Function(SubjectModel, int) onDetail,
  }) {
    return Column(
      children: List.generate(
        module.subjects.length,
            (i) => Padding(
          padding: EdgeInsets.only(
            bottom: i == module.subjects.length - 1
                ? 0
                : Dimens.spacePadding,
          ),
          child: SubjectCardWidget(
            onDetail: (){
              onDetail(module.subjects[i],i);
            },
            number: i + 1,
            subjectModel: module.subjects[i],
          ),
        ),
      ),
    );
  }
}
