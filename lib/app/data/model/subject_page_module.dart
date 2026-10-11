import 'package:equatable/equatable.dart';

class SubjectPageModel extends Equatable{
  final String subject;
  final String title;
  final String? imageUrl;
  final String? sourceMarkup;
  final String blockType;

  const SubjectPageModel({required this.subject, required this.title,this.imageUrl, this.sourceMarkup = "", required this.blockType});

  @override
  // TODO: implement props
  List<Object?> get props => [subject,title, imageUrl, sourceMarkup, blockType];
}