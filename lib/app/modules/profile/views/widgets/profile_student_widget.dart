import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';

import '../../../../core/Dimens.dart';
import '../../../../data/model/user_profile_model.dart';
class ProfileStudentWidget extends StatelessWidget {
  const ProfileStudentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        _buildField(context: context,icon: Icons.person, title: "NIS/NISN : ",description: student.studentId),
        const Divider(
          color: ColorConstant.darkGrey,
          thickness: 0.4,
        ),
        _buildField(context: context,icon: Icons.school, title: "Asal Sekolah : ", description: student.nameSchools),
        const Divider(
          color: ColorConstant.darkGrey,
          thickness: 0.4,
        ),
        _buildField(context: context,icon: Icons.class_, title: "Tingkat Kelas : ", description: student.grade.name),
      ],
    );
  }

  Widget _buildField({
    required IconData icon,
    required String title,
    String? description,
    required BuildContext context,
    Function()? onTap
}){
    return Row(
      spacing: Dimens.spacePadding,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: Dimens.iconMidSize,
          color: ColorConstant.darkGrey,
        ),
        Expanded(
            child: Row(
              children: [
                Text(title,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.informationColor,
                  fontWeight: FontWeight.bold
                ),),
                if(description != null)
                  Text(description,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.informationColor,
                    fontWeight: FontWeight.w500
                ),),
              ],
            )
        ),
        // GestureDetector(
        //   onTap: onTap,
        //   child: const Icon(
        //     Icons.keyboard_arrow_right_rounded,
        //     size: Dimens.iconMediumSize,
        //     color: ColorConstant.grey,
        //   ),
        // )
      ],
    );
  }
}
