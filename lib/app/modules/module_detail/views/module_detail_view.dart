import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_app_bar.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/common/common_gradient_progress_bar_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/utils/ui_state.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/module_detail_controller.dart';

class ModuleDetailView extends GetView<ModuleDetailController> {
  const ModuleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final state = controller.state.value;

              return switch (state) {
                UiStateInitial<void>() ||
                UiStateLoading<void>() =>
                  _buildLoadingSkeleton(context),
                UiStateFailure<void>(:final error) =>
                  _buildErrorState(context, error),
                UiStateSuccess<void>() => _buildContent(context),
              };
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonAppBar(
          title: "Memuat Daftar Isi...",
          description: "Materi Pembelajaran",
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daftar Isi",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: ColorConstant.informationColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: Dimens.spacePadding),
              _buildShimmerChapterList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerChapterList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: Dimens.spacePadding),
            child: Container(
              height: 76,
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.innerPadding,
                vertical: Dimens.innerMediumPadding,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.radius),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: Dimens.spacePadding),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: Dimens.spacePadding),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonAppBar(
          title: "Terjadi Kesalahan",
          description: "Daftar Isi",
        ),
        Padding(
          padding: const EdgeInsets.all(Dimens.innerPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: ColorConstant.redColor,
                ),
                const SizedBox(height: 12),
                Text(
                  error,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textDarkGreyColor,
                      ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.onLoad,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (controller.hasApiDetail) {
      final detail = controller.studentModule.value!;
      final progress = detail.progress;
      final percentage = progress?.progressPercentage ?? 0;

      return Column(
        children: [
          CommonAppBar(
            title: "${detail.chapters.length} Bab Materi",
            description: detail.title,
          ),
          Padding(
            padding: const EdgeInsets.all(Dimens.innerPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (progress != null) ...[
                  CommonCardWidget(
                    border: BorderStyleConstant.outlineBorderCard,
                    boxShadow: const [BoxShadowConstant.module],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progres Pembelajaran',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ColorConstant.textPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              '$percentage% Selesai',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ColorConstant.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CommonGradientProgressBarWidget(
                          percentage: (percentage.clamp(0, 100)) / 100,
                          colors: const [
                            ColorConstant.linearSecondary,
                            ColorConstant.linearPrimary,
                          ],
                          stops: const [0.2, 1.0],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Dimens.spacePadding),
                ],
                Text(
                  "Daftar Isi",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: ColorConstant.informationColor,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: Dimens.spacePadding),
                _buildStudentChapterList(
                  chapters: detail.chapters,
                  onDetail: controller.onChapterStudent,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return const SizedBox(
        height: 200,
        child: Center(child: Text('Modul tidak ditemukan.')),
      );
  }

  Widget _buildStudentChapterList({
    required List<StudentChapterSummaryModel> chapters,
    required void Function(StudentChapterSummaryModel, int) onDetail,
  }) {
    return Column(
      children: List.generate(
        chapters.length,
        (i) {
          final chapter = chapters[i];
          final isDone = chapter.chapterProgress?.isDone ?? false;

          return Obx(() {
            final isStarting =
                controller.startingChapterId.value == chapter.id;
            final isAnyStarting =
                controller.startingChapterId.value != null;

            return Padding(
              padding: EdgeInsets.only(
                bottom: i == chapters.length - 1 ? 0 : Dimens.spacePadding,
              ),
              child: Semantics(
                button: true,
                enabled: !isAnyStarting,
                label: isStarting
                    ? 'Membuka Bab ${i + 1}: ${chapter.title}, sedang memuat materi...'
                    : 'Bab ${i + 1}: ${chapter.title}, Status: ${isDone ? "Selesai" : "Belum Selesai"}',
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isAnyStarting && !isStarting ? 0.6 : 1.0,
                  child: CommonCardWidget(
                    onPressed: isAnyStarting ? null : () => onDetail(chapter, i),
                    border: isStarting
                        ? Border.all(
                            color: ColorConstant.primary,
                            width: 1.5,
                          )
                        : BorderStyleConstant.outlineBorderCard,
                    boxShadow: const [BoxShadowConstant.module],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                ColorConstant.linearSecondary,
                                ColorConstant.linearPrimary,
                              ],
                              stops: [0.1, 1.0],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            (i + 1).toString(),
                            style: const TextStyle(
                              color: ColorConstant.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimens.spacePadding),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                chapter.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: ColorConstant.textDarkGreyColor,
                                  fontSize: 16,
                                ),
                              ),
                              if (isStarting) ...[
                                const SizedBox(height: 4),
                                const Text(
                                  'Memuat isi materi...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorConstant.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: Dimens.spacePadding),
                        if (isStarting)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorConstant.primary,
                            ),
                          )
                        else
                          _buildCheckmark(isDone),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildCheckmark(bool isDone) {
    final backgroundColor = isDone ? ColorConstant.green : ColorConstant.white;
    final shadowColor =
        isDone ? ColorConstant.greenShadow : ColorConstant.shadowColor;
    final borderColor =
        isDone ? ColorConstant.green : ColorConstant.borderNormalGrey;

    return Semantics(
      label: isDone ? "Selesai" : "Belum Selesai",
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isDone ? 0 : Dimens.border,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: isDone ? 8 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Visibility(
          visible: isDone,
          child: SvgPicture.asset(
            SvgConstant.iconCheck,
            width: Dimens.iconMidSize,
            height: Dimens.iconMidSize,
            colorFilter: const ColorFilter.mode(
              ColorConstant.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
