import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';
import 'package:novasight_app/app/modules/module_teacher/controllers/module_teacher_controller.dart';
class ModuleSearchBarWidget extends GetView<ModuleTeacherController> {
  const ModuleSearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonTextFormFieldWidget(
        controller: controller.searchController,
        hint: "${IconTxt.lens} Cari modul...",
        onChanged: controller.onChange,
        fillColor: ColorConstant.white,
        borderSideFocused: const BorderSide(
          width: 1.5
      ),
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstant.textGreyColor
        ),
        borderSideEnable: const BorderSide(
          width: 1.5
      ),
    );
  }
}

