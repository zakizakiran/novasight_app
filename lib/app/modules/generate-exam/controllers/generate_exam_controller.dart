import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/model/module_model.dart';
import '../../../routes/app_pages.dart';
import '../models/generated_question.dart';

class GenerateExamController extends GetxController {
  // Stepper State
  final currentStep = 0.obs;

  // Step 1: Pilih Modul
  final selectedModuleId = Rx<int?>(null);
  final selectedModuleName = ''.obs;
  
  final availableModules = <ModuleModel>[].obs;

  // Step 2: Konfigurasi
  final titleController = TextEditingController();
  final numberOfQuestions = 10.obs;
  final answerOptions = 'A-E'.obs;
  final difficulty = 'Sedang'.obs;

  // Step 3: Loading/AI
  final isGenerating = false.obs;
  final generatedCount = 0.obs;
  
  // List Soal yang di-generate
  final generatedQuestions = <GeneratedQuestion>[].obs;
  
  // Backup saat diedit
  final Map<int, GeneratedQuestion> editingCache = {};

  @override
  void onInit() {
    super.onInit();
    availableModules.assignAll(listModule);
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  void selectModule(int id, String name) {
    selectedModuleId.value = id;
    selectedModuleName.value = name;
  }

  void setQuestions(int value) => numberOfQuestions.value = value;
  void setAnswerOptions(String value) => answerOptions.value = value;
  void setDifficulty(String value) => difficulty.value = value;

  void nextStep() {
    if (currentStep.value == 0) {
      if (selectedModuleId.value == null) {
        Get.snackbar('Perhatian', 'Pilih modul sumber terlebih dahulu',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      currentStep.value++;
    } else if (currentStep.value == 1) {
      if (titleController.text.trim().isEmpty) {
        Get.snackbar('Perhatian', 'Masukkan judul ujian',
            snackPosition: SnackPosition.BOTTOM);
        return;
      }
      currentStep.value++;
      startGeneration();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  Future<void> startGeneration() async {
    isGenerating.value = true;
    generatedCount.value = 0;
    generatedQuestions.clear();
    editingCache.clear();

    for (int i = 1; i <= numberOfQuestions.value; i++) {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate AI wait
      generatedCount.value = i;
    }

    // Populate mock generated questions
    for (int i = 0; i < numberOfQuestions.value; i++) {
      generatedQuestions.add(
        GeneratedQuestion(
          question: 'Manakah yang merupakan definisi himpunan yang paling tepat?',
          options: [
            'Kumpulan objek yang tidak terdefinisi',
            'Kumpulan objek yang dapat didefinisikan dengan jelas',
            'Kumpulan angka yang berurutan',
            'Kumpulan huruf dalam alfabet',
          ],
          correctOptionIndex: 1, // 'B'
          justificationSteps: [
            'Himpunan didefinisikan sebagai kumpulan objek yang dapat diidentifikasi dengan jelas.',
            'Setiap anggota himpunan memiliki kriteria keanggotaan yang pasti — bisa ditentukan apakah suatu objek termasuk atau tidak.',
            'Pilihan B menyebutkan "dapat didefinisikan dengan jelas" yang persis sesuai definisi matematis himpunan.',
          ],
          conclusion: 'Jawaban: B — Kumpulan objek yang dapat didefinisikan dengan jelas.',
          isExpanded: i == 0, // Buka panel pertama saja
        ),
      );
    }

    isGenerating.value = false;
  }

  void toggleExpand(int index) {
    var q = generatedQuestions[index];
    q.isExpanded = !q.isExpanded;
    generatedQuestions.refresh();
  }

  void toggleEdit(int index) {
    var q = generatedQuestions[index];
    if (!q.isEditing) {
      // Masuk edit mode, simpan backup
      editingCache[index] = q.clone();
      q.isEditing = true;
    } else {
      // Batal edit, kembalikan dari backup
      if (editingCache.containsKey(index)) {
        generatedQuestions[index] = editingCache[index]!;
        generatedQuestions[index].isExpanded = true;
      }
      generatedQuestions[index].isEditing = false;
    }
    generatedQuestions.refresh();
  }

  void saveChanges(int index, GeneratedQuestion updatedQuestion) {
    updatedQuestion.isEditing = false;
    generatedQuestions[index] = updatedQuestion;
    editingCache.remove(index);
    generatedQuestions.refresh();
  }

  void finish() {
    Get.offNamedUntil(Routes.EXAM_TEACHERS, (route) => false);
  }
}
