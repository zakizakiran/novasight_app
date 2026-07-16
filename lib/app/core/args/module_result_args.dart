import 'package:novasight_app/app/data/model/module_teacher_model.dart';

class ModuleResultArgs {
  final ModuleTeacherModel module;
  final bool canPop;

  const ModuleResultArgs({
    required this.module,
    required this.canPop,
  });
}