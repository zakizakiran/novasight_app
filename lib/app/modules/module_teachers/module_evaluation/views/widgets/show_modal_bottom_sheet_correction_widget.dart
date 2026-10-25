import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';

import '../../../../../data/model/module_teacher_model.dart';
import '../../../../../core/Dimens.dart';
import '../../../../../core/styles/icon_txt.dart';
import '../../../../../core/utils/validate_helper.dart';
class ShowModalBottomSheetCorrectionWidget extends GetView<ModuleEvaluationController> {
  const ShowModalBottomSheetCorrectionWidget({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      IconTxt.pencil,
                      style: TextStyle(fontSize: Dimens.iconRegularSize),
                    ),
                    Text(
                      context.l10n.correctionAnnotation,
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
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
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.circle)),
                    boxShadow: [BoxShadowConstant.module],
                  ),
                  child: const Icon(Icons.close),
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Dimens.innerPadding),
            decoration: BoxDecoration(
              color: ColorConstant.background,
              border: Border.all(color: ColorConstant.borderLightBlue),
              borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: ColorConstant.primary,
                    ),
                    const SizedBox(width: 6),
                    Obx(() => Text(
                      "Block yang Dipilih (${controller.selectedChunks.length}):",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.darkGrey,
                      ),
                    )),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.selectedChunks.isEmpty) {
                    return Text(
                      "Belum ada block yang dipilih. Silakan kembali dan centang block yang ingin diubah terlebih dahulu.",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstant.redColor,
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: controller.selectedChunks.map((c) {
                      final idx = controller.moduleTeacherModel.value.listChunks.indexOf(c);
                      final blockName = idx != -1 ? "Block ${idx + 1}" : "Block #${c.id}";
                      final isImage = c is ImageChunk;

                      Color badgeBg = Colors.blue.withValues(alpha: 0.15);
                      Color badgeColor = Colors.blue.shade800;
                      String typeLabel = "Teks";

                      if (isImage) {
                        final imgChunk = c as ImageChunk;
                        typeLabel = imgChunk.displayTypeLabel;
                        if (imgChunk.isTable) {
                          badgeBg = Colors.teal.withValues(alpha: 0.15);
                          badgeColor = Colors.teal.shade800;
                        } else if (imgChunk.isFormula) {
                          badgeBg = Colors.purple.withValues(alpha: 0.15);
                          badgeColor = Colors.purple.shade800;
                        } else if (imgChunk.isDiagram) {
                          badgeBg = Colors.indigo.withValues(alpha: 0.15);
                          badgeColor = Colors.indigo.shade800;
                        } else {
                          badgeBg = Colors.orange.withValues(alpha: 0.15);
                          badgeColor = Colors.deepOrange;
                        }
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ColorConstant.white,
                          borderRadius: BorderRadius.circular(Dimens.radius),
                          border: Border.all(
                            color: ColorConstant.borderLightBlue,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: ColorConstant.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    blockName,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstant.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeBg,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    typeLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: badgeColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              c.annotation != null && c.annotation!.isNotEmpty
                                  ? c.annotation!
                                  : (c is TextChunk ? c.text : "Blok $typeLabel Modul"),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: ColorConstant.darkGrey,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.enterCorrectionAdvice,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                context.l10n.explainAiCorrection,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _buildSuggestionChip(
                    context,
                    context.l10n.promptClarifyForBlind,
                  ),
                  _buildSuggestionChip(
                    context,
                    context.l10n.promptSimplifyLanguage,
                  ),
                  _buildSuggestionChip(
                    context,
                    context.l10n.promptDetailRowsCols,
                  ),
                  _buildSuggestionChip(
                    context,
                    context.l10n.promptExplainFormulaSteps,
                  ),
                ],
              ),
            ],
          ),
          Form(
            key: controller.formKey,
            child: Obx(() => CommonTextFormFieldWidget(
              controller: controller.adviceController,
              hint: 'Contoh: "Tolong jelaskan grafik/tabel ini lebih detail..."',
              maxLength: 500,
              minLines: 4,
              validator: ValidateHelper.isNormalValidate("Saran"),
              isReadOnly: controller.isLoading.value,
              onChanged: controller.onChange,
              borderSideFocused: const BorderSide(width: 1.5),
              hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstant.textGreyColor,
              ),
              borderSideEnable: const BorderSide(width: 1.5),
            )),
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
                child: Obx(() => CommonButtonWidget(
                  buttonName: context.l10n.sendToAi,
                  isValid: controller.isValid.value,
                  isLoading: controller.isLoading.value,
                  onPressed: () => controller.onSendAdvice(),
                )),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "AI akan memperbaiki bagian ini saja sesuai saranmu",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstant.informationColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context, String text) {
    return InkWell(
      onTap: () {
        if (controller.isLoading.value) return;
        final current = controller.adviceController.text.trim();
        if (current.isEmpty) {
          controller.adviceController.text = text;
        } else if (!current.contains(text)) {
          controller.adviceController.text = "$current. $text";
        }
        controller.onChange(controller.adviceController.text);
      },
      borderRadius: BorderRadius.circular(Dimens.circle),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(Dimens.circle),
          border: Border.all(
            color: ColorConstant.borderLightBlue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              size: 13,
              color: ColorConstant.primary,
            ),
            const SizedBox(width: 4),
            Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColorConstant.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
