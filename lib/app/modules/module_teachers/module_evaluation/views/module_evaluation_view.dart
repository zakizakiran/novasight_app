import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/chunk_card_widget.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/views/widgets/show_modal_bottom_sheet_correction_widget.dart';

import '../../../../common/common_button_widget.dart';
import '../../../../common/common_teacher_appbar.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/border_style.dart';
import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/dialog_helper.dart';
import '../../../../core/utils/show_modal_bottom_sheet_helper.dart';
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
            title: "AI Sedang Memperbarui Anotasi",
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
                title: "Evaluasi Annotasi",
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

              Expanded(
                child: Obx(() => ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.moduleTeacherModel.value.listChunks.length,
                  itemBuilder: (context, i) {
                    final chunk = controller.moduleTeacherModel.value.listChunks[i];
                    return ChunkCardWidget(chunk: chunk);
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
                child: CommonButtonWidget(
                  buttonName: "Evaluasi Anotasi",
                  boxShadows: const [],
                  textColor: ColorConstant.primary,
                  onPressed: () => ShowModalBottomSheetHelper.showCustomBottomSheet(const ShowModalBottomSheetCorrectionWidget()),
                  buttonColor: ColorConstant.white,
                  border: const BorderSide(
                    color: ColorConstant.primary,
                    width: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spaceBigPadding),
              Expanded(
                child: Obx(() => CommonButtonWidget(
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
