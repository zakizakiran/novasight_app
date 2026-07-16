import 'package:get/get.dart';
import '../models/exam_teacher_model.dart';

class ExamTeachersController extends GetxController {
  final selectedFilter = 'Semua'.obs;

  final filterOptions = ['Semua', 'Publish', 'Draft'];

  final List<ExamTeacherModel> _allExams = [
    ExamTeacherModel(
      id: '1',
      title: 'UTS Kelas X',
      questionCount: 5,
      type: 'Pilihan Ganda',
      difficulty: 'Sedang',
      moduleName: 'BAB 1 : Eksponen dan Logaritma',
      status: 'Publish',
    ),
    ExamTeacherModel(
      id: '2',
      title: 'UH 1 — Himpunan dan Operasinya',
      questionCount: 10,
      type: 'Pilihan Ganda',
      difficulty: 'Sedang',
      moduleName: 'Himpunan dan Operasinya',
      status: 'Publish',
    ),
    ExamTeacherModel(
      id: '3',
      title: 'Latihan Soal Aljabar',
      questionCount: 15,
      type: 'Pilihan Ganda',
      difficulty: 'Sulit',
      moduleName: 'Aljabar',
      status: 'Draft',
    ),
  ];

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<ExamTeacherModel> get filteredExams {
    if (selectedFilter.value == 'Semua') {
      return _allExams;
    }
    return _allExams.where((exam) => exam.status == selectedFilter.value).toList();
  }
}
