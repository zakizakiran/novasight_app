import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_button_widget.dart';
import 'package:novasight_app/app/core/args/module_result_args.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/date_helper.dart';
import 'package:novasight_app/app/core/utils/dialog_helper.dart';
import 'package:novasight_app/app/data/model/module_teacher_model.dart';

import '../../../../../core/Dimens.dart';
import '../../../../../routes/app_pages.dart';
import '../../controllers/module_teacher_controller.dart';


class ModuleTeacherCardWidget extends GetView<ModuleTeacherController> {
  final ModuleTeacherModel module;
  const ModuleTeacherCardWidget({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.all(Dimens.spacePadding),
    margin: const EdgeInsets.symmetric(
      vertical: Dimens.spacePadding,
    ),
    decoration: const BoxDecoration(
      color: ColorConstant.white,
      boxShadow: [
        BoxShadowConstant.module,
      ],
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _iconType(module.type, context),
            const SizedBox(width: Dimens.spacePadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: Dimens.spaceSmallPadding),

                  Text(
                    "${module.gradeType.name} · ${DateHelper.dateFormat(DateTime.now())}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(width: Dimens.spacePadding),
            _statusModule(module.status, context),
          ],
        ),

        const SizedBox(height: Dimens.spaceBigPadding),

        Row(
          children: [
            Expanded(
              child: CommonButtonWidget(
                buttonName: "Lihat Modul",
                onPressed: () {
                  Get.toNamed(
                      Routes.MODULE_RESULT_ANNOTATION,
                      arguments: ModuleResultArgs(
                          module: module,
                          canPop: true)
                  );
                },
                buttonColor: ColorConstant.white,
                border: const BorderSide(
                  color: ColorConstant.borderBlueGrey,
                  width: 1,
                ),
                boxShadows: const [],
                textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.informationColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(width: Dimens.spacePadding),

            Expanded(
              child: CommonButtonWidget(
                buttonName: "Publish Modul",
                isValid: module.status != ModuleTeacherStatus.publish,
                boxShadows: const [],
                onPressed: (){
                  controller.onPublishModule(module);
                },
              ),
            ),

            const SizedBox(width: Dimens.spacePadding),

            _iconTrash(
              module,
              context,
                  () {
                DialogHelper.show(
                  title: "Hapus Modul",
                  description: "Anda yakin ingin menghapus modul ini?",
                  colorDescription: ColorConstant.textDarkGreyColor,
                  icon: SvgPicture.asset(
                    SvgConstant.iconTrashConfirmation,
                    width: Dimens.iconBigSize,
                    height: Dimens.iconBigSize,
                  ),
                  actions: CommonButtonWidget(
                    buttonName: "Konfirmasi",
                    buttonColor: ColorConstant.redColor,
                    onPressed: () {
                      controller.onDeleteModule(module);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
    );
  }

  Widget _iconType(ModuleTeacherType type, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Dimens.spacePadding),
      decoration: const BoxDecoration(
        color: ColorConstant.secondary,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius)),
      ),
      child: Text(
        type.name,
        style: Theme.of(
          context,
        ).textTheme.headlineSmall?.copyWith(color: ColorConstant.primary),
      ),
    );
  }

  Widget _statusModule(ModuleTeacherStatus status, BuildContext context) {
    final Color textColor = switch (status) {
      ModuleTeacherStatus.all ||
      ModuleTeacherStatus.publish => ColorConstant.green,
      ModuleTeacherStatus.draft => ColorConstant.darkGrey,
    };

    final Color backgroundColor = switch (status) {
      ModuleTeacherStatus.all ||
      ModuleTeacherStatus.publish => ColorConstant.lightGreen,
      ModuleTeacherStatus.draft => ColorConstant.grey,
    };

    return Container(
      padding: const EdgeInsets.all(Dimens.spaceMediumPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
      ),
      child: Text(
        status.name,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _iconTrash(
    ModuleTeacherModel module,
    BuildContext context,
    Function() onDelete,
  ) {
    return GestureDetector(
      onTap: onDelete,
      child: Row(
        spacing: Dimens.spacePadding,
        children: [
          SvgPicture.asset(
            SvgConstant.iconTrash,
            width: Dimens.iconRegularSize,
            height: Dimens.iconRegularSize,
          ),
          Text(
            "Hapus",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: ColorConstant.redColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
