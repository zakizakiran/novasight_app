class ExamTeacherModel {
  final String id;
  final String title;
  final int questionCount;
  final String type;
  final String difficulty;
  final String moduleName;
  final String status;

  ExamTeacherModel({
    required this.id,
    required this.title,
    required this.questionCount,
    required this.type,
    required this.difficulty,
    required this.moduleName,
    required this.status,
  });

  ExamTeacherModel copyWith({
    final String? id,
    final String? title,
    final int? questionCount,
    final String? type,
    final String? difficulty,
    final String? moduleName,
    final String? status,
}){
    return ExamTeacherModel(
        id: id ?? this.id,
        title: title ?? this.title,
        questionCount: questionCount ?? this.questionCount,
        type: type ?? this.type,
        difficulty: difficulty ?? this.difficulty,
        moduleName: moduleName ?? this.moduleName,
        status: status ?? this.status
    );
}

}
