import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/chunk_card_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/show_modal_bottom_sheet_correction_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/show_modal_bottom_sheet_text_edit_widget.dart';

import '../../../../common/common_button_widget.dart';
import '../../../../common/common_teacher_appbar.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/border_style.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/dialog_helper.dart';
import '../../../../core/utils/show_modal_bottom_sheet_helper.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../data/model/module_teacher_model.dart';
import '../controllers/module_evaluation_controller.dart';

class ModuleEvaluationView extends GetView<ModuleEvaluationController> {
  const ModuleEvaluationView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !controller.isLoading.value,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        DialogHelper.show(
            title: "Annoter Sedang Memperbarui Anotasi",
            description: "Hentikan pembaruan? Perubahan yang belum tersimpan mungkin akan hilang.",
            actions: Row(
              children: [
                Expanded(
                  child: CommonButtonWidget(
                      buttonName: "Iya",
                      buttonColor: ColorConstant.redColor,
                      onPressed: () {
                        controller.cancelLoadingProcess();
                        Get.back();
                        Get.back();
                      }
                  ),
                ),
                const SizedBox(width: Dimens.spacePadding),
                Expanded(
                  child: CommonButtonWidget(
                      buttonName: "Tidak",
                      onPressed: () {
                        Get.back();
                      }
                  ),
                ),
              ],
            )
        );
      },
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        body: SafeArea(
          child: Column(
            children: [
              const CommonTeacherAppbar(
                title: "Annoter — Evaluasi Modul",
                border: BorderStyleConstant.borderTeacherAppbar,
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: ColorConstant.borderBlueGrey,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Sebelum Anotasi",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorConstant.darkGrey,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Sesudah Anotasi",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: ColorConstant.darkGrey,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Obx(() {
                final selectedList = controller.selectedChunks;
                if (selectedList.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacePadding,
                      vertical: 8,
                    ),
                    color: ColorConstant.background,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: ColorConstant.grey,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Centang blok: Teks untuk edit langsung, atau Blok Khusus (Gambar, Tabel, Formula) untuk revisi AI.",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: ColorConstant.darkGrey,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final isText = controller.isTextSelected;
                final blockDescriptions = selectedList.map((c) {
                  final idx = controller.moduleTeacherModel.value.listChunks
                      .indexOf(c);
                  final label =
                      idx != -1 ? "Block ${idx + 1}" : "Block #${c.id}";
                  final type = c is ImageChunk ? c.displayTypeLabel : "Teks";
                  return "$label ($type)";
                }).join(", ");

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.spacePadding,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isText
                        ? ColorConstant.primary.withValues(alpha: 0.08)
                        : Colors.orange.withValues(alpha: 0.10),
                    border: Border(
                      bottom: BorderSide(
                        color: isText
                            ? ColorConstant.primary
                            : Colors.deepOrange,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isText
                            ? Icons.edit_note_rounded
                            : Icons.auto_awesome_rounded,
                        size: 18,
                        color: isText
                            ? ColorConstant.primary
                            : Colors.deepOrange,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          isText
                              ? "Mode Edit Teks Langsung: $blockDescriptions"
                              : "Mode Revisi AI (${selectedList.length} Blok Khusus): $blockDescriptions",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isText
                                        ? ColorConstant.primary
                                        : Colors.deepOrange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!isText && controller.canSelectAllSpecial) ...[
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: controller.toggleSelectAllSpecial,
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.deepOrange,
                              ),
                            ),
                            child: Text(
                              controller.isAllSpecialSelected
                                  ? "Batal Pilih"
                                  : "Pilih Semua",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),

              Expanded(
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimens.spacePadding,
                      vertical: Dimens.innerPadding,
                    ),
                    itemCount:
                        controller.moduleTeacherModel.value.listChunks.length,
                    itemBuilder: (context, i) {
                      final chunk =
                          controller.moduleTeacherModel.value.listChunks[i];
                      return ChunkCardWidget(
                        chunk: chunk,
                        blockNumber: i + 1,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          decoration: const BoxDecoration(
            color: ColorConstant.white,
            boxShadow: [BoxShadowConstant.subjectPage],
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  final count = controller.selectedChunks.length;
                  final isText = controller.isTextSelected;

                  String buttonName;
                  if (count == 0) {
                    buttonName = "Ubah Anotasi";
                  } else if (isText) {
                    buttonName = "Edit Teks Anotasi";
                  } else {
                    buttonName = "Revisi ($count) dengan AI";
                  }

                  return CommonButtonWidget(
                    buttonName: buttonName,
                    boxShadows: const [],
                    textColor: ColorConstant.primary,
                    onPressed: () {
                      if (controller.selectedChunks.isEmpty) {
                        SnackbarHelper.showError(
                          title: "Pilih Block Terlebih Dahulu",
                          message:
                              "Silakan centang block teks untuk edit langsung, atau block gambar untuk revisi AI.",
                        );
                        return;
                      }

                      if (isText) {
                        controller.prepareTextEdit();
                        ShowModalBottomSheetHelper.showCustomBottomSheet(
                          const ShowModalBottomSheetTextEditWidget(),
                        );
                      } else {
                        ShowModalBottomSheetHelper.showCustomBottomSheet(
                          const ShowModalBottomSheetCorrectionWidget(),
                        );
                      }
                    },
                    buttonColor: ColorConstant.white,
                    border: const BorderSide(
                      color: ColorConstant.primary,
                      width: 1.5,
                    ),
                  );
                }),
              ),
              const SizedBox(width: Dimens.spaceBigPadding),
              Expanded(
                child: Obx(
                  () => CommonButtonWidget(
                    buttonName: "Simpan ke Modul",
                    isValid: !controller.isLoading.value,
                    onPressed: controller.onSaveModule,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
