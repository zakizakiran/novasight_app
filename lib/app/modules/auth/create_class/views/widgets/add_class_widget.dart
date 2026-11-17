import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/abstract/base_create_class_controller.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/auth/create_class/controllers/create_class_controller.dart';

import '../../../../../common/common_button_widget.dart';
import '../../../../../common/common_card_widget.dart';
import '../../../../../common/common_dropdown_widget.dart';
import '../../../../../common/common_text_form_field_widget.dart';
import '../../../../../core/Dimens.dart';
import '../../../../../core/styles/box_shadow_style.dart';
import '../../../../../core/styles/colors/color_constant.dart';
import '../../../../../core/utils/validate_helper.dart';
import '../../../../../data/models/classroom_model.dart';
import 'chip_grade_widget.dart';
import 'information_widget.dart';
class AddClassWidget extends StatelessWidget {
  const AddClassWidget({
    super.key,
    required this.controller,
  });

  final CreateClassController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.spacePadding,
            children: [
              Obx(
                    () => CommonTextFormFieldWidget(
                  title: "Nama Kelas *",
                  controller: controller.nameClass,
                  hint: "Masukkan Nama Kelas",
                  successColor: ColorConstant.primary,
                  isReadOnly: controller.isLoading.value,
                  onChanged: controller.onChange,
                  validator: ValidateHelper.isNormalValidate(
                      "Nama Kelas"),
                  borderSideFocused:
                  const BorderSide(width: 1.5),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                      color: ColorConstant.textGreyColor),
                  borderSideEnable:
                  const BorderSide(width: 1.5),
                ),
              ),
              // Subject dropdown — fetched from API /api/classroom-types
              Obx(
                    () => CommonDropdownWidget<ClassroomTypeModel>(
                  title: "Mata Pelajaran *",
                  listValue: controller.classroomTypes,
                  selectedValue:
                  controller.selectedClassroomType.value,
                  initialLabel: "Pilih Mata Pelajaran",
                  itemLabel: (type) => type.name,
                  onSelect: controller.onSelectClassroomType,
                ),
              ),
              Text(
                "Tingkat Kelas *",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Obx(() {
                return Wrap(
                  spacing: Dimens.spacePadding,
                  runSpacing: Dimens.spacePadding,
                  children:
                  controller.gradeOptions.map((grade) {
                    return ChipGradeWidget(
                      value: grade,
                      label: "Kelas $grade",
                      isSelected:
                      controller.selectedGrade.value ==
                          grade,
                      onSelected: controller.onSelectGrade,
                    );
                  }).toList(),
                );
              }),
              Text(
                "Pilih satu tingkat kelas",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
              ),
              // City dropdown — fetched from API /api/cities
              Obx(
                    () =>
                    CommonDropdownWidget<CityResponseModel>(
                      title: "Nama Kota *",
                      listValue: controller.cities,
                      selectedValue:
                      controller.selectedCity.value,
                      initialLabel: "Pilih Kota",
                      itemLabel: (c) => c.name,
                      onSelect: controller.onSelectCity,
                    ),
              ),
              // School dropdown — fetched from API /api/schools/city/{city_id}
              Obx(
                    () => CommonDropdownWidget<
                    SchoolResponseModel>(
                  title: "Nama Sekolah *",
                  isEnabled: controller.selectedCity.value != null &&
                      !controller.isLoadingSchools.value,
                  listValue: controller.schools,
                  selectedValue:
                  controller.selectedSchool.value,
                  initialLabel: controller.selectedCity.value == null
                      ? "Pilih Kota terlebih dahulu"
                      : (controller.isLoadingSchools.value
                      ? "Memuat daftar sekolah..."
                      : "Pilih Sekolah"),
                  itemLabel: (s) => s.name,
                  onSelect: controller.onSelectSchool,
                ),
              ),
            ],
          ),
        ),
        const InformationWidget(),
        Obx(
              () => CommonButtonWidget(
            buttonWidth: double.infinity,
            isLoading: controller.isLoading.value,
            isValid: controller.isValid.value,
            buttonName: context.l10n.addClassroom,
            onPressed: controller.onCreateClass,
          ),
        ),
      ],
    );
  }
}

