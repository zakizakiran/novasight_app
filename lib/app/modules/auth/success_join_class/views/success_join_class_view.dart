import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/data/model/class_model.dart';
import 'package:novasight_app/app/modules/auth/success_join_class/views/widgets/class_card.dart';
import 'package:novasight_app/app/modules/auth/success_join_class/views/widgets/feature_card.dart';
import 'package:novasight_app/app/routes/app_pages.dart';

import '../../../../core/styles/box_shadow_style.dart';
import '../../../../core/utils/user_roles.dart';
import '../../widgets/auth_appbar.dart';
import '../../../../common/common_button_widget.dart';
import '../../../../core/Dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../../../core/styles/icon_txt.dart';
import '../../../../common/common_card_widget.dart';
import '../controllers/success_join_class_controller.dart';

class SuccessJoinClassView extends GetView<SuccessJoinClassController> {
  const SuccessJoinClassView({super.key});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final appBarHeight = height * 0.3;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AuthAppbar(iconSvg: SvgConstant.iconCheck, title: "Berhasil", description: "Kamu sudah bergabung ke kelas",height: appBarHeight,),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: CommonCardWidget(
                boxShadow: const [
                  BoxShadowConstant.auth,
                ],
                margin: const EdgeInsets.only(top: Dimens.innerPadding),
                child: Column(
                  spacing: Dimens.spacePadding,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleField(context: context, title: "Kelas Ditemukan"),
                    ClassCard(classModel: class1),
                    _titleField(context: context, title: "Selanjutnya kamu bisa:"),
                    const FeatureCard(iconTxt: IconTxt.module, description: "Baca modul pelajaran dari gurumu"),
                    const FeatureCard(iconTxt: IconTxt.pencil, description: "Kerjakan soal ujian yang diberikan"),
                    const FeatureCard(iconTxt: IconTxt.chat, description: "Diskusi materi dengan AI"),
                    Obx(
                            () => CommonButtonWidget(
                            buttonWidth: double.infinity,
                            isLoading: controller.isLoading.value,
                            buttonName: "Mulai Belajar →",
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Mulai Belajar ",
                                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      color: ColorConstant.white
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Icon(
                                  Icons.arrow_right_alt_rounded,
                                  color: ColorConstant.white,
                                  size: Dimens.iconMediumSize,
                                ),
                              ],
                            ),
                            onPressed: (){
                              Get.offAllNamed(
                                  Routes.SPLASH,
                                  arguments: UserRoles.siswa
                              );
                            }
                        )
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _titleField({
    required BuildContext context,
    required String title
  }) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}
