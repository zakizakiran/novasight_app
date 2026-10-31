import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_app_bar.dart';
import 'package:lydera_app/app/common/common_card_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/border_style.dart';
import 'package:lydera_app/app/core/styles/box_shadow_style.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/subject/views/widgets/row_subject_button_widget.dart';
import 'package:lydera_app/app/modules/subject/views/widgets/table_mode_switch_widget.dart';

import '../../../common/common_button_widget.dart';
import '../../../common/common_html_table_renderer.dart';
import '../../../common/common_text_form_field_widget.dart';
import '../../../core/styles/icon_txt.dart';
import '../../../core/styles/svg/svg_constant.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/table_mode.dart';
import '../controllers/subject_controller.dart';
import 'package:flutter/gestures.dart';

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
            Obx(() => CommonAppBar(
                title: controller.subject.title,
                description: context.l10n.pageOf(
                  controller.currentPageNumber.value,
                  controller.subject.pages.length,
                ),
              ),
            ),
            _tableMode(context: context),
            _searchBar(context: context, controller: controller.searchController, onChange: controller.onPage),
            _body(context: context)
          ],
        ),
      ),
    );
  }

  Widget _tableMode({required BuildContext context}){
    return Obx(() {
      final page = controller.subject.pages[controller.currentPageNumber.value - 1];
      final isTable = page.blockType == 'table';
      if(isTable){
        return Padding(
          padding: const EdgeInsets.all(Dimens.innerBigPadding),
          child: CommonCardWidget(
              boxShadow: const [BoxShadowConstant.subjectPage],
              border: BorderStyleConstant.outlineBorderCard,
              child: TableModeSwitchWidget(
                  selectedMode: controller.selectedMode.value,
                  onChanged: controller.selectedMode.call
              )
          ),
        );
      }
      return const SizedBox.shrink();
    });
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

              if(page.blockType == 'image')
                _imageUrl(context: context, semantic: page.subject, imageUrl: page.imageUrl!),

              if(page.blockType == 'table')
                _table(context: context, semantic: page.subject, html: page.sourceMarkup!),

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
                      title: context.l10n.completedChapterTitle(controller.index + 1),
                      actions: CommonButtonWidget(
                          buttonWidth: 120,
                          buttonName: context.l10n.finish,
                          onPressed: controller.onDone,
                      )
                  );
                } : controller.onNext,
                next: condition ? context.l10n.finish : context.l10n.next,
                onPrevious: controller.onPrevious,
                enableNext: condition ? !subject.isDone : currentPageNumber <= length,
                enablePrevious: currentPageNumber > 1,
              );
            })
        ],
      ),
    );
  }

  Widget _searchBar({
    required BuildContext context,
    required TextEditingController controller,
    required Function(int) onChange
  }){
    return Semantics(
      textField: true,
      label: "Cari halaman hanya menerima angka",
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimens.innerBigPadding),
        child: CommonTextFormFieldWidget(
          controller: controller,
          prefixIcon: const Text(IconTxt.lens),
          hint: context.l10n.searchPageHint,
          onChanged: (value) => onChange(int.tryParse(value) ?? -1),
          fillColor: ColorConstant.white,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          keyboardType: const TextInputType.numberWithOptions(signed: false,decimal: false),
          borderSideFocused: const BorderSide(
            width: 1.5,
          ),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstant.textGreyColor,
          ),
          borderSideEnable: const BorderSide(
            width: 1.5,
          ),
        ),
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

  Widget _subject({required BuildContext context, required String subject}) {
    final sentences = subject.split(RegExp(r'(?<=[.!?])\s+'));
    return Semantics(
      label: subject,
      button: false,
      child: GestureDetector(
        onTap: () {
          controller.onSentenceTapped(subject);
        },
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: ColorConstant.textDarkGreyColor,
              fontWeight: FontWeight.w500,
            ),
            children: sentences.map((sentence) {
              return TextSpan(
                text: '$sentence ',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.onSentenceTapped(sentence);
                  },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _table({
    required BuildContext context,
    required String semantic,
    required String html,
  }) {
    final mode = controller.selectedMode.value;

    if (mode == TableMode.sentence) {
      return _buildSentenceSemantics(
        semantic: semantic,
        child: CommonHtmlTableRenderer(
          html: html,
          semanticLabel: '',
          borderColor: Theme.of(context).colorScheme.outline,
          headerBackgroundColor:
          Theme.of(context).colorScheme.surfaceContainerHighest,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          headerTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return CommonHtmlTableRenderer(
      html: html,
      semanticLabel: semantic,
      borderColor: Theme.of(context).colorScheme.outline,
      headerBackgroundColor:
      Theme.of(context).colorScheme.surfaceContainerHighest,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      headerTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _imageUrl({
    required BuildContext context,
    required String semantic,
    required String imageUrl,
  }) {
    return _buildSentenceSemantics(
      semantic: semantic,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.radius),
        child: Image.network(
          imageUrl,
          fit: BoxFit.fitWidth,
          excludeFromSemantics: true,
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

  Widget _buildSentenceSemantics({
    required String semantic,
    required Widget child,
  }) {
    final sentences = semantic
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((sentence) => sentence.trim())
        .where((sentence) => sentence.isNotEmpty)
        .toList();

    if (sentences.isEmpty) {
      return child;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(child: child),
        ...sentences.map(
              (sentence) => Semantics(
            container: true,
            label: sentence,
            child: const SizedBox(
              width: 1,
              height: 1,
              child: SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

