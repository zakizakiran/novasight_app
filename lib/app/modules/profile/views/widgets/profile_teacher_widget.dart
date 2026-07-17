import 'package:flutter/material.dart';

import '../../../../core/Dimens.dart';
import '../../../../data/model/user_profile_model.dart';
class ProfileTeacherWidget extends StatelessWidget {
  const ProfileTeacherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        Text(teacher.nameSchools),
        Text(teacher.grades.map((g) => g.name).join(", ")),
      ],
    );
  }
}
