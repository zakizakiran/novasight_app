
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';

import '../../../../common/common_button_widget.dart';
import '../../../../common/common_teacher_appbar.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/dialog_helper.dart';
import '../controllers/module_result_annotation_controller.dart';

class ModuleResultAnnotationView extends GetView<ModuleResultAnnotationController> {
  const ModuleResultAnnotationView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        DialogHelper.show(
            title: "Batal membuat modul?",
            description: "Modul Anda belum disimpan. Keluar sekarang akan menghilangkan progres anda",
            actions: Row(
              children: [
                Expanded(
                  child: CommonButtonWidget(
                      buttonName: "Iya",
                      buttonColor: ColorConstant.redColor,
                      onPressed: () {
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
        body: SafeArea(
          child: Column(
            children: [
              const CommonTeacherAppbar(
                  title: "Hasil Annotasi",
                  border: BorderStyleConstant.borderTeacherAppbar,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Dimens.innerPadding),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.moduleTeacherModel.listChunks.length,
                      itemBuilder: (context, i){
                        final chunk = controller.moduleTeacherModel.listChunks[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.spacePadding),
                          child: Text(
                              chunk.annotation ?? "",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
        Container(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          decoration: const BoxDecoration(
              color: ColorConstant.white,
              boxShadow: [
                BoxShadowConstant.subjectPage
              ]
          ),
          child: Row(
            children: [
              Expanded(
                child: CommonButtonWidget(
                    buttonName: "Evaluasi Ulang",
                    boxShadows: const [],
                    textColor: ColorConstant.primary,
                    onPressed: controller.onEvaluate,
                    buttonColor: ColorConstant.white,
                    border: const BorderSide(
                        color: ColorConstant.primary,
                        width: 1.5
                    ),
                ),
              ),
              const SizedBox(width: Dimens.spaceBigPadding),
              Expanded(
                child: CommonButtonWidget(
                    buttonName: "Simpan ke Modul",
                    onPressed: controller.onSaveModule
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
