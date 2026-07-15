import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_dropdown_widget.dart';
import 'package:novasight_app/app/data/model/city_model.dart';
import 'package:novasight_app/app/data/model/school_model.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/widgets/chip_grade_level_widget.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/widgets/information_widget.dart';
import 'package:novasight_app/app/modules/auth/create_class/views/widgets/step_indicator_widget.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthAppbar(icon: IconTxt.classIcon, title: "Buat Kelas Kamu", description: "Isi informasi kelas untuk memulai",height: appBarHeight,
              top: const StepIndicatorWidget(step: 1),),
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
                          Obx(() => CommonTextFormFieldWidget(
                            title: "Nama Kelas *",
                            controller: controller.nameClass,
                            hint: "Masukkan Nama Kelas",
                            successColor: ColorConstant.primary,
                            isReadOnly: controller.isLoading.value,
                            onChanged: controller.onChange,
                            validator: ValidateHelper.isNormalValidate("Nama Kelas"),
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
                            title: "Nama Pelajaran *",
                            controller: controller.nameLecture,
                            hint: "Masukkan Nama Mata Pelajaran",
                            successColor: ColorConstant.primary,
                            isReadOnly: controller.isLoading.value,
                            onChanged: controller.onChange,
                            validator: ValidateHelper.isNormalValidate("Nama Mata Pelajaran"),
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
                          Text(
                            "Tingkat Kelas *",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Obx(() {
                            return Wrap(
                              spacing: Dimens.spacePadding,
                              runSpacing: Dimens.spacePadding,
                              children: controller.listClass.value
                                  .map(
                                    (g) => ChipGradeLevelWidget(
                                  value: g,
                                  selectedGrade: controller.onSelectGrade,
                                  selectedGradeType: controller.selectedListClass.value,
                                ),
                              ).toList(),
                            );
                          }),
                          Text(
                              "Bisa pilih lebih dari satu kelas",
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: ColorConstant.textGreyColor,
                              ),
                          ),
                          Obx(() => CommonDropdownWidget<CityModel>(
                              title: "Nama Kota *",
                              listValue: controller.cities,
                              selectedValue: controller.selectedCity.value,
                              initialLabel: "Pilih Kota",
                              itemLabel: (c) => c.name,
                              onSelect: controller.onSelectCity
                          )
                          ),
                          Obx(() => CommonDropdownWidget<SchoolModel>(
                              title: "Nama Sekolah *",
                              listValue: controller.schools,
                              selectedValue: controller.selectedSchool.value,
                              initialLabel: "Pilih Sekolah",
                              itemLabel: (s) => s.name,
                              onSelect: controller.onSelectSchool
                          )
                          )
                        ],
                      ),
                    ),
                    const InformationWidget(),
                    Obx(() => CommonButtonWidget(
                        buttonWidth: double.infinity,
                        isLoading: controller.isLoading.value,
                        isValid: controller.isValid.value,
                        buttonName: "Buat Kelas",
                        onPressed: controller.onCreateClass
                    )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
