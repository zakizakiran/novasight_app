import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/common/common_text_form_field_widget.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/modules/module_teachers/module_evaluation/controllers/module_evaluation_controller.dart';

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
                      "Koreksi Anotasi",
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
                const Text("Anotasi yang dipilih:"),
                Obx(() => Text(
                  controller.selectedChunks.map((c) => c.annotation).join("\n"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.primary,
                  ),
                ))
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Masukkan saran perbaikan",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                "Jelaskan bagaimana AI harus memperbaiki anotasi ini",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.darkGrey,
                ),
              ),
            ],
          ),
          Form(
            key: controller.formKey,
            child: Obx(() => CommonTextFormFieldWidget(
              controller: controller.adviceController,
              hint: 'Contoh: "Tolong buat penjelasan lebih singkat..."',
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
                  buttonName: "Batal",
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
                  buttonName: "Kirim ke AI →",
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
}
