import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/views/widgets/change_class_widget.dart';

import '../../../../core/Dimens.dart';
class ChangeClassBottomSheet extends GetView<TeacherDashboardController> {
  const ChangeClassBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Padding(
        // Pushes content up smoothly when the keyboard opens
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: Dimens.spacePadding
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ChangeClassWidget(
            classrooms: controller.classrooms,
            selectedClassroom: controller.selectedClassroom,
            onSelectedClassroom: controller.onSelectedClassroom,
            onDeleteClassroom: controller.onDeleteClassroom,
          ),
        ),
      ),
    );
  }
}
