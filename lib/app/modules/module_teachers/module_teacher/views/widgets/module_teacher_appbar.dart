import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/routes/app_pages.dart';
class ModuleTeacherAppbar extends StatelessWidget {
  const ModuleTeacherAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
                "Modul",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ColorConstant.textDarkGreyColor
              ),
              textAlign: TextAlign.start,
            )
        ),
        CommonButtonWidget(
            buttonName: "+ Unggah Modul",
            boxShadows: const [],
            onPressed: (){
              Get.toNamed(Routes.CREATE_MODULE);
            }
        )
      ],
    );
  }
}
