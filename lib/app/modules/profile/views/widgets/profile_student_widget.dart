import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../core/Dimens.dart';
import '../../../../data/model/user_profile_model.dart';
class ProfileStudentWidget extends StatelessWidget {
  const ProfileStudentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        Text(student.studentId),
        Text(student.nameSchools),
        Text(student.grade.name),
      ],
    );
  }
}
