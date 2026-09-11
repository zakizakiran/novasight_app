import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_dropdown_widget.dart';
import 'package:novasight_app/app/data/models/classroom_model.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/widgets/chip_grade_widget.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/widgets/information_widget.dart';
import 'package:novasight_app/app/modules/auth/widgets/step_indicator_widget.dart';
import '../../../../common/common_button_widget.dart';
import '../../../../common/common_card_widget.dart';
import '../../../../common/common_text_form_field_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/icon_txt.dart';
import '../../../../core/utils/validate_helper.dart';
import '../../widgets/auth_appbar.dart';
import '../controllers/create_class_controller.dart';

class CreateClassView extends GetView<CreateClassController> {
  const CreateClassView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.35;
    return Scaffold(
      body: Obx(() {
        // Show loading indicator while initial data is being fetched
        if (controller.isLoadingData.value) {
          return Column(
            children: [
              AuthAppbar(
                icon: IconTxt.classIcon,
                title: "Buat Kelas Kamu",
                description: "Isi informasi kelas untuk memulai",
                height: appBarHeight,
                top: const StepIndicatorWidget(step: 1, maxStep: 2),
              ),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        // Show error and retry if initial data failed to load
        if (controller.classroomTypes.isEmpty &&
            controller.cities.isEmpty &&
            controller.errorMessage.value.isNotEmpty) {
          return Column(
            children: [
              AuthAppbar(
                icon: IconTxt.classIcon,
                title: "Buat Kelas Kamu",
                description: "Isi informasi kelas untuk memulai",
                height: appBarHeight,
                top: const StepIndicatorWidget(step: 1, maxStep: 2),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.innerPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: ColorConstant.redColor,
                        ),
                        const SizedBox(height: Dimens.spacePadding),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: Dimens.spacePadding),
                        ElevatedButton(
                          onPressed: controller.retryLoadInitialData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorConstant.primary,
                            foregroundColor: ColorConstant.white,
                          ),
                          child: const Text("Coba Lagi"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              AuthAppbar(
                icon: IconTxt.classIcon,
                title: "Buat Kelas Kamu",
                description: "Isi informasi kelas untuk memulai",
                height: appBarHeight,
                top: const StepIndicatorWidget(step: 1, maxStep: 2),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimens.innerPadding),
                child: CommonCardWidget(
                  boxShadow: const [
                    BoxShadowConstant.authPrimary,
                    BoxShadowConstant.auth,
                  ],
                  margin: const EdgeInsets.only(top: Dimens.innerPadding),
                  child: Column(
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
                          buttonName: "Buat Kelas",
                          onPressed: controller.onCreateClass,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
