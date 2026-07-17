import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_teacher_appbar.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/modules/module_teachers/create_module/views/widgets/pick_module_widget.dart';

import '../../../../common/common_dropdown_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/validate_helper.dart';
import '../controllers/create_module_controller.dart';

class CreateModuleView extends GetView<CreateModuleController> {
  const CreateModuleView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CommonTeacherAppbar(title: "Unggah Modul"),
              Padding(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Dimens.spacePadding,
                  children: [
                    const PickModuleWidget(),
                    Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: Dimens.spacePadding,
                        children: [
                          Obx(() => CommonTextFormFieldWidget(
                            title: "Judul Modul *",
                            controller: controller.titleModuleController,
                            hint: "Masukkan Judul Modul",
                            successColor: ColorConstant.primary,
                            isReadOnly: controller.isLoading.value,
                            onChanged: controller.onChange,
                            validator: ValidateHelper.isNormalValidate("Judul Modul"),
                            borderSideFocused: const BorderSide(
                                width: 1.5
                            ),
                            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColorConstant.textGreyColor
                            ),
                            borderSideEnable: const BorderSide(
                                width: 1.5
                            ),
                          ),
                          ),
                          Obx(() => CommonTextFormFieldWidget(
                            title: "Deskripsi (opsional) *",
                            controller: controller.descriptionModuleController,
                            hint: "Masukkan deskripsi modul...",
                            minLines: 4,
                            isReadOnly: controller.isLoading.value,
                            onChanged: controller.onChange,
                            borderSideFocused: const BorderSide(
                                width: 1.5
                            ),
                            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ColorConstant.textGreyColor
                            ),
                            borderSideEnable: const BorderSide(
                                width: 1.5
                            ),
                          ),
                          ),
                          Obx(() => CommonDropdownWidget<ClassGradeType>(
                              title: "Kelas",
                              listValue: controller.listClass,
                              selectedValue: controller.selectedGrade.value,
                              initialLabel: "Pilih Kelas",
                              itemLabel: (c) => c.name,
                              onSelect: controller.onSelectGrade
                          )
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
      Obx(() => Padding(
        padding: const EdgeInsets.all(Dimens.innerPadding),
        child: CommonButtonWidget(
              buttonName: "Unggah Modul",
              boxShadows: const [],
              isValid: controller.isValid.value,
              isLoading: controller.isLoading.value,
              onPressed: controller.onUploadModule
          ),
      ),
      ),
    );
  }
}
