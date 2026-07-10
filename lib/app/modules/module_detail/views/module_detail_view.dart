import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/modules/module_detail/views/widgets/subject_card_widget.dart';

import '../../../core/Dimens.dart';
import '../controllers/module_detail_controller.dart';

class ModuleDetailView extends GetView<ModuleDetailController> {
  const ModuleDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    final module = controller.module;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonAppBar(title: "${module.subjects.length} Materi", description: module.title),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: Dimens.spacePadding,
                children: [
                  Text(
                    "Daftar Isi",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: ColorConstant.informationColor
                    ),
                  ),
                  _buildModuleColumn(module: module, onDetail: (SubjectModel subject){}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildModuleColumn({
    required ModuleModel module,
    required void Function(SubjectModel) onDetail,
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
            number: i + 1,
            subjectModel: module.subjects[i],
          ),
        ),
      ),
    );
  }
}
