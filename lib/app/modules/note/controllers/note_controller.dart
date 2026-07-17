import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/modules/exam_active/controllers/exam_active_controller.dart';

class NoteController extends GetxController {
  ExamQuestionModel? question;
  int index = 1;
  int total = 1;

  final steps = <String>[].obs;
  final activeInputText = "".obs;
  final isInputActive = false.obs;
  final activeKeyboardTab = "Math".obs;

  final keyboardCategories = [
    {
      "name": "Aritmatika Dasar",
      "keys": ["+", "-", "×", "÷", "=", "(", ")"]
    },
    {
      "name": "Aljabar",
      "keys": ["x", "y", "z", "a", "b", "^", "√"]
    },
    {
      "name": "Logika",
      "keys": ["<", ">", "≤", "≥", "≠", "!", "%"]
    }
  ];

  final currentCategoryIndex = 0.obs;

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map) {
      question = args['question'];
      index = args['index'] ?? 1;
      total = args['total'] ?? 1;
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

  void activateInput() {
    isInputActive.value = true;
    scrollToBottom();
  }

  void deactivateInput() {
    isInputActive.value = false;
  }

  void addTextToInput(String text) {
    if (!isInputActive.value) activateInput();

    // 1. Spacing for math keywords and operators
    final mathKeywords = ['log', 'pangkat', 'akar', 'log basis'];
    final operators = ['+', '-', '×', '÷', '='];
    
    if (mathKeywords.contains(text) || operators.contains(text)) {
      text = " $text ";
    }

    String current = activeInputText.value + text;

    // 2. Formatting leading zeros: "02" -> "2", but keeps "0.2"
    current = current.replaceAllMapped(RegExp(r'(?<!\.)\b0+([0-9]+)'), (match) => match.group(1)!);
    
    // Prevent multiple spaces from stacking up
    current = current.replaceAll(RegExp(r' {2,}'), ' ');

    // Trim left in case it starts with a space
    if (current.startsWith(' ')) {
      current = current.substring(1);
    }

    activeInputText.value = current;
  }

  void removeLastCharacter() {
    String current = activeInputText.value;
    if (current.isEmpty) return;

    final keywords = ['log', 'pangkat', 'akar', 'log basis', '+', '-', '×', '÷', '='];
    
    for (String kw in keywords) {
      if (current.endsWith(" $kw ")) {
        activeInputText.value = current.substring(0, current.length - (" $kw ").length);
        return;
      } else if (current == "$kw ") {
        activeInputText.value = "";
        return;
      }
    }

    activeInputText.value = current.substring(0, current.length - 1);
  }

  void clearInput() {
    activeInputText.value = "";
  }

  void saveStep() {
    if (activeInputText.value.trim().isNotEmpty) {
      steps.add(activeInputText.value.trim());
      activeInputText.value = "";
      isInputActive.value = false;
      
      // Auto scroll to bottom after saving a step if the list is long
      scrollToBottom();
    }
  }

  void removeStep(int index) {
    if (index >= 0 && index < steps.length) {
      steps.removeAt(index);
    }
  }

  String getMathSemanticText(String text) {
    return text
        .replaceAll('-', ' kurang ')
        .replaceAll('+', ' tambah ')
        .replaceAll('×', ' kali ')
        .replaceAll('÷', ' bagi ')
        .replaceAll('=', ' sama dengan ')
        .replaceAll('<', ' lebih kecil dari ')
        .replaceAll('>', ' lebih besar dari ')
        .replaceAll('^', ' pangkat ')
        .replaceAll('√', ' akar ')
        .replaceAll('!', ' faktorial ')
        .replaceAll('%', ' persen ')
        .replaceAll('(', ' kurung buka ')
        .replaceAll(')', ' kurung tutup ')
        .replaceAll('?', ' tanda tanya ')
        .replaceAll('.', ' titik ')
        .replaceAll(',', ' koma ')
        .replaceAll('log', ' logaritma ');
  }

  void readAloud() {
    String textToRead = "Soal, ${getMathSemanticText(question?.questionText ?? '')}. ";
    if (steps.isNotEmpty) {
      textToRead += "Langkah pengerjaan yang sudah dibuat: ";
      for (int i = 0; i < steps.length; i++) {
        textToRead += "Langkah ${i + 1}, ${getMathSemanticText(steps[i])}. ";
      }
    } else {
      textToRead += "Belum ada langkah pengerjaan yang dibuat.";
    }
    
    // ignore: deprecated_member_use
    SemanticsService.announce(textToRead, TextDirection.ltr);
  }

  void swapKeyboardCategory() {
    currentCategoryIndex.value = (currentCategoryIndex.value + 1) % keyboardCategories.length;
    String categoryName = keyboardCategories[currentCategoryIndex.value]["name"] as String;
    
    // ignore: deprecated_member_use
    SemanticsService.announce("Keyboard beralih ke kelompok simbol $categoryName", TextDirection.ltr);
  }
}

