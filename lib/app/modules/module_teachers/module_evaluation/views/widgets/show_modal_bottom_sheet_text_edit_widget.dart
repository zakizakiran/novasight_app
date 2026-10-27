import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_button_widget.dart';
import 'package:lydera_app/app/common/common_text_form_field_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/box_shadow_style.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/styles/icon_txt.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/core/utils/validate_helper.dart';
import 'package:lydera_app/app/data/model/module_teacher_model.dart';
import 'package:lydera_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';

class ShowModalBottomSheetTextEditWidget
    extends GetView<ModuleEvaluationController> {
  const ShowModalBottomSheetTextEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Dimens.spacePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.spacePadding,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  spacing: Dimens.spacePadding,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      IconTxt.pencil,
                      style: TextStyle(fontSize: Dimens.iconRegularSize),
                    ),
                    Text(
                      context.l10n.editTextAnnotationHeader,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Dimens.spacePadding),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(Dimens.innerPadding),
                  decoration: const BoxDecoration(
                    color: ColorConstant.background,
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.circle)),
                    boxShadow: [BoxShadowConstant.module],
                  ),
                  child: const Icon(Icons.close),
                ),
              ),
            ],
          ),

          // Block identifier and source text preview
          Obx(() {
            if (controller.selectedChunks.isEmpty ||
                controller.selectedChunks.first is! TextChunk) {
              return const SizedBox.shrink();
            }
            final chunk = controller.selectedChunks.first as TextChunk;
            final idx = controller.moduleTeacherModel.value.listChunks
                .indexOf(chunk);
            final blockName =
                idx != -1 ? "Block ${idx + 1}" : "Block #${chunk.id}";

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Dimens.innerPadding),
              decoration: BoxDecoration(
                color: ColorConstant.background,
                border: Border.all(color: ColorConstant.borderLightBlue),
                borderRadius:
                    const BorderRadius.all(Radius.circular(Dimens.radius)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "$blockName (Teks)",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        context.l10n.directEdit,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstant.darkGrey,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  if (chunk.text.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.originalText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.grey,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      chunk.text,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConstant.darkGrey,
                          ),
                    ),
                  ],
                ],
              ),
            );
          }),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.changeAnnotationText,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Edit langsung isi penjelasan atau deskripsi anotasi untuk siswa",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.darkGrey,
                    ),
              ),
            ],
          ),

          Form(
            key: controller.textFormKey,
            child: CommonTextFormFieldWidget(
              controller: controller.textEditController,
              hint: "Masukkan teks anotasi yang sudah diperbaiki...",
              maxLength: 1000,
              minLines: 4,
              validator: ValidateHelper.isNormalValidate("Teks Anotasi"),
              onChanged: controller.onTextChange,
              borderSideFocused: const BorderSide(width: 1.5),
              borderSideEnable: const BorderSide(width: 1.5),
            ),
          ),

          Row(
            children: [
              Expanded(
                child: CommonButtonWidget(
                  buttonName: context.l10n.cancel,
                  onPressed: () => Get.back(),
                  boxShadows: const [],
                  buttonColor: ColorConstant.secondary,
                  border: const BorderSide(
                    color: ColorConstant.borderBlueGrey,
                    width: Dimens.border,
                  ),
                  textColor: ColorConstant.darkGrey,
                ),
              ),
              const SizedBox(width: Dimens.spaceBigPadding),
              Expanded(
                child: Obx(
                  () => CommonButtonWidget(
                    buttonName: context.l10n.saveAnnotation,
                    isValid: controller.isTextValid.value,
                    onPressed: () => controller.onSaveDirectText(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
