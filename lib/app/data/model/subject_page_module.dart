import 'package:equatable/equatable.dart';

class SubjectPageModel extends Equatable{
  final String subject;
  final String title;

  const SubjectPageModel({required this.subject, required this.title});

  @override
  // TODO: implement props
  List<Object?> get props => [subject,title];
}