import 'package:novasight_app/app/data/model/class_model.dart';

class UserProfileModel {
  final int id;
  final String name;
  final String nameSchools;

  UserProfileModel({required this.id, required this.name, required this.nameSchools});
}

class StudentProfileModel extends UserProfileModel{
  final String studentId;
  final ClassGradeType grade;
  StudentProfileModel({required super.id, required super.name, required super.nameSchools, required this.studentId, required this.grade});
}

class TeacherProfileModel extends UserProfileModel{
  final List<ClassGradeType> grades;

  TeacherProfileModel({required super.id, required super.name, required super.nameSchools, required this.grades});
}

StudentProfileModel student = StudentProfileModel(
    id: 1,
    name: "Faris",
    nameSchools: "SLBN A-CITEUREUP",
    studentId: "10125289",
    grade: ClassGradeType.classTen
);

TeacherProfileModel teacher = TeacherProfileModel(
    id: 1,
    name: "Duva",
    nameSchools: "SLBN A-CITEUREUP",
    grades: ClassGradeType.values,
);