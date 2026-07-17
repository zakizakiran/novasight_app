import 'package:flutter/material.dart';

import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../data/model/user_profile_model.dart';
class ProfileTeacherWidget extends StatelessWidget {
  const ProfileTeacherWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: Dimens.spacePadding,
      children: [
        _buildField(context: context,icon: Icons.school, title: "Asal Sekolah : ", description: teacher.nameSchools),
        const Divider(
          color: ColorConstant.darkGrey,
          thickness: 0.4,
        ),
        _buildField(context: context,icon: Icons.class_, title: "Ajar Tingkat Kelas : ", description: teacher.grades.map((g) => g.name).join(", ")),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.informationColor,
                    fontWeight: FontWeight.bold
                ),),
                if(description != null)
                  Expanded(
                    child: Text(description,style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.informationColor,
                        fontWeight: FontWeight.w500
                    ),),
                  ),
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
