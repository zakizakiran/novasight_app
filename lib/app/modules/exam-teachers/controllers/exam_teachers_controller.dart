import 'package:get/get.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../models/exam_teacher_model.dart';

class ExamTeachersController extends GetxController {
  final selectedFilter = 'Semua'.obs;

  final filterOptions = ['Semua', 'Publish', 'Draft'];

  final RxList<ExamTeacherModel> _allExams = [
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
      title: 'Latihan Soal Aljabar',
      questionCount: 15,
      type: 'Pilihan Ganda',
      difficulty: 'Sulit',
      moduleName: 'Aljabar',
      status: 'Draft',
    ),

  ].obs;

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void onDeleteExam(ExamTeacherModel exam){
    Get.back();
    _allExams.remove(exam);
  }

  void onChangeExamStatus(ExamTeacherModel exam, String status){
    final index = _allExams.indexWhere((e) => e.id == exam.id);
    if (index != -1) {
      _allExams[index] = exam.copyWith(status: status);
    }
    SnackbarHelper.showSuccess(title: "Soal Ujian Berhasil dipublish!", message: "Siswa dapat mengakses soal ujian ini.");
  }

  void onAddExam(ExamTeacherModel exam){
    _allExams.add(exam);
  }

  List<ExamTeacherModel> get filteredExams {
    if (selectedFilter.value == 'Semua') {
      return _allExams.value;
    }
    return _allExams.value.where((exam) => exam.status == selectedFilter.value).toList();
  }
}
