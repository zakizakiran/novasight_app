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
    // ignore: deprecated_member_use
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
            label: controller.getMathSemanticText(
              controller.question?.questionText ?? "",
            ),
            child: ExcludeSemantics(
              child: Text(
                controller.question?.questionText ?? "",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: ColorConstant.textDarkGreyColor,
                ),
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
                  child: ExcludeSemantics(
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, int index, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.spacePadding),
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
            ExcludeSemantics(
              child: Container(
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
            ),
            const SizedBox(width: Dimens.spaceBigPadding),
            Expanded(
              child: Semantics(
                label:
                    "Langkah ${index + 1}, ${controller.getMathSemanticText(text)}",
                child: ExcludeSemantics(
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: ColorConstant.textDarkGreyColor,
                    ),
                  ),
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
    );
  }

  Widget _buildInputBox(BuildContext context) {
    return Semantics(
      button: true,
      label: controller.activeInputText.value.isEmpty
          ? "Ketuk untuk input langkah baru"
          : "Input saat ini: ${controller.getMathSemanticText(controller.activeInputText.value)}. Ketuk untuk mengedit.",
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
              const ExcludeSemantics(
                child: Icon(Icons.add, color: ColorConstant.primary, size: 20),
              ),
              const SizedBox(width: Dimens.spaceMediumPadding),
              Expanded(
                child: ExcludeSemantics(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMathKeyboard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConstant.white,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.shadowColor,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grid
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            color: ColorConstant.background,
            child: Obx(
              () => Column(
                children: [
                  _buildKeyboardRow(context, [
                    "1",
                    "2",
                    "3",
                    "4",
                    "5",
                    "6",
                    "7",
                    "8",
                    "9",
                    "0",
                  ]),
                  const SizedBox(height: 8),
                  _buildKeyboardRow(
                    context,
                    controller.keyboardCategories[controller
                            .currentCategoryIndex
                            .value]["keys"]
                        as List<String>,
                  ),
                  const SizedBox(height: 8),
                  _buildKeyboardRow(context, [".", ",", "Swap", "⌫"]),
                ],
              ),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((key) {
        String semanticLabel = key;
        switch (key) {
          case '+':
            semanticLabel = 'tambah';
            break;
          case '-':
            semanticLabel = 'kurang';
            break;
          case '×':
            semanticLabel = 'kali';
            break;
          case '÷':
            semanticLabel = 'bagi';
            break;
          case '=':
            semanticLabel = 'sama dengan';
            break;
          case '(':
            semanticLabel = 'kurung buka';
            break;
          case ')':
            semanticLabel = 'kurung tutup';
            break;
          case 'log':
            semanticLabel = 'logaritma';
            break;
          case '√':
            semanticLabel = 'akar';
            break;
          case '^':
            semanticLabel = 'pangkat';
            break;
          case '.':
            semanticLabel = 'titik';
            break;
          case ',':
            semanticLabel = 'koma';
            break;
          case '%':
            semanticLabel = 'persen';
            break;
          case '!':
            semanticLabel = 'faktorial';
            break;
          case '<':
            semanticLabel = 'lebih kecil';
            break;
          case '>':
            semanticLabel = 'lebih besar';
            break;
          case '?':
            semanticLabel = 'tanda tanya';
            break;
          case '⌫':
            semanticLabel = 'hapus';
            break;
          case 'Swap':
            semanticLabel = 'Swap Kategori';
            break;
          case '≤':
            semanticLabel = 'kurang dari sama dengan';
            break;
          case '≥':
            semanticLabel = 'lebih dari sama dengan';
            break;
          case '≠':
            semanticLabel = 'tidak sama dengan';
            break;
          case 'x':
            semanticLabel = 'huruf ex';
            break;
          case 'y':
            semanticLabel = 'huruf ye';
            break;
          case 'z':
            semanticLabel = 'huruf zed';
            break;
          case 'a':
            semanticLabel = 'huruf a';
            break;
          case 'b':
            semanticLabel = 'huruf be';
            break;
        }

        return Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Semantics(
              label: semanticLabel,
              button: key == "Swap" || key == "⌫",
              child: ExcludeSemantics(
                child: GestureDetector(
                  onTap: () {
                    if (key == "⌫") {
                      controller.removeLastCharacter();
                    } else if (key == "Swap") {
                      controller.swapKeyboardCategory();
                    } else {
                      controller.addTextToInput(key);
                    }
                  },
                  child: Container(
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: key == "⌫"
                          ? ColorConstant.lightRedColor
                          : ColorConstant.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ColorConstant.borderBlueGrey),
                    ),
                    child: key == "⌫"
                        ? const Icon(
                            Icons.backspace_outlined,
                            size: 20,
                            color: ColorConstant.redColor,
                          )
                        : key == "Swap"
                        ? const Icon(
                            Icons.swap_horiz,
                            size: 20,
                            color: ColorConstant.primary,
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
          ),
        );
      }).toList(),
    );
  }
}
