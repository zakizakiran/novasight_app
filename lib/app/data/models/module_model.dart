import 'package:equatable/equatable.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/data/model/subject_model.dart';
import 'package:novasight_app/app/data/model/subject_page_module.dart';

class ModuleModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final List<SubjectModel> subjects;
  final PublicStatus status;
  const ModuleModel({required this.id, required this.title, required this.description, required this.subjects, this.status = PublicStatus.notDone});

  ModuleModel copyWith({
    int? id,
    String? title,
    String? description,
    List<SubjectModel>? subjects,
    PublicStatus? status
  }){
    return ModuleModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        subjects: subjects ?? this.subjects
    );
  }
  int toPercentageDone() {
    return subjects.isEmpty
        ? 0
        : ((subjects.where((s) => s.isDone).length / subjects.length) * 100)
        .round();
  }

  @override
  List<Object?> get props => [id,title,description,subjects,status];
}