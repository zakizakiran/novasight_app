import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/icon_txt.dart';

import '../../controllers/module_teacher_controller.dart';
class ModuleSearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChange;
  const ModuleSearchBarWidget({super.key, required this.controller, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return CommonTextFormFieldWidget(
        controller: controller,
        prefixIcon: const Text(IconTxt.lens),
        hint: "Cari modul...",
        onChanged: onChange,
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

