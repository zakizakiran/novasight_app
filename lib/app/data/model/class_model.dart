import 'package:equatable/equatable.dart';

class ClassModel extends Equatable{
  final String className;
  final String schoolName;
  final String teacherName;
  const ClassModel({required this.className, required this.schoolName, required this.teacherName});

  @override
  List<Object?> get props => [className,schoolName,teacherName];
}

enum ClassType {
  classTen("Kelas 10"),
  classEleven("Kelas 11"),
  classTwelve("Kelas 12");

  const ClassType(this.name);

  final String name;
}



ClassModel class1 = const ClassModel(className: "Matematika Kelas 10 — 2026", schoolName: "SLBN-A CITEUREUP", teacherName: "Bayu");