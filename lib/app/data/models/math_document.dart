import 'package:lydera_app/app/data/models/student_quiz_model.dart';

import '../../core/utils/math_latex_parser.dart';
import 'math_symbol.dart';

class MathDocument {
  final int order;
  final List<MathNode> nodes;

  MathDocument({
    List<MathNode>? nodes,
    this.order = 1,
  }) : nodes = nodes?.map((node) => node.copy()).toList() ?? [];

  bool get isEmpty => nodes.isEmpty;

  factory MathDocument.fromStudentStep(StudentStep step, MathLatexParser parser) {
    final nodes = parser.parse(step.text);
    print(step.text);
    return MathDocument(
      order: step.steps,
      nodes: nodes
    );
  }

}