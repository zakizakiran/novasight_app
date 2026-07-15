import 'package:equatable/equatable.dart';
import 'package:novasight_app/app/data/model/subject_page_module.dart';

class SubjectModel extends Equatable {
  final int id;
  final String title;
  final bool isDone;
  final List<SubjectPageModel> pages;
  const SubjectModel({required this.title, required this.isDone, required this.pages, required this.id});

  SubjectModel copyWith({
    int? id,
    String? title,
    bool? isDone,
    List<SubjectPageModel>? pages,
  }) {
    return SubjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
      pages: pages ?? this.pages,
    );
  }

  @override
  List<Object?> get props => [id,title,isDone,pages];
}