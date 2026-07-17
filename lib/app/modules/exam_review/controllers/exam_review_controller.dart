import 'package:get/get.dart';
import 'package:novasight_app/app/data/models/exam_review_model.dart';

class ExamReviewController extends GetxController {
  final currentIndex = 0.obs;

  final questions = <ExamReviewQuestion>[
    ExamReviewQuestion(
      id: 1,
      question: 'Nilai dari 2 pangkat 3 dikali 2 pangkat 4 adalah...',
      options: [
        '2 pangkat 7 sama dengan 128',
        '2 pangkat 12 sama dengan 4096',
        '4 pangkat 7 sama dengan 16384',
        '2 pangkat 6 sama dengan 64',
      ],
      correctAnswerIndex: 0,
      userAnswerIndex: 0,
      isCorrect: true,
      score: 20,
      explanationSteps: [
        'Sifat perkalian eksponen menyatakan: a pangkat m dikali a pangkat n sama dengan a pangkat m tambah n.',
        'Jadi 2 pangkat 3 dikali 2 pangkat 4 sama dengan 2 pangkat 3 tambah 4.',
        '3 tambah 4 sama dengan 7, sehingga hasilnya adalah 2 pangkat 7.',
        '2 pangkat 7 sama dengan 128.'
      ],
    ),
    ExamReviewQuestion(
      id: 2,
      question: 'Bentuk sederhana dari 3 pangkat 2, kemudian hasilnya dipangkatkan 3 adalah...',
      options: [
        '3 pangkat 5 sama dengan 243',
        '3 pangkat 6 sama dengan 729',
        '9 pangkat 3 sama dengan 739',
        '3 pangkat 8 sama dengan 6561',
      ],
      correctAnswerIndex: 1,
      userAnswerIndex: 2, // User selected C
      isCorrect: false,
      score: 0,
      explanationSteps: [], // Custom explanation via user steps
      userWorkingSteps: [
        '3 × 3 = 9',
        '9 × 9 = 81',
        '81 × 9 = 739',
      ],
      errorStepIndex: 2, // 0-based index for the 3rd step
      errorExplanation: 'Di langkah ke-3, kamu menghitung 81 × 9 = 739. Ini salah — 81 × 9 sebenarnya sama dengan 729, bukan 739.',
      correction: 'Cara yang benar: sifat pangkat dari pangkat adalah (a pangkat m) pangkat n sama dengan a pangkat m kali n. Jadi (3 pangkat 2) pangkat 3 = 3 pangkat 2 × 3 = 3 pangkat 6 = 729.',
    ),
    ExamReviewQuestion(
      id: 3,
      question: 'Nilai dari logaritma basis 2 dari 32 adalah...',
      options: [
        '4',
        '5',
        '6',
        '16',
      ],
      correctAnswerIndex: 1, // B
      userAnswerIndex: 2, // User selected C
      isCorrect: false,
      score: 0,
      explanationSteps: [
        'Logaritma basis 2 dari 32 berarti: 2 pangkat berapa yang menghasilkan 32?',
        '2 pangkat 1 = 2, 2 pangkat 2 = 4, 2 pangkat 3 = 8, 2 pangkat 4 = 16, 2 pangkat 5 = 32.',
        'Jadi 2 pangkat 5 sama dengan 32, maka log basis 2 dari 32 = 5.',
        'Pilihan C (6) salah karena 2 pangkat 6 = 64, bukan 32.'
      ],
    ),
    ExamReviewQuestion(
      id: 4,
      question: 'Jika log basis 3 dari 81 sama dengan x, maka nilai x adalah...',
      options: [
        '2',
        '3',
        '4',
        '5',
      ],
      correctAnswerIndex: 2, // C
      userAnswerIndex: 2, // C
      isCorrect: true,
      score: 20,
      explanationSteps: [
        'Logaritma basis 3 dari 81 berarti: 3 pangkat berapa yang menghasilkan 81?',
        '3 pangkat 1 = 3, 3 pangkat 2 = 9, 3 pangkat 3 = 27, 3 pangkat 4 = 81.',
        'Karena 3 pangkat 4 = 81, maka log basis 3 dari 81 = 4.',
        'Sehingga nilai x = 4.'
      ],
    ),
    ExamReviewQuestion(
      id: 5,
      question: 'Nilai dari log basis 10 dari 1000 adalah...',
      options: [
        '2',
        '3',
        '4',
        '10',
      ],
      correctAnswerIndex: 1, // B
      userAnswerIndex: 1, // B
      isCorrect: true,
      score: 20,
      explanationSteps: [
        'Logaritma basis 10 dari 1000 berarti: 10 pangkat berapa yang menghasilkan 1000?',
        '10 pangkat 1 = 10, 10 pangkat 2 = 100, 10 pangkat 3 = 1000.',
        'Karena 10 pangkat 3 = 1000, maka log basis 10 dari 1000 = 3.',
        'Logaritma basis 10 juga disebut logaritma umum dan sering ditulis hanya log 1000 = 3.'
      ],
    ),
  ].obs;

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
}

