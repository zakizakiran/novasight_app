import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:lydera_app/app/modules/module_teachers/create_module/views/widgets/pick_module_widget.dart';

import '../../../common/common_button_widget.dart';
import '../../../common/common_dropdown_widget.dart';
import '../../../common/common_teacher_appbar.dart';
import '../../../common/common_text_form_field_widget.dart';
import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/cp_model.dart';
import '../../../data/models/fase_model.dart';
import '../controllers/add_chapter_controller.dart';

class AddChapterView extends GetView<AddChapterController> {
  const AddChapterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Column(
            spacing: Dimens.spaceSm,
            children: [
              const SizedBox.shrink(),
              CommonTeacherAppbar(
                title: context.l10n.addChapter
              ),
              PickModuleWidget(
                selectedPdf: controller.selectedPdf,
                onPickModule: controller.onPickModule
              ),
              Obx(() {
                if(controller.selectedPdf.value != null){
                  return _buildChapterSplitForm(context);
                }
                return const SizedBox.shrink();
              },)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChapterSplitForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Saved module summary card
        Container(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green.shade600,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.totalDocPages(controller.totalPages.value),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstant.textGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimens.spacePadding),
        Obx(
              () => CommonDropdownWidget<FaseModel>(
            title: context.l10n.fase,
            listValue: controller.listFase,
            selectedValue: controller.selectedFase.value,
            initialLabel: controller.isLoadingFase.value
                ? context.l10n.loadingFases
                : context.l10n.selectFase,
            itemLabel: (f) => f.displayName,
            onSelect: controller.onSelectFase,
            isEnabled:
            !controller.isSavingModule.value &&
                !controller.isLoadingFase.value,
          ),
        ),
        const SizedBox(height: Dimens.spacePadding),

        // Cutting section container
        Container(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(color: ColorConstant.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.chapterSplitConfig,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.chapterSplitDesc,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
              ),
              const SizedBox(height: Dimens.spacePadding),

              // Chapter Number & Title
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 90,
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.chapter,
                      controller: controller.chapterNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hint: "cth: 1",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                        fontStyle: FontStyle.italic,
                      ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacePadding),
                  Expanded(
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.chapterTitleField,
                      controller: controller.chapterTitleController,
                      hint: "cth: BAB I : Eksponen",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                        fontStyle: FontStyle.italic,
                      ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.spacePadding),

              // Page Range Selection (Start Page -> End Page)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.startPageField,
                      controller: controller.startPageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hint: "cth: 1",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                        fontStyle: FontStyle.italic,
                      ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                  const SizedBox(width: Dimens.spacePadding),
                  Expanded(
                    child: CommonTextFormFieldWidget(
                      title: context.l10n.endPageField,
                      controller: controller.endPageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      hint: "cth: ${controller.totalPages.value > 0 ? controller.totalPages.value : '44'}",
                      hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                        fontStyle: FontStyle.italic,
                      ),
                      borderSideFocused: const BorderSide(width: 1.5),
                      borderSideEnable: const BorderSide(width: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Cp dropdown
              Obx(
                    () => CommonDropdownWidget<CpModel>(
                  title: context.l10n.learningCompetency,
                  listValue: controller.listCp,
                  selectedValue: controller.selectedCp.value,
                  initialLabel: controller.isLoadingCp.value
                      ? context.l10n.loadingCompetency
                      : context.l10n.selectCompetency,
                  itemLabel: (c) => c.cpText,
                  onSelect: controller.onSelectCp,
                  isEnabled: !controller.isLoadingCp.value,
                ),
              ),

              // Hint info
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorConstant.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: ColorConstant.textGreyColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        context.l10n.exampleChapterRangeHint,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: ColorConstant.textGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Dimens.spacePadding),

              // Action button to cut & create chapter
              Obx(() =>
                CommonButtonWidget(
                  buttonName: context.l10n.processAndCreateChapter,
                  boxShadows: const [],
                  isValid: true,
                  isLoading: controller.isCreatingChapter.value,
                  onPressed: controller.onCreateChapter,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
