import '../../../../core/utils/announce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/modules/subject/controllers/subject_controller.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/utils/l10n_extension.dart';

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
          _buildHeader(context, subjectController, sizeIcon),
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
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.25),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    selectionHandleColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Obx(() {
                  final isReader =
                      subjectController.noteMode.value == NoteMode.reader;

                  if (!subjectController.isNoteLoaded.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final editor = QuillEditor.basic(
                    key: ValueKey(isReader),
                    controller: subjectController.noteController,
                    config: QuillEditorConfig(
                      autoFocus: false,
                      enableInteractiveSelection: true,
                      showCursor: !isReader,
                      checkBoxReadOnly: isReader,
                      placeholder: context.l10n.hintRecordNote,
                      padding: const EdgeInsets.all(Dimens.spacePadding),
                      expands: true,
                      onTapUp: (details, getPosition) {
                        if (isReader) return false;
                        if (!MediaQuery.of(context).accessibleNavigation) return false;

                        final ctrl = subjectController.noteController;
                        final tapped = getPosition(details.globalPosition).offset;

                        final text = ctrl.document.toPlainText();
                        var end = text.indexOf('\n', tapped);
                        if (end == -1) end = ctrl.document.length - 1;

                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ctrl.updateSelection(
                            TextSelection.collapsed(offset: end),
                            ChangeSource.local,
                          );
                        });
                        return false;
                      },

                      customStyles: DefaultStyles(
                        placeHolder: DefaultTextBlockStyle(
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.grey,
                          ),
                          const HorizontalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          const VerticalSpacing(0, 0),
                          const BoxDecoration(),
                        ),
                      ),
                    ),
                  );

                  return isReader
                      ? editor
                      : _accessibleEditor(subjectController, editor);
                }),
              ),
            ),
          ),

          Obx(() => subjectController.noteMode.value == NoteMode.editor
              ? _buildBottomSection(context, subjectController)
              : const SizedBox.shrink()),
          const SizedBox(height: Dimens.innerPadding),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SubjectController subjectController, double sizeIcon,) {
    return Container(
      padding: const EdgeInsets.all(Dimens.innerPadding),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            button: true,
            label: 'Kembali',
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(Icons.arrow_back, size: sizeIcon),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.recordNote,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.innerPadding,
            children: [
              Obx(() {
                final isReader =
                    subjectController.noteMode.value == NoteMode.reader;
                return Semantics(
                  button: true,
                  label: isReader ? 'Ubah ke mode edit' : 'Ubah ke mode baca',
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => subjectController.changeNoteMode(
                      isReader ? NoteMode.editor : NoteMode.reader,
                    ),
                    child: Icon(
                      isReader ? Icons.edit : Icons.visibility,
                      size: sizeIcon,
                    ),
                  ),
                );
              }),
              Obx(() {
                final isSameContent = subjectController.isSameContent.value;
                final isLoaded = subjectController.isNoteLoaded.value;
                final color = isLoaded
                    ? (isSameContent ? Colors.grey : Colors.black)
                    : Colors.grey;
                return Semantics(
                  button: true,
                  label: context.l10n.recordNote,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!isSameContent) {
                        subjectController.onSaveNote(
                          '${context.l10n.chapter} ${subjectController.subject.id} ${context.l10n.recordNote}',
                        );
                      }
                    },
                    child: Icon(Icons.check_rounded, size: sizeIcon, color: color),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _accessibleEditor(SubjectController c, Widget editor) {
    final ctrl = c.noteController;

    void move(int delta, bool extend) {
      final sel = ctrl.selection;
      final max = ctrl.document.length - 1;
      final base = sel.isValid ? sel.baseOffset : 0;
      final extent = sel.isValid ? sel.extentOffset : 0;
      final newExtent = (extent + delta).clamp(0, max);
      ctrl.updateSelection(
        extend
            ? TextSelection(baseOffset: base, extentOffset: newExtent)
            : TextSelection.collapsed(offset: newExtent),
        ChangeSource.local,
      );
      final text = ctrl.document.toPlainText();
      final from = delta > 0 ? extent : newExtent;
      final to = delta > 0 ? newExtent : extent;
      if (from >= 0 && to <= text.length && from < to) {
        final ch = text.substring(from, to);
        announceSemantics(
          ch.trim().isEmpty ? 'spasi' : ch,
          TextDirection.ltr,
        );
      }
    }

    return ListenableBuilder(
      listenable: ctrl,
      builder: (context, child) {
        return Semantics(
          textField: true,
          multiline: true,
          value: ctrl.document.toPlainText(),
          onSetSelection: (selection) {
            ctrl.updateSelection(selection, ChangeSource.local);
          },
          onMoveCursorForwardByCharacter: (extend) => move(1, extend),
          onMoveCursorBackwardByCharacter: (extend) => move(-1, extend),
          child: child,
        );
      },
      child: editor,
    );
  }

  Widget _buildBottomSection(BuildContext context, SubjectController subjectController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      padding: const EdgeInsets.symmetric(vertical: Dimens.spaceMediumPadding),
      decoration: const BoxDecoration(
        color: ColorConstant.grey,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius)),
      ),
      child: Obx(() {
        final selectedAlignment = subjectController.selectedAlignment.value;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            spacing: Dimens.spaceMediumPadding,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconWord(WordTyping.bold, context, subjectController.onChangeTextMode,
                  label: context.l10n.boldText, isSelected: subjectController.isBold.value),
              _buildIconWord(WordTyping.italic, context, subjectController.onChangeTextMode,
                  label: context.l10n.italicText, isSelected: subjectController.isItalic.value),
              _buildIconWord(WordTyping.underline, context, subjectController.onChangeTextMode,
                  label: context.l10n.underlineText, isSelected: subjectController.isUnderline.value),
              _buildIconWord(WordTyping.strikethrough, context, subjectController.onChangeTextMode,
                  label: context.l10n.strikethroughText, isSelected: subjectController.isStrikethrough.value),
              SizedBox(
                height: 24,
                child: VerticalDivider(
                  color: Theme.of(context).dividerColor,
                  thickness: 1,
                  width: 8,
                ),
              ),
              _buildIconAlign(AlignParagraft.left, context, subjectController.onChangeAlignment,
                  label: context.l10n.alignLeft, selectedAlignment: selectedAlignment),
              _buildIconAlign(AlignParagraft.center, context, subjectController.onChangeAlignment,
                  label: context.l10n.alignCenter, selectedAlignment: selectedAlignment),
              _buildIconAlign(AlignParagraft.right, context, subjectController.onChangeAlignment,
                  label: context.l10n.alignRight, selectedAlignment: selectedAlignment),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildIconWord(WordTyping word, BuildContext context, Function(WordTyping) onClick, {required String label, bool isSelected = false,}) {
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => onClick(word),
        child: _buildIcon(context, word.icon, label: label, isSelected: isSelected),
      ),
    );
  }

  Widget _buildIconAlign(AlignParagraft align, BuildContext context, Function(AlignParagraft) onClick, {required String label, AlignParagraft selectedAlignment = AlignParagraft.left,}) {
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

  Widget _buildIcon(BuildContext context, IconData icon, {required String label, bool isSelected = false,}) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spaceMediumPadding),
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
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