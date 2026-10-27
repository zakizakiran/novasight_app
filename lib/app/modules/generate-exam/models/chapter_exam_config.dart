import 'package:get/get.dart';
import 'package:lydera_app/app/data/models/quiz_teacher_model.dart';

class ChapterExamConfig {
  final int chapterId;
  final String title;
  final int? number;
  final RxBool isSelected;
  final RxInt hotsCount;
  final RxInt lotsCount;

  ChapterExamConfig({
    required this.chapterId,
    required this.title,
    this.number,
    bool isSelected = true,
    int hotsCount = 2,
    int lotsCount = 3,
  })  : isSelected = isSelected.obs,
        hotsCount = hotsCount.obs,
        lotsCount = lotsCount.obs;

  int get totalQuestions => hotsCount.value + lotsCount.value;

  void incrementHots() => hotsCount.value++;
  void decrementHots() {
    if (hotsCount.value > 0) hotsCount.value--;
  }

  void incrementLots() => lotsCount.value++;
  void decrementLots() {
    if (lotsCount.value > 0) lotsCount.value--;
  }

  void toggleSelect() {
    isSelected.value = !isSelected.value;
  }

  QuizChapterRequest toRequest() {
    return QuizChapterRequest(
      chapterId: chapterId,
      hotsCount: hotsCount.value,
      lotsCount: lotsCount.value,
    );
  }
}
