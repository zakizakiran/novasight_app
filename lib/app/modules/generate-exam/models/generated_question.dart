import 'package:equatable/equatable.dart';

class GeneratedQuestion extends Equatable {
  String question;
  List<String> options;
  int correctOptionIndex;
  List<String> justificationSteps;
  String conclusion;
  bool isEditing;
  bool isExpanded;

  GeneratedQuestion({
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.justificationSteps,
    required this.conclusion,
    this.isEditing = false,
    this.isExpanded = false,
  });

  GeneratedQuestion clone() {
    return GeneratedQuestion(
      question: question,
      options: List.from(options),
      correctOptionIndex: correctOptionIndex,
      justificationSteps: List.from(justificationSteps),
      conclusion: conclusion,
      isEditing: isEditing,
      isExpanded: isExpanded,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [question,options,correctOptionIndex,justificationSteps,conclusion];
}
