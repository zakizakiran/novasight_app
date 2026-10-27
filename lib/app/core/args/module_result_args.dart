import 'package:lydera_app/app/data/model/module_teacher_model.dart';

class ModuleResultArgs {
  final ModuleTeacherModel module;
  final bool canPop;
  final int? chapterId;
  final String? annotationPath;

  const ModuleResultArgs({
    required this.module,
    required this.canPop,
    this.chapterId,
    this.annotationPath,
  });
}