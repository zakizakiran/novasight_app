import 'package:equatable/equatable.dart';

class ClassModel extends Equatable{
  final String className;
  final String schoolName;
  final String teacherName;
  const ClassModel({required this.className, required this.schoolName, required this.teacherName});

  @override
  List<Object?> get props => [className,schoolName,teacherName];
}

ClassModel class1 = ClassModel(className: "Matematika Kelas 10 — 2026", schoolName: "SLBN-A CITEUREUP", teacherName: "Bayu");