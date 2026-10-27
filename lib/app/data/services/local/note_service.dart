import 'package:get/get.dart';

import '../../models/math_document.dart';

class NoteService {
  final RxList<MathDocument> steps = <MathDocument>[].obs;

  void addSteps(MathDocument step){
    steps.add(step);
  }
  void removeSteps(int index){
    steps.removeAt(index);
  }
}