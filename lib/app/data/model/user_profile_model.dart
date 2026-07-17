import 'package:novasight_app/app/data/model/class_model.dart';

class UserProfileModel {
  final int id;
  final String email;
  final String name;
  final String nameSchools;

  UserProfileModel({required this.id, required this.name, required this.nameSchools, required this.email});
}

class StudentProfileModel extends UserProfileModel{
  final String studentId;
  final ClassGradeType grade;
  StudentProfileModel({required super.id, required super.name, required super.nameSchools, required this.studentId, required this.grade, required super.email});
}

class TeacherProfileModel extends UserProfileModel{
  final List<ClassGradeType> grades;

  TeacherProfileModel({required super.id, required super.name, required super.nameSchools, required this.grades, required super.email});
}

StudentProfileModel student = StudentProfileModel(
    id: 1,
    name: "Faris",
    nameSchools: "SLBN A-CITEUREUP",
    studentId: "10125289",
    email: "faris@gmail.com",
    grade: ClassGradeType.classTen
);

TeacherProfileModel teacher = TeacherProfileModel(
    id: 1,
    name: "Duva",
    email: "duva@gmail.com",
    nameSchools: "SLBN A-CITEUREUP",
    grades: ClassGradeType.values,
);