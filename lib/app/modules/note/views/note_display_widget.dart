import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/modules/exam_active/controllers/exam_active_controller.dart';
import '../../../common/common_card_widget.dart';
import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/utils/math_semantic_serializer.dart';
import '../../../data/models/math_document.dart';
import '../../../data/models/math_symbol.dart';
import '../controllers/note_controller.dart';
import 'math_keyboard_widget.dart';

class NoteDisplayWidget extends StatelessWidget {
  NoteDisplayWidget({super.key});
  final MathSemanticSerializer _semanticSerializer = MathSemanticSerializer();


  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();
    final theme = Theme.of(context);

    return Obx(() {
      final nodes = controller.noteNodes;
      final cursor = controller.cursorIndex.value;
      final isInputActive = controller.isInputActive.value;

      return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildQuestionCard(
                context,
                controller.question,
                controller.readAloud,
              ),
              const SizedBox(height: Dimens.spaceBigPadding),
              Semantics(
                header: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
                  child: Text(
                    'Langkah Pengerjaan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: ColorConstant.textDarkGreyColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              for (int i = 0; i < controller.steps.length; i++)
                _buildStepItem(
                  context,
                  controller,
                  controller.steps[i],
                  i,
                ),
              _buildInputBox(
                context,
                controller,
                nodes,
                cursor,
              ),
              if (isInputActive) ...[
                const SizedBox(height: Dimens.spaceMediumPadding),
                const MathKeyboardWidget(),
              ],
            ],
          ),
        ),
      );
    });
  }

  Widget _buildQuestionCard(BuildContext context,ExamQuestionModel? question, void Function() readAloud) {
    return CommonCardWidget(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.innerPadding),
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
              label: question?.questionText ?? "",
              child: ExcludeSemantics(
                child: Text(
                  question?.questionText ?? "",
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
                  onTap: readAloud,
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
      ),
    );
  }

  Widget _buildStepItem(BuildContext context, NoteController controller, MathDocument step, int index,) {
    final theme = Theme.of(context);
    final semantic = _semanticSerializer.serializeNodes(step.nodes);

    return Padding(
      padding: const EdgeInsets.only(
        left: Dimens.innerPadding,
        right: Dimens.innerPadding,
        bottom: Dimens.spacePadding,
      ),
      child: Semantics(
        container: true,
        label: 'Langkah ${index + 1}, $semantic',
        button: true,
        selected: controller.selectedStepIndex.value == index,
        onTap: () => controller.selectStep(index),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Dimens.innerBigPadding,
            horizontal: Dimens.innerMediumPadding,
          ),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.circular(Dimens.radius),
            border: Border.all(
              color: controller.selectedStepIndex.value == index
                  ? ColorConstant.primary
                  : ColorConstant.borderBlueGrey,
            ),
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
                    '${index + 1}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: Dimens.spaceBigPadding),
              Expanded(
                child: ExcludeSemantics(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final node in step.nodes)
                          _buildNodeWidget(context, node, controller),
                      ],
                    ),
                  ),
                ),
              ),
              Semantics(
                button: true,
                label: 'Hapus langkah ${index + 1}',
                onTap: () => controller.deleteStep(index),
                child: ExcludeSemantics(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.deleteStep(index),
                    child: Container(
                      padding: const EdgeInsets.all(
                        Dimens.innerSmallPadding,
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(BuildContext context, NoteController controller, List<MathNode> nodes, int cursor,) {
    final theme = Theme.of(context);
    final hasInput = nodes.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.innerPadding,
      ),
      child: Semantics(
        container: true,
        explicitChildNodes: true,
        label: hasInput
            ? 'Input langkah baru, ${controller.combinedSemanticText}'
            : 'Input langkah baru, kosong',
        onTap: controller.activateInput,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ExcludeSemantics(
                  child: Icon(
                    Icons.add,
                    color: ColorConstant.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: Dimens.spaceMediumPadding,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (int i = 0; i < nodes.length; i++) ...[
                          if (i == cursor &&
                              controller.activeSlot.value == null &&
                              controller.isInputActive.value)
                            _buildCursor(theme),
                          _buildNodeWidget(
                            context,
                            nodes[i],
                            controller,
                          ),
                        ],
                        if (cursor == nodes.length &&
                            controller.activeSlot.value == null &&
                            controller.isInputActive.value)
                          _buildCursor(theme),
                        if (!hasInput)
                          Text(
                            'Ketuk untuk input langkah baru...',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: ColorConstant.textGreyColor,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCursor(ThemeData theme) {
    return Container(
      width: 2,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      color: theme.colorScheme.primary,
    );
  }

  Widget _buildNodeWidget(BuildContext context, MathNode node, NoteController controller,) {
    switch (node.symbol.type) {
      case MathSymbolType.root:
        return _buildRoot(context, node, controller);
      case MathSymbolType.power:
        return _buildPower(context, node, controller);
      case MathSymbolType.fraction:
        return _buildFraction(context, node, controller);
      case MathSymbolType.subscript:
        return _buildSubscript(context, node, controller);
      case MathSymbolType.parens:
        return _buildParentheses(context, node, controller);
      case MathSymbolType.function:
        return _buildFunction(context, node, controller);
      case MathSymbolType.integral:
        return _buildIntegral(context, node, controller);
      case MathSymbolType.derivative:
        return _buildDerivative(context, node, controller);
      case MathSymbolType.limit:
        return _buildLimit(context, node, controller);
      case MathSymbolType.summation:
        return _buildSummation(context, node, controller);
      case MathSymbolType.text:
      case MathSymbolType.number:
      case MathSymbolType.operator:
        return _buildTextNode(context, node);
    }
  }

  Widget _buildTextNode(BuildContext context, MathNode node) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Text(
        node.symbol.renderSyntax,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildRoot(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length == 1) {
      return _buildSquareRoot(context, node.slots[0], controller,);
    }

    if (node.slots.length >= 2) {
      return _buildIndexedRoot(context, node.slots[0], node.slots[1], controller,);
    }

    return Text(
      '√',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildSquareRoot(BuildContext context, MathSlot contentSlot, NoteController controller,) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('√', style: theme.textTheme.headlineMedium,),
          _buildRadicand(context, contentSlot, controller,),
        ],
      ),
    );
  }

  Widget _buildIndexedRoot(BuildContext context, MathSlot indexSlot, MathSlot contentSlot, NoteController controller,) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 1,
              bottom: 17,
            ),
            child: Transform.scale(
              scale: 0.72,
              alignment: Alignment.bottomRight,
              child: _buildSlotContainer(context, indexSlot, controller,),
            ),
          ),
          Text('√', style: theme.textTheme.headlineMedium,),
          _buildRadicand(context, contentSlot, controller,),
        ],
      ),
    );
  }

  Widget _buildRadicand(BuildContext context, MathSlot slot, NoteController controller,) {
    return Container(
      constraints: const BoxConstraints(minWidth: 22),
      padding: const EdgeInsets.only(
        top: Dimens.innerSmallPadding,
        left: Dimens.innerSmallPadding,
        right: Dimens.innerSmallPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.5,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      child: _buildSlotContainer(context, slot, controller,),
    );
  }

  Widget _buildPower(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length < 2) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSlotContainer(context, node.slots[0], controller,),
        Transform.translate(
          offset: const Offset(0, -10),
          child: Transform.scale(
            scale: 0.72,
            alignment: Alignment.bottomLeft,
            child: _buildSlotContainer(context, node.slots[1], controller,),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscript(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length < 2) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildSlotContainer(context, node.slots[0], controller,),
        Transform.translate(
          offset: const Offset(0, 7),
          child: Transform.scale(
            scale: 0.72,
            alignment: Alignment.topLeft,
            child: _buildSlotContainer(context, node.slots[1], controller,),
          ),
        ),
      ],
    );
  }

  Widget _buildFraction(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length < 2) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerSmallPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSlotContainer(context, node.slots[0], controller,),
          Container(
            height: 2,
            constraints: const BoxConstraints(minWidth: 32),
            margin: const EdgeInsets.symmetric(vertical: Dimens.innerSmallPadding),
            color: Theme.of(context).colorScheme.onSurface,
          ),
          _buildSlotContainer(context, node.slots[1], controller,),
        ],
      ),
    );
  }

  Widget _buildParentheses(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.isEmpty) {
      return Text('()', style: Theme.of(context).textTheme.titleLarge,);
    }

    final style = Theme.of(context).textTheme.headlineSmall;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('(', style: style),
        _buildSlotContainer(context, node.slots[0], controller,),
        Text(')', style: style),
      ],
    );
  }

  Widget _buildFunction(BuildContext context, MathNode node, NoteController controller,) {
    final style = Theme.of(context).textTheme.titleLarge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_functionVisualName(node.symbol.id), style: style,),
        for (final slot in node.slots)
          _buildSlotContainer(context, slot, controller,),
      ],
    );
  }

  String _functionVisualName(String id) {
    switch (id) {
      case 'sin':
        return 'sin';
      case 'cos':
        return 'cos';
      case 'tan':
        return 'tan';
      case 'cot':
        return 'cot';
      case 'sec':
        return 'sec';
      case 'csc':
        return 'csc';
      case 'arcsin':
        return 'arcsin';
      case 'arccos':
        return 'arccos';
      case 'arctan':
        return 'arctan';
      case 'arccot':
        return 'arccot';
      case 'arcsec':
        return 'arcsec';
      case 'arccsc':
        return 'arccsc';
      case 'sinh':
        return 'sinh';
      case 'cosh':
        return 'cosh';
      case 'tanh':
        return 'tanh';
      case 'coth':
        return 'coth';
      case 'ln':
        return 'ln';
      case 'log':
      case 'log10':
        return 'log';
      case 'exp':
        return 'exp';
      case 'sign':
        return 'sgn';
      default:
        return id;
    }
  }

  Widget _buildIntegral(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length == 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('∫', style: Theme.of(context).textTheme.headlineMedium,),
          _buildSlotContainer(context, node.slots[0], controller,),
        ],
      );
    }

    if (node.slots.length >= 3) {
      return _buildDefiniteIntegral(context, node.slots[0], node.slots[1], node.slots[2], controller,);
    }

    return Text('∫', style: Theme.of(context).textTheme.headlineMedium,);
  }

  Widget _buildDefiniteIntegral(BuildContext context, MathSlot lowerSlot, MathSlot upperSlot, MathSlot integrandSlot, NoteController controller,) {
    final style = Theme.of(context).textTheme.headlineMedium;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36,
          height: 58,
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 8,
                child: Text('∫', style: style),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Transform.scale(
                  scale: 0.65,
                  child: _buildSlotContainer(context, upperSlot, controller,),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Transform.scale(
                  scale: 0.65,
                  child: _buildSlotContainer(context, lowerSlot, controller),
                ),
              ),
            ],
          ),
        ),
        _buildSlotContainer(context, integrandSlot, controller,),
      ],
    );
  }

  Widget _buildDerivative(BuildContext context, MathNode node, NoteController controller,) {
    String symbol;

    switch (node.symbol.id) {
      case 'ddx':
        symbol = 'd/dx';
        break;
      case 'dydx':
        symbol = 'dy/dx';
        break;
      case 'd2_dx2':
        symbol = 'd²/dx²';
        break;
      case 'y_prime':
        symbol = 'y′';
        break;
      case 'y_double_prime':
        symbol = 'y″';
        break;
      default:
        symbol = node.symbol.renderSyntax;
    }

    final style = Theme.of(context).textTheme.titleLarge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(symbol, style: style),
        for (final slot in node.slots)
          _buildSlotContainer(context, slot, controller,),
      ],
    );
  }

  Widget _buildLimit(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length < 3) {
      return Text(node.symbol.renderSyntax, style: Theme.of(context).textTheme.titleLarge,);
    }

    final style = Theme.of(context).textTheme.titleLarge;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('lim', style: style),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSlotContainer(context, node.slots[0], controller,),
                Text('→', style: Theme.of(context).textTheme.bodyMedium,),
                _buildSlotContainer(context, node.slots[1], controller,),
              ],
            ),
          ],
        ),
        const SizedBox(width: 5),
        _buildSlotContainer(context, node.slots[2], controller),
      ],
    );
  }

  Widget _buildSummation(BuildContext context, MathNode node, NoteController controller,) {
    if (node.slots.length < 4) {
      return Text('∑', style: Theme.of(context).textTheme.headlineMedium,);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 42,
          height: 58,
          child: Stack(
            children: [
              Center(
                child: Text('∑', style: Theme.of(context).textTheme.headlineMedium,),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Transform.scale(
                    scale: 0.62,
                    child: _buildSlotContainer(context, node.slots[2], controller,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Transform.scale(
                  scale: 0.62,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSlotContainer(context, node.slots[0], controller,),
                      Text('=', style: Theme.of(context).textTheme.bodySmall,),
                      _buildSlotContainer(context, node.slots[1], controller,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildSlotContainer(context, node.slots[3], controller,),
      ],
    );
  }

  Widget _buildSlotContainer(BuildContext context, MathSlot slot, NoteController controller,) {
    return Obx(() {
      final isSelected = controller.activeSlot.value == slot;
      final isEmpty = slot.children.isEmpty;
      final content = _semanticSerializer.serializeNodes(slot.children);

      final label = isEmpty
          ? '${slot.label}, kosong'
          : '${slot.label}, $content';

      void selectAndAnnounce() {
        controller.selectSlot(slot);

        SemanticsService.announce(
          '${slot.label}, dipilih',
          Directionality.of(context),
        );
      }

      return Semantics(
        container: true,
        explicitChildNodes: true,
        label: label,
        button: true,
        selected: isSelected,
        onTap: selectAndAnnounce,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          excludeFromSemantics: true,
          onTap: selectAndAnnounce,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            padding: const EdgeInsets.all(Dimens.innerSmallPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: isSelected
                  ? Border.all(
                color: Theme.of(context).colorScheme.primary,
              )
                  : null,
            ),
            child: isEmpty
                ? _buildEmptySlot(context, isSelected)
                : Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < slot.children.length; i++) ...[
                  if (i == slot.cursorIndex.value && isSelected)
                    _buildCursor(Theme.of(context)),
                  _buildNodeWidget(
                    context,
                    slot.children[i],
                    controller,
                  ),
                ],
                if (slot.cursorIndex.value == slot.children.length &&
                    isSelected)
                  _buildCursor(Theme.of(context)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildEmptySlot(BuildContext context, bool isSelected,) {
    final colorScheme = Theme.of(context).colorScheme;

    return DottedBorder(
      options: RectDottedBorderOptions(
        color: isSelected
            ? colorScheme.primary
            : colorScheme.outline,
        strokeWidth: isSelected ? 2 : 1,
        dashPattern: const [3, 3],
        padding: const EdgeInsets.all(4),
      ),
      child: SizedBox(
        width: 18,
        height: 22,
        child: isSelected
            ? Center(child: _buildCursor(Theme.of(context),),
        ) : null,
      ),
    );
  }
}