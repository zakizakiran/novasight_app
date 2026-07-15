import 'package:get/get.dart';

class ExamOptionModel {
  final String id;
  final String letter;
  final String text;

  ExamOptionModel({
    required this.id,
    required this.letter,
    required this.text,
  });
}

class ExamQuestionModel {
  final String id;
  final String questionText;
  final List<ExamOptionModel> options;
  String? selectedOptionId;

  ExamQuestionModel({
    required this.id,
    required this.questionText,
    required this.options,
    this.selectedOptionId,
  });
}

class ExamActiveController extends GetxController {
  final currentIndex = 0.obs;

  final questions = <ExamQuestionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    questions.value = [
      ExamQuestionModel(
        id: 'q_0',
        questionText: 'Nilai dari 2 pangkat 3 dikali 2 pangkat 4 adalah...',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '2 pangkat 7 sama dengan 128'),
          ExamOptionModel(id: 'b', letter: 'B', text: '2 pangkat 12 sama dengan 4096'),
          ExamOptionModel(id: 'c', letter: 'C', text: '4 pangkat 7 sama dengan 16384'),
          ExamOptionModel(id: 'd', letter: 'D', text: '2 pangkat 6 sama dengan 64'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_1',
        questionText: 'Berapakah hasil dari operasi perhitungan 15 + 25 × 2 ?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '65'),
          ExamOptionModel(id: 'b', letter: 'B', text: '80'),
          ExamOptionModel(id: 'c', letter: 'C', text: '50'),
          ExamOptionModel(id: 'd', letter: 'D', text: '40'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_2',
        questionText: 'Sebuah segitiga siku-siku memiliki panjang alas 6 cm dan tinggi 8 cm. Berapakah panjang sisi miringnya?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '10 cm'),
          ExamOptionModel(id: 'b', letter: 'B', text: '12 cm'),
          ExamOptionModel(id: 'c', letter: 'C', text: '14 cm'),
          ExamOptionModel(id: 'd', letter: 'D', text: '16 cm'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_3',
        questionText: 'Berapakah nilai dari x jika diketahui persamaan linear 3x - 5 = 16 ?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '7'),
          ExamOptionModel(id: 'b', letter: 'B', text: '6'),
          ExamOptionModel(id: 'c', letter: 'C', text: '8'),
          ExamOptionModel(id: 'd', letter: 'D', text: '5'),
        ],
      ),
      ExamQuestionModel(
        id: 'q_4',
        questionText: 'Diketahui suatu barisan aritmatika dengan suku pertama 2 dan beda 3. Berapakah nilai suku ke-10?',
        options: [
          ExamOptionModel(id: 'a', letter: 'A', text: '29'),
          ExamOptionModel(id: 'b', letter: 'B', text: '32'),
          ExamOptionModel(id: 'c', letter: 'C', text: '27'),
          ExamOptionModel(id: 'd', letter: 'D', text: '25'),
        ],
      ),
    ];
  }

  void selectOption(String questionId, String optionId) {
    final questionIndex = questions.indexWhere((q) => q.id == questionId);
    if (questionIndex != -1) {
      questions[questionIndex].selectedOptionId = optionId;
      questions.refresh();
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }

  void goToQuestion(int index) {
    if (index >= 0 && index < questions.length) {
      currentIndex.value = index;
    }
  }

  void submitExam() {
    // Handle submission
    Get.back(); // Back to detail
    Get.back(); // Back to list
    Get.snackbar('Berhasil', 'Ujian telah disubmit');
  }
}
