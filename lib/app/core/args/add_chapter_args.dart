import '../../data/models/teacher_model.dart';

class AddChapterArgs {
  final TeacherModuleDetailModel module;
  final void Function(TeacherChapterSummaryModel addChapter) onChapterAdded;

  const AddChapterArgs({
    required this.module,
    required this.onChapterAdded,
  });
}