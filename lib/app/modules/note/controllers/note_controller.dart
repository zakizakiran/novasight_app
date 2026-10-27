import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/data/repositories/note_repository.dart';
import 'package:lydera_app/app/modules/exam_active/controllers/exam_active_controller.dart';

import '../../../core/utils/math_semantic_serializer.dart';
import '../../../data/models/math_document.dart';
import '../../../core/utils/math_latex_parser.dart';
import '../../../core/utils/math_latex_serializer.dart';
import '../../../data/models/math_symbol.dart';
import '../../../data/models/student_quiz_model.dart';

class NoteController extends GetxController {
  ExamQuestionModel? question;
  final RxList<MathDocument> steps = <MathDocument>[].obs;
  final RxList<MathNode> noteNodes = <MathNode>[].obs;
  final RxInt cursorIndex = 0.obs;
  final RxInt selectedStepIndex = (-1).obs;

  late final int total;
  late final int index;
  final Rxn<MathSlot> activeSlot = Rxn<MathSlot>();
  final ScrollController scrollController = ScrollController();
  final RxInt activeCategoryTab = 0.obs;
  final isInputActive = false.obs;
  final RxBool isAbcMode = false.obs;
  final MathLatexSerializer _latexSerializer = MathLatexSerializer();
  final MathSemanticSerializer _semanticSerializer = MathSemanticSerializer();
  final MathLatexParser _parser = MathLatexParser();

  final NoteRepository noteRepository;
  final ExamActiveController examActiveController;

  NoteController({
    required this.noteRepository,
    required this.examActiveController,
  });

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    index = args is Map ? args['index'] ?? 1 : 1;
    total = args is Map ? args['total'] ?? 1 : 1;

    if (args is Map) {
      question = examActiveController.questions[index];
      question?.steps.forEach((step) {
        print('Step text: ${step.text}');

        final nodes = _parser.parse(step.text);
        printNodes(nodes);
      });
      steps.assignAll(question?.steps.map((step) => MathDocument.fromStudentStep(step, _parser)).toList() ?? []);
    }
    print("Test mas\n");
    // final testExpressions = [
    //   r'\lim_{x\to5} 5',
    //   r'x^2',
    //   r'x_2',
    //   r'\frac{3}{7}',
    //   r'\sqrt{x}',
    //   r'\sqrt[3]{x}',
    //   r'\sin(x)',
    //   r'\log_{2}(x)',
    // ];
    //
    // for (final expression in testExpressions) {
    //   print('\nExpression: $expression');
    //
    //   final nodes = _parser.parse(expression);
    //   printNodes(nodes);
    // }
  }

  void printNodes(List<MathNode> nodes, {int depth = 0}) {
    final indent = '  ' * depth;

    for (final node in nodes) {
      final symbol = node.symbol;
      print('${indent}Node ID: ${symbol.id}');
      print('${indent}Visual Label: ${symbol.visualLabel}');
      print('${indent}LaTeX: ${symbol.renderSyntax}');
      print('${indent}Semantic: ${symbol.semanticText}');
      print('${indent}Type: ${symbol.type}');

      for (final slot in node.slots) {
        print('${indent}  Slot: ${slot.label}');

        printNodes(
          slot.children.toList(),
          depth: depth + 2,
        );
      }

      print('${indent}--------------------');
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void selectSlot(MathSlot slot, {int? position}) {
    selectedStepIndex.value = -1;
    isInputActive.value = true;
    activeSlot.value = slot;

    if (position != null) {
      slot.cursorIndex.value = position;
    } else {
      slot.cursorIndex.value = slot.cursorIndex.value
          .clamp(0, slot.children.length);
    }
  }

  void selectStep(int index) {
    if (index < 0 || index >= steps.length) return;

    selectedStepIndex.value = index;
    isInputActive.value = false;
    activeSlot.value = null;
  }

  void activateInput() {
    selectedStepIndex.value = -1;
    activeSlot.value = null;
    cursorIndex.value = noteNodes.length;
    isInputActive.value = true;

    scrollToBottom();
  }

  void deactivateInput() {
    isInputActive.value = false;
  }

  Future<void> saveStep() async {
    if (noteNodes.isEmpty) return;
    print('Note : ${_latexSerializer.serializeNodes(noteNodes)}',);
    final step = await noteRepository.submitStepAnswer(
      soalId: int.tryParse(question?.id.toString() ?? '') ?? 0,
      request: SoalStepRequest(step: _latexSerializer.serializeNodes(noteNodes)),
    );
    final nodes = noteNodes.map((node) => node.copy()).toList();
    steps.add(
      MathDocument(
        nodes: nodes,
      ),
    );
    noteNodes.clear();
    cursorIndex.value = 0;
    activeSlot.value = null;
    examActiveController.addStep(step, index);
    scrollToBottom();
  }

  Future<void> deleteStep(int index) async {
    SemanticsService.announce(
      'Hapus langkah',
      TextDirection.ltr,
    );
    if (index < 0 || index >= steps.length) return;
    final step = question?.steps[index];
    await noteRepository.deleteStepAnswer(
      stepId: int.tryParse(step?.id.toString() ?? '') ?? 0,
    );
    steps.removeAt(index);
    examActiveController.removeStep(step?.id ?? 0, index);
    if (selectedStepIndex.value == index) {
      selectedStepIndex.value = -1;
    } else if (selectedStepIndex.value > index) {
      selectedStepIndex.value--;
    }
  }

  void clearSlotSelection() {
    activeSlot.value = null;
  }

  void insertSymbol(MathSymbol symbol) {
    SemanticsService.announce(
      '${symbol.semanticText} Dipencet',
      TextDirection.ltr,
    );
    final newNode = MathNode(symbol: symbol);
    final slot = activeSlot.value;

    if (slot != null) {
      newNode.parentSlot = slot;
      slot.children.insert(slot.cursorIndex.value, newNode,);
      slot.cursorIndex.value++;

    } else {
      newNode.parentSlot = null;
      noteNodes.insert(cursorIndex.value, newNode,);
      cursorIndex.value++;
    }

    // Auto-focus the first slot if the inserted node, has fillable boxes.
    if (newNode.slots.isNotEmpty) {
      selectSlot(newNode.slots.first, position: 0,);
    }
    noteNodes.refresh();
  }

  void insertCharacter(String char) {
    insertSymbol(
      MathSymbol(
        id: 'char_$char',
        visualLabel: char,
        renderSyntax: char,
        semanticText: char,
        type: MathSymbolType.text,
      ),
    );
  }

  void deletePrevious() {
    SemanticsService.announce(
      'Karakter dihapus',
      TextDirection.ltr,
    );
    final slot = activeSlot.value;
    if (slot != null) {
      if (slot.cursorIndex.value > 0 && slot.children.isNotEmpty) {
        slot.children.removeAt(slot.cursorIndex.value - 1,);
        slot.cursorIndex.value--;
      } else {
        // At start of slot: step cursor out to the left.
        moveCursorLeft();
      }
    } else if (cursorIndex.value > 0 &&
        noteNodes.isNotEmpty) {
      noteNodes.removeAt(cursorIndex.value - 1);
      cursorIndex.value--;
    }
    noteNodes.refresh();
  }

  /// Right arrow navigation through the math tree.
  void moveCursorRight() {
    SemanticsService.announce(
      'Kursor dipindahkan ke kanan',
      TextDirection.ltr,
    );
    final slot = activeSlot.value;
    if (slot != null) {
      if (slot.cursorIndex.value < slot.children.length) {
        final rightNode = slot.children[slot.cursorIndex.value];

        if (rightNode.slots.isNotEmpty) {
          selectSlot(rightNode.slots.first, position: 0,);
        } else {
          slot.cursorIndex.value++;
        }
      } else {
        // At the end of the current slot.
        final parentNode = slot.parentNode;

        if (parentNode != null) {
          final currentSlotIdx = parentNode.slots.indexOf(slot);

          if (currentSlotIdx < parentNode.slots.length - 1) {
            final nextSlot = parentNode.slots[currentSlotIdx + 1];
            selectSlot(nextSlot, position: 0,);
          } else {
            // Reached last slot:
            // step out of parentNode to the right.
            _stepOutOfNodeRight(parentNode);
          }
        }
      }
    } else {
      // At root level.
      if (cursorIndex.value < noteNodes.length) {
        final rightNode = noteNodes[cursorIndex.value];

        if (rightNode.slots.isNotEmpty) {
          // Enter first slot of right node.
          selectSlot(
            rightNode.slots.first,
            position: 0,
          );
        } else {
          // Plain character: advance cursor.
          cursorIndex.value++;
        }
      }
    }

    noteNodes.refresh();
  }

  /// Left arrow navigation through the math tree.
  void moveCursorLeft() {
    SemanticsService.announce(
      'Kursor dipindahkan ke kiri',
      TextDirection.ltr,
    );
    final slot = activeSlot.value;

    if (slot != null) {
      // Inside a slot box.
      if (slot.cursorIndex.value > 0) {
        final leftNode =
        slot.children[slot.cursorIndex.value - 1];

        if (leftNode.slots.isNotEmpty) {
          // Enter the last slot of the left node
          // at its end.
          final lastSlot = leftNode.slots.last;
          selectSlot(lastSlot, position: lastSlot.children.length,);
        } else {
          // Plain character: move cursor left.
          slot.cursorIndex.value--;
        }
      } else {
        // At position 0 of current slot.
        final parentNode = slot.parentNode;

        if (parentNode != null) {
          final currentSlotIdx = parentNode.slots.indexOf(slot);

          if (currentSlotIdx > 0) {
            // Move to previous slot in parentNode
            // at its end.
            final prevSlot = parentNode.slots[currentSlotIdx - 1];

            selectSlot(prevSlot, position: prevSlot.children.length,);
          } else {
            // Reached first slot:
            // step out of parentNode to the left.
            _stepOutOfNodeLeft(parentNode);
          }
        }
      }
    } else {
      // At root level.
      if (cursorIndex.value > 0) {
        final leftNode = noteNodes[cursorIndex.value - 1];

        if (leftNode.slots.isNotEmpty) {
          // Enter last slot of left node at its end.
          final lastSlot = leftNode.slots.last;

          selectSlot(lastSlot, position: lastSlot.children.length,);
        } else {
          // Plain character: move cursor left.
          cursorIndex.value--;
        }
      }
    }

    noteNodes.refresh();
  }

  void _stepOutOfNodeRight(MathNode node) {
    final parentSlot = node.parentSlot;

    if (parentSlot != null) {
      final nodeIdx =
      parentSlot.children.indexOf(node);

      selectSlot(parentSlot, position: nodeIdx + 1,);
    } else {
      final nodeIdx = noteNodes.indexOf(node);

      clearSlotSelection();

      cursorIndex.value = nodeIdx + 1;
    }
  }

  void _stepOutOfNodeLeft(MathNode node) {
    final parentSlot = node.parentSlot;

    if (parentSlot != null) {
      final nodeIdx = parentSlot.children.indexOf(node);

      selectSlot(parentSlot, position: nodeIdx,);
    } else {
      final nodeIdx = noteNodes.indexOf(node);

      clearSlotSelection();

      cursorIndex.value = nodeIdx;
    }
  }

  void switchTab(int index) {
    activeCategoryTab.value = index;
    isAbcMode.value = false;
  }

  void toggleAbcMode() {
    SemanticsService.announce(
      isAbcMode.value ? 'Pindah ke angka & logika' : 'Pindah ke huruf',
      TextDirection.ltr,
    );
    isAbcMode.toggle();
  }

  void undo() {
    SemanticsService.announce(
      'Perubahan di kembalikan',
      TextDirection.ltr,
    );
    if (noteNodes.isNotEmpty) {
      noteNodes.removeLast();
      cursorIndex.value = noteNodes.length;
      clearSlotSelection();
    }
  }

  /// Complete document LaTeX representation.
  String get latex {
    return _latexSerializer.serializeNodes(
      noteNodes,
    );
  }

  /// Complete document semantic representation.
  String get combinedSemanticText {
    if (noteNodes.isEmpty) {
      return 'Catatan matematika kosong.';
    }

    return _semanticSerializer.serializeNodes(
      noteNodes,
    );
  }
}

