import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/utils/date_helper.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import '../../../../../common/common_html_table_renderer.dart';
import '../../controllers/module_teacher_controller.dart';

class ChapterDetailBottomSheet extends GetView<ModuleTeacherController> {
  final int chapterId;

  const ChapterDetailBottomSheet({
    super.key,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.chapterDetail,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.textDarkGreyColor,
                    ),
              ),
              Semantics(
                button: true,
                label: context.l10n.close,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
          const Divider(),

          // Body
          Expanded(
            child: Obx(() {
              if (controller.isLoadingChapter.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.innerPadding),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final chapter = controller.selectedChapterDetail.value;
              if (chapter == null || chapter.id != chapterId) {
                return Center(
                  child: Text(
                    context.l10n.noChaptersInModule,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter Title & Info
                    Text(
                      chapter.title ?? context.l10n.chapterNumber(chapter.number?.toString() ?? ''),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: ColorConstant.textDarkGreyColor,
                          ),
                    ),
                    const SizedBox(height: Dimens.spaceSmallPadding),
                    Row(
                      children: [
                        if (chapter.number != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ColorConstant.secondary,
                              borderRadius:
                                  BorderRadius.circular(Dimens.radius),
                            ),
                            child: Text(
                              context.l10n.chapterNumber(chapter.number.toString()),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: ColorConstant.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: Dimens.spaceSmallPadding),
                        ],
                        Text(
                          DateHelper.dateFormat(chapter.createdAt),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorConstant.textGreyColor,
                                  ),
                        ),
                      ],
                    ),

                    if (chapter.sourceFile != null &&
                        chapter.sourceFile!.isNotEmpty) ...[
                      const SizedBox(height: Dimens.spaceSmallPadding),
                      Row(
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 16,
                            color: ColorConstant.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              chapter.sourceFile!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColorConstant.textGreyColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    const SizedBox(height: Dimens.spacePadding),
                    Text(
                      context.l10n.learningContentBlocks(chapter.blocks.length),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.textDarkGreyColor,
                          ),
                    ),
                    const SizedBox(height: Dimens.spaceSmallPadding),

                    if (chapter.blocks.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(Dimens.spacePadding),
                        decoration: BoxDecoration(
                          color: ColorConstant.grey,
                          borderRadius: BorderRadius.circular(Dimens.radius),
                        ),
                        child: Text(
                          context.l10n.noContentBlocksInChapter,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ColorConstant.textGreyColor,
                                  ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: chapter.blocks.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: Dimens.spaceSmallPadding),
                        itemBuilder: (context, index) {
                          final block = chapter.blocks[index];
                          return Container(
                            padding: const EdgeInsets.all(Dimens.spacePadding),
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              borderRadius:
                                  BorderRadius.circular(Dimens.radius),
                              border: Border.all(
                                color: ColorConstant.borderBlueGrey,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: ColorConstant.secondary,
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        block.blockType.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              fontSize: 10,
                                              color: ColorConstant.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "#${block.readingOrder}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color: ColorConstant.textGreyColor,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                if(block.isImageUrl)
                                  _imageUrl(block.imageUrl!),
                                if(block.isFormula)
                                  _formula(context: context, latex: block.sourceMarkup!),
                                if(block.isTable)
                                  _table(context: context, html: block.sourceMarkup!),
                                Text(
                                  block.readableText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: ColorConstant.textDarkGreyColor,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _imageUrl(String url){
    return ClipRRect(
      borderRadius: BorderRadius.circular(Dimens.radius),
      child: Image.network(
        url,
        fit: BoxFit.fitWidth,
        excludeFromSemantics: true,
      ),
    );
  }

  Widget _formula({
    required BuildContext context,
    required String latex,
  }) {
    return Semantics(
      excludeSemantics: true,
      child: SizedBox(
        width: double.infinity,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Math.tex(
            latex,
            mathStyle: MathStyle.text,
            textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: ColorConstant.textDarkGreyColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _table({
    required BuildContext context,
    required String html,
  }) {
    return CommonHtmlTableRenderer(
      html: html,
      borderColor: Theme.of(context).colorScheme.outline,
      headerBackgroundColor:
      Theme.of(context).colorScheme.surfaceContainerHighest,
      textStyle: Theme.of(context).textTheme.bodyMedium,
      headerTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
