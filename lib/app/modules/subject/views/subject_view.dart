import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/modules/subject/views/widgets/row_subject_button_widget.dart';

import '../../../common/common_button_widget.dart';
import '../../../core/styles/svg/svg_constant.dart';
import '../../../core/styles/text_theme.dart';
import '../../../core/utils/dialog_helper.dart';
import '../controllers/subject_controller.dart';

class SubjectView extends GetView<SubjectController> {
  const SubjectView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Dimens.spacePadding,
          children: [
            Obx(
                  () => CommonAppBar(
                title: controller.subject.title,
                description:
                "Halaman ${controller.currentPageNumber.value} dari ${controller.subject.pages.length}",
              ),
            ),
            _body(context: context)
          ],
        ),
      ),
    );
  }
  Widget _body({
    required BuildContext context
  }){
    return Padding(
      padding: const EdgeInsets.all(Dimens.innerBigPadding),
      child: Column(
        spacing: Dimens.spacePadding,
        children: [
      CommonCardWidget(
        boxShadow: const [BoxShadowConstant.subjectPage],
        border: BorderStyleConstant.outlineBorderCard,
        child: Obx(() {
          final page = controller.subject.pages[controller.currentPageNumber.value - 1];
          return Column(
            spacing: Dimens.spacePadding,
            children: [
              _title(
                context: context,
                title: page.title,
              ),
              if(page.blockType == 'text' || page.blockType == 'heading')
                _subject(context: context, subject: page.subject,),

              if(page.blockType == 'image' || page.blockType == 'table')
                _imageUrl(context: context, semantic: page.subject, imageUrl: page.imageUrl!),

              if(page.blockType == 'formula')
                _formula(context: context, semantic: page.subject, latex: page.sourceMarkup!)
            ],
          );},
              ),
            ),
            Obx(()
            {
              final subject = controller.subject;
              final currentPageNumber = controller.currentPageNumber.value;
              final length = subject.pages.length;
              final condition = currentPageNumber == length;
              return RowSubjectButtonWidget(
                onNext: condition ? (){
                  controller.onConfirmSubject();
                  DialogHelper.show(
                      icon: SvgPicture.asset(
                        SvgConstant.iconMedal,
                        width: Dimens.iconBigSize,
                        height: Dimens.iconBigSize,
                      ),
                      title: "Selamat Telah Menyelesaikan Materi ${controller.index + 1}",
                      actions: CommonButtonWidget(
                          buttonWidth: 120,
                          buttonName: "Selesai",
                          onPressed: controller.onDone,
                      )
                  );
                } : controller.onNext,
                next: condition ? "Selesai" : "Selanjutnya",
                onPrevious: controller.onPrevious,
                enableNext: condition ? !subject.isDone : currentPageNumber <= length,
                enablePrevious: currentPageNumber > 1,
              );
            })
        ],
      ),
    );
  }

  Widget _title({
    required BuildContext context,
    required String title
  }){
    return Text(
      title,
      style: Theme.of(context).textTheme.displayMedium?.copyWith(
        color: ColorConstant.textDarkGreyColor,
        fontWeight: FontWeight.bold
      ),
    );
  }
  Widget _subject({
    required BuildContext context,
    required String subject,
  }){
    return Text(
      subject,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
          color: ColorConstant.textDarkGreyColor,
          fontWeight: FontWeight.w500
      ),
    );
  }

  Widget _imageUrl({
    required BuildContext context,
    required String semantic,
    required String imageUrl,
  }) {
    return Semantics(
      label: semantic,
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 100,
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 100,
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.grey[600],
                size: 24,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _formula({
    required BuildContext context,
    required String semantic,
    required String latex,
  }){
    return Semantics(
      label: semantic,
      excludeSemantics: true,
      child: Math.tex(
        latex,
        mathStyle: MathStyle.text,
        textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: ColorConstant.textDarkGreyColor,
            fontWeight: FontWeight.w500
        )
      ),
    );
  }

}
