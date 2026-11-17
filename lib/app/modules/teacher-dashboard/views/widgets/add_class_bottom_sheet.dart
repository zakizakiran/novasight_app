import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/modules/auth/create_class/views/widgets/add_class_widget.dart';
import 'package:lydera_app/app/modules/teacher-dashboard/controllers/teacher_dashboard_controller.dart';

import '../../../../core/Dimens.dart';

class AddClassBottomSheet extends StatelessWidget {
  const AddClassBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Padding(
        // Pushes content up smoothly when the keyboard opens
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: Dimens.spacePadding
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: AddClassWidget(
            controller: Get.find<TeacherDashboardController>(),
          ),
        ),
      ),
    );
  }
}