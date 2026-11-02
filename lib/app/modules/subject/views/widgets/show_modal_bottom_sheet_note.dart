import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/modules/subject/controllers/subject_controller.dart';
import '../../../../common/common_text_form_field_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/l10n_extension.dart';
import '../../../../core/utils/validate_helper.dart';

class ShowModalBottomSheetNote extends StatelessWidget {
  const ShowModalBottomSheetNote({super.key});

  @override
  Widget build(BuildContext context) {
    final subjectController = Get.find<SubjectController>();
    final screenHeight = MediaQuery.of(context).size.height * 0.9;

    const double sizeIcon = Dimens.iconMidSize;

    return SizedBox(
      width: double.infinity,
      height: screenHeight,
      child: Column(
        spacing: Dimens.spacePadding,
        children: [
          const SizedBox(height: Dimens.innerPadding),
          Container(
            padding: const EdgeInsets.all(Dimens.innerPadding),
            color: Theme.of(context).colorScheme.surfaceContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.arrow_back, size: sizeIcon),
                Text(
                  context.l10n.recordNote,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                GestureDetector(
                  onTap: subjectController.onSaveNote,
                  child: const Icon(Icons.check_rounded, size: sizeIcon),
                ),
              ],
            ),
          ),
          // buat pass horizontal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.spacePadding,
                vertical: Dimens.spaceBigPadding,
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: Theme.of(context)
                        .colorScheme.primary
                        .withValues(alpha: 0.25),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    selectionHandleColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: QuillEditor.basic(
                  controller: subjectController.noteController,
                  config: QuillEditorConfig(
                    placeholder: context.l10n.hintRecordNote,
                    padding: const EdgeInsets.all(Dimens.spacePadding),
                    expands: true,
                  ),
                ),
              )
            ),
          ),
          _buildBottomSection(context, subjectController),
          const SizedBox(height: Dimens.innerPadding),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, SubjectController subjectController){
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      padding: const EdgeInsets.symmetric(vertical: Dimens.spaceMediumPadding),
      decoration: const BoxDecoration(
        color: ColorConstant.grey,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius))
      ),
      child: Obx(() {
        final selectedAlignment = subjectController.selectedAlignment.value;
        return Row(
          spacing: Dimens.spaceMediumPadding,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconWord(WordTyping.bold, context, subjectController.onChangeMode, label: context.l10n.boldText, isSelected: subjectController.isBold.value),
            _buildIconWord(WordTyping.italic, context, subjectController.onChangeMode, label: context.l10n.italicText, isSelected: subjectController.isItalic.value),
            _buildIconWord(WordTyping.underline, context, subjectController.onChangeMode, label: context.l10n.underlineText, isSelected: subjectController.isUnderline.value),
            _buildIconWord(WordTyping.strikethrough, context, subjectController.onChangeMode, label: context.l10n.strikethroughText, isSelected: subjectController.isStrikethrough.value),
            SizedBox(
              height: 24,
              child: VerticalDivider(
                color: Theme.of(context).dividerColor,
                thickness: 1,
                width: 8,
              ),
            ),
            _buildIconAlign(AlignParagraft.left, context, subjectController.onChangeAlignment, label: context.l10n.alignLeft, selectedAlignment: selectedAlignment),
            _buildIconAlign(AlignParagraft.center, context, subjectController.onChangeAlignment, label: context.l10n.alignCenter, selectedAlignment: selectedAlignment),
            _buildIconAlign(AlignParagraft.right, context, subjectController.onChangeAlignment, label: context.l10n.alignRight, selectedAlignment: selectedAlignment),
          ],
        );
      }
      ),
    );
  }

  Widget _buildIconWord(WordTyping word, BuildContext context, Function(WordTyping) onClick, {required String label,  bool isSelected = false}) {
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child:  GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onClick(word),
        child: _buildIcon(context, word.icon, label: label, isSelected: isSelected,),
      ),
    );
  }

  Widget _buildIconAlign(AlignParagraft align, BuildContext context, Function(AlignParagraft) onClick, {required String label,  AlignParagraft selectedAlignment = AlignParagraft.left}) {
    final isSelected = selectedAlignment == align;
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onClick(align),
        child: _buildIcon(context, align.icon, label: label, isSelected: isSelected),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, IconData icon,{required String label, bool isSelected = false}){
    return Container(padding: const EdgeInsets.all(Dimens.spaceMediumPadding),
    decoration: BoxDecoration(
    color: isSelected
    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15) // Light background tint
        : Colors.transparent,
    shape: BoxShape.circle,
    ),
      child: Icon(
        icon,
        size: Dimens.iconMidSize,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
