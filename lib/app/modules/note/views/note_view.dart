import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../controllers/note_controller.dart';

class NoteView extends GetView<NoteController> {
  const NoteView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isInputActive.value) {
          controller.deactivateInput();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorConstant.background,
        body: Column(
          children: [
            CommonAppBar(
              title: "Catatan Pengerjaan",
              description: "Soal ${controller.index} dari ${controller.total}",
            ),
            Expanded(
              child: GestureDetector(
                onTap: controller.deactivateInput,
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.all(Dimens.innerPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildQuestionCard(context),
                      const SizedBox(height: Dimens.spaceBigPadding),
                      Semantics(
                        header: true,
                        child: Text(
                          "Langkah Pengerjaan",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: ColorConstant.textDarkGreyColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      const SizedBox(height: Dimens.spacePadding),
                      Obx(
                        () => Column(
                          children: [
                            for (int i = 0; i < controller.steps.length; i++)
                              _buildStepItem(context, i, controller.steps[i]),
                            _buildInputBox(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Obx(
              () => controller.isInputActive.value
                  ? _buildMathKeyboard(context)
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    return CommonCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              "SOAL",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ColorConstant.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: Dimens.spaceSmallPadding),
          Semantics(
            child: Text(
              controller.question?.questionText ?? "",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ColorConstant.textDarkGreyColor,
              ),
            ),
          ),
          const SizedBox(height: Dimens.spaceMediumPadding),
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              button: true,
              label: "Baca Ulang Soal",
              child: GestureDetector(
                onTap: controller.readAloud,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(Dimens.radius),
                    border: Border.all(color: ColorConstant.borderBlueGrey),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.record_voice_over,
                        color: ColorConstant.textDarkGreyColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Baca Ulang",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, int index, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacePadding),
      child: Semantics(
        label: "Langkah ${index + 1}: $text",
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.innerBigPadding,
            horizontal: Dimens.innerMediumPadding,
          ),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(color: ColorConstant.borderBlueGrey),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: ColorConstant.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${index + 1}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spaceBigPadding),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: ColorConstant.textDarkGreyColor,
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: "Hapus langkah ${index + 1}",
                child: GestureDetector(
                  onTap: () => controller.removeStep(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: ColorConstant.lightRedColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: ColorConstant.redColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(BuildContext context) {
    return Semantics(
      button: true,
      label: controller.activeInputText.value.isEmpty
          ? "Ketuk untuk input langkah baru"
          : "Input saat ini: ${controller.activeInputText.value}. Ketuk untuk mengedit.",
      child: GestureDetector(
        onTap: controller.activateInput,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.innerBigPadding,
            horizontal: Dimens.innerMediumPadding,
          ),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(
              color: controller.isInputActive.value
                  ? ColorConstant.primary
                  : ColorConstant.borderBlueGrey,
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.add, color: ColorConstant.primary, size: 20),
              const SizedBox(width: Dimens.spaceMediumPadding),
              Expanded(
                child: Text(
                  controller.activeInputText.value.isEmpty
                      ? "Ketuk untuk input langkah baru..."
                      : controller.activeInputText.value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: controller.activeInputText.value.isEmpty
                        ? ColorConstant.textGreyColor
                        : ColorConstant.textDarkGreyColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMathKeyboard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorConstant.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tabs
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Math", "Greek", "ABC", "Advanced"].map((tab) {
              return Semantics(
                button: true,
                label: "Tab $tab",
                selected: controller.activeKeyboardTab.value == tab,
                child: InkWell(
                  onTap: () => controller.activeKeyboardTab.value = tab,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      tab,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: controller.activeKeyboardTab.value == tab
                            ? ColorConstant.primary
                            : ColorConstant.textGreyColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const Divider(height: 1, color: ColorConstant.borderBlueGrey),
          // Grid
          Container(
            padding: const EdgeInsets.all(8),
            color: ColorConstant.background,
            child: Column(
              children: [
                _buildKeyboardRow(context, [
                  "log",
                  "pangkat",
                  "akar",
                  "log basis",
                ]),
                _buildKeyboardRow(context, ["7", "8", "9", "⌫"]),
                _buildKeyboardRow(context, ["4", "5", "6", "×"]),
                _buildKeyboardRow(context, ["1", "2", "3", "-"]),
                _buildKeyboardRow(context, [".", "0", "=", "÷"]),
                _buildKeyboardRow(context, ["+", "-", "(", ")"]),
              ],
            ),
          ),
          // Save Button
          Padding(
            padding: const EdgeInsets.all(Dimens.innerPadding),
            child: Semantics(
              button: true,
              label: "Simpan Langkah",
              child: CommonButtonWidget(
                buttonName: "Simpan Langkah",
                onPressed: controller.saveStep,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(BuildContext context, List<String> keys) {
    return Row(
      children: keys.map((key) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Semantics(
              button: true,
              label: key == "⌫" ? "Hapus karakter terakhir" : "Ketik $key",
              child: InkWell(
                onTap: () {
                  if (key == "⌫") {
                    controller.removeLastCharacter();
                  } else {
                    String text = key;
                    if (key == "×") text = "×";
                    if (key == "÷") text = "÷";
                    controller.addTextToInput(text);
                  }
                },
                child: Container(
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorConstant.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: ColorConstant.borderBlueGrey),
                  ),
                  child: key == "⌫"
                      ? const Icon(
                          Icons.backspace_outlined,
                          size: 20,
                          color: ColorConstant.textDarkGreyColor,
                        )
                      : Text(
                          key,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: ColorConstant.textDarkGreyColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
