import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/modules/exam-teachers/controllers/exam_teachers_controller.dart';
import 'package:novasight_app/app/modules/exam-teachers/models/exam_teacher_model.dart';

import '../../../core/args/main_bar_args.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/utils/user_roles.dart';
import '../../../routes/app_pages.dart';
import '../../generate-exam/models/generated_question.dart';

class ExamTeacherDetailController extends GetxController {
  // Step 1: Pilih Modul
  final selectedModuleId = Rx<int?>(null);
  final selectedModuleName = ''.obs;

  // Step 2: Konfigurasi
  final titleController = TextEditingController();
  final numberOfQuestions = 10.obs;
  final answerOptions = 'A-E'.obs;
  final difficulty = 'Sedang'.obs;

  // List Soal yang di-generate
  final generatedQuestions = <GeneratedQuestion>[].obs;
  late final List<GeneratedQuestion> initialQuestion;

  // Backup saat diedit
  final Map<int, GeneratedQuestion> editingCache = {};
  final examTeacherController = Get.find<ExamTeachersController>();

  final isTitleReadOnly = true.obs;
  final title = ''.obs;
  final Rxn<ExamTeacherModel> selectedExam = Rxn<ExamTeacherModel>();
  bool get hasChanges => !listEquals(initialQuestion, generatedQuestions) || title.value != selectedExam.value!.title;


  @override
  void onInit() {
    super.onInit();
    selectedExam.value = Get.arguments as ExamTeacherModel;
    titleController.addListener(() {
      title.value = titleController.text;
    });
    titleController.text = selectedExam.value!.title;
    startGeneration();
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

  Future<void> startGeneration() async {
    generatedQuestions.clear();
    editingCache.clear();

    for (int i = 0; i < numberOfQuestions.value; i++) {
      generatedQuestions.add(
        GeneratedQuestion(
          question: 'Manakah yang merupakan definisi himpunan yang paling tepat?',
          options: const [
            'Kumpulan objek yang tidak terdefinisi',
            'Kumpulan objek yang dapat didefinisikan dengan jelas',
            'Kumpulan angka yang berurutan',
            'Kumpulan huruf dalam alfabet',
          ],
          correctOptionIndex: 1, // 'B'
          justificationSteps: const [
            'Himpunan didefinisikan sebagai kumpulan objek yang dapat diidentifikasi dengan jelas.',
            'Setiap anggota himpunan memiliki kriteria keanggotaan yang pasti — bisa ditentukan apakah suatu objek termasuk atau tidak.',
            'Pilihan B menyebutkan "dapat didefinisikan dengan jelas" yang persis sesuai definisi matematis himpunan.',
          ],
          conclusion: 'Jawaban: B — Kumpulan objek yang dapat didefinisikan dengan jelas.',
          isExpanded: i == 0, // Buka panel pertama saja
        ),
      );
    }
    initialQuestion = generatedQuestions
        .map((q) => q.clone())
        .toList();
  }

  void onToggleTitle() {
    isTitleReadOnly.value = !isTitleReadOnly.value;
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

  void onConfirmChange() {
    String title = "Soal Ujian Berhasil diubah";
    String message = "Soal ujian saat ini bersifat draft";
    selectedExam.value = selectedExam.value?.copyWith(title: titleController.text);
    examTeacherController.onChangeExamStatus(selectedExam.value!,"Draft");
    SnackbarHelper.showSuccess(title: title, message: message);
    Get.offNamedUntil(
      Routes.MAIN_LAYOUT,
      arguments: const MainBarArgs(role: UserRoles.guru,index: 2),
          (route) => route.settings.name == Routes.MAIN_LAYOUT,
    );
  }
}
