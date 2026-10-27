import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/common/common_card_widget.dart';
import 'package:lydera_app/app/common/common_gradient_progress_bar_widget.dart';
import 'package:lydera_app/app/core/Dimens.dart';
import 'package:lydera_app/app/core/styles/border_style.dart';
import 'package:lydera_app/app/core/styles/box_shadow_style.dart';
import 'package:lydera_app/app/core/styles/colors/color_constant.dart';
import 'package:lydera_app/app/core/styles/svg/svg_constant.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/data/models/student_model.dart';
import 'package:lydera_app/app/data/models/student_quiz_model.dart';
import 'package:lydera_app/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/student_dashboard_controller.dart';


class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({super.key});


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final minBlueHeight = screenHeight / 3.5;

    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.onRefresh,
          color: ColorConstant.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: minBlueHeight,
                      ),
                      color: ColorConstant.primary,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                      child: _buildHeader(context),
                    ),
                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: -50,
                      child: _buildMetricCards(context),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 20),
                  child: _buildTasksSection(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = context.l10n;
    return Obx(() {
      final name = controller.studentName.value.isNotEmpty
          ? controller.studentName.value
          : l10n.student;
      final subtitle = controller.classroomSubtitle.value.isNotEmpty
          ? controller.classroomSubtitle.value
          : l10n.loadingClassData;

      return Semantics(
        container: true,
        label: 'Informasi Profil Siswa: $name, $subtitle',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcomeStudentGreeting,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ColorConstant.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    softWrap: true,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorConstant.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Semantics(
              label: 'Foto Profil Siswa',
              image: true,
              child: const CircleAvatar(
                radius: 32,
                backgroundColor: ColorConstant.white,
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: ColorConstant.primary,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMetricCards(BuildContext context) {
    final l10n = context.l10n;
    return Obx(() {
      final dashboard = controller.dashboardData.value;
      final modulesCount = dashboard?.modulesNotDone.toString() ?? '0';
      final examCount = dashboard?.examNotDone.toString() ?? '0';

      return Row(
        children: [
          Expanded(
            child: _buildInfoCard(
              context,
              modulesCount,
              l10n.uncompletedModules,
              semanticsLabel: '$modulesCount ${l10n.uncompletedModules}',
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildInfoCard(
              context,
              examCount,
              l10n.uncompletedExams,
              semanticsLabel: '$examCount ${l10n.uncompletedExams}',
            ),
          ),
        ],
      );
    });
  }

  Widget _buildInfoCard(
      BuildContext context,
      String number,
      String label, {
        required String semanticsLabel,
      }) {
    return Semantics(
      container: true,
      label: semanticsLabel,
      child: CommonCardWidget(
        boxShadow: const [
          BoxShadow(
            color: ColorConstant.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        child: Column(
          children: [
            Text(
              number,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: ColorConstant.textDarkGreyColor,
              ),
            ),
            const SizedBox(height: 8),
            FittedBox(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.materialsAndExams,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: ColorConstant.textDarkGreyColor,
          ),
        ),
        const SizedBox(height: 15),
        _buildFilters(context),
        const SizedBox(height: 20),
        _buildTaskList(context),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final l10n = context.l10n;
    return Obx(() {
      final current = controller.selectedFilter.value;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context,
              l10n.filterAll,
              current == StudentTaskStatus.semua,
                  () => controller.onFilterChanged(StudentTaskStatus.semua),
            ),
            const SizedBox(width: 10),
            _buildFilterChip(
              context,
              l10n.filterMaterial,
              current == StudentTaskStatus.materi,
                  () => controller.onFilterChanged(StudentTaskStatus.materi),
            ),
            const SizedBox(width: 10),
            _buildFilterChip(
              context,
              l10n.filterExam,
              current == StudentTaskStatus.soalUjian,
                  () => controller.onFilterChanged(StudentTaskStatus.soalUjian),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildFilterChip(
      BuildContext context,
      String label,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Filter $label${isSelected ? ", terpilih" : ""}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimens.radius),
          child: Container(
            constraints: const BoxConstraints(
              minHeight: 48,
              minWidth: 48,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              gradient: isSelected
                  ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ColorConstant.linearSecondary,
                  ColorConstant.linearPrimary,
                ],
                stops: [0.2, 1.0],
              )
                  : null,
              borderRadius: BorderRadius.circular(Dimens.radius),
              border: Border.all(
                color: isSelected
                    ? ColorConstant.linearBorder
                    : ColorConstant.grey,
                width: 2,
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.spaceBigPadding,
              vertical: Dimens.innerMediumPadding,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  SvgPicture.asset(
                    SvgConstant.iconCheck,
                    colorFilter: const ColorFilter.mode(
                      ColorConstant.white,
                      BlendMode.srcIn,
                    ),
                    height: Dimens.iconRegularSize,
                    width: Dimens.iconRegularSize,
                  ),
                  const SizedBox(width: Dimens.spaceMediumPadding),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isSelected
                        ? ColorConstant.white
                        : ColorConstant.textDarkGreyColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(BuildContext context) {
    return Obx(() {
      Widget content;

      if (controller.isLoadingTasks.value) {
        content = _buildShimmerLoading();
      } else if (controller.tasksErrorMessage.value.isNotEmpty) {
        content = Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Column(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: ColorConstant.redColor,
                ),
                const SizedBox(height: 12),
                Text(
                  controller.tasksErrorMessage.value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.textDarkGreyColor,
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  button: true,
                  label: context.l10n.tryAgain,
                  child: ElevatedButton(
                    onPressed: controller.onRefresh,
                    child: Text(context.l10n.tryAgain),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        final filter = controller.selectedFilter.value;

        final showModules = filter == StudentTaskStatus.semua ||
            filter == StudentTaskStatus.materi;
        final showExams = filter == StudentTaskStatus.semua ||
            filter == StudentTaskStatus.soalUjian;

        final modules = showModules
            ? controller.taskModules
            : <StudentModuleModel>[];

        final exams = showExams
            ? controller.taskExams
            : <QuizRequestStudentResponse>[];

        final totalItems = modules.length + exams.length;

        if (totalItems == 0) {
          content = Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.menu_book_outlined,
                    size: 48,
                    color: ColorConstant.textGreyColor.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.emptyCategoryTasks,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.textGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          content = ListView.separated(
            itemCount: totalItems,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) =>
            const SizedBox(height: Dimens.spacePadding),
            itemBuilder: (context, index) {
              if (index < modules.length) {
                return _buildModuleCard(context, modules[index]);
              }

              final exam = exams[index - modules.length];
              return _buildExamCard(context, exam);
            },
          );
        }
      }

      if (content is ListView) {
        return content;
      }

      return SizedBox(
        width: double.infinity,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height * 0.25,
          ),
          child: content,
        ),
      );
    });
  }

  Widget _buildExamCard(
      BuildContext context,
      QuizRequestStudentResponse quiz,
      ) {
    final isDone = quiz.progress?.isDone == true;
    final score = quiz.progress?.score;
    final scoreText = score != null ? score.toInt().toString() : '-';

    return Semantics(
      button: true,
      label:
      'Kartu Soal Ujian: ${quiz.title}, Modul: ${quiz.module.title}, Status: ${isDone ? "${context.l10n.completedStatus}, ${context.l10n.score}: $scoreText" : context.l10n.notAttemptedStatus}',
      child: GestureDetector(
        onTap: () async {
          if (isDone) {
            await Get.toNamed(
              Routes.EXAM_REVIEW,
              arguments: quiz,
            );
          } else {
            await Get.toNamed(
              Routes.EXAM_DETAIL,
              arguments: quiz,
            );
          }

          await controller.onRefresh();
        },
        child: CommonCardWidget(
          border: BorderStyleConstant.outlineBorderCard,
          boxShadow: const [BoxShadowConstant.module],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      context.l10n.examQuestions,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: ColorConstant.textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isDone)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstant.lightGreen,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: ColorConstant.green),
                      ),
                      child: Text(
                        '${context.l10n.score}: $scoreText',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorConstant.linearSecondary.withValues(
                            alpha: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          context.l10n.filterNotAttempted,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConstant.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                quiz.title,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorConstant.textDarkGreyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (quiz.module.title.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  quiz.module.title,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ColorConstant.textGreyColor,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.durationAndQuestions(quiz.maxDurationMinutes, quiz.questionCounts),
                      softWrap: true,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstant.textGreyColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            isDone ? context.l10n.examResultEvaluaizer : context.l10n.startTask,
                            softWrap: true,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              color: ColorConstant.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: ColorConstant.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(
      BuildContext context,
      StudentModuleModel module,
      ) {
    final percentage = module.progress?.progressPercentage ?? 0;
    final isDone = module.progress?.isDone ?? false;

    return Semantics(
      button: true,
      label:
      'Kartu Materi: ${module.title}, Progres: $percentage% selesai, Status: ${isDone ? context.l10n.filterDone : context.l10n.filterNotDone}',
      child: GestureDetector(
        onTap: () async {
          await Get.toNamed(
            Routes.MODULE_DETAIL,
            arguments: module.id,
          );

          await controller.onRefresh();
        },
        child: CommonCardWidget(
          border: BorderStyleConstant.outlineBorderCard,
          boxShadow: const [BoxShadowConstant.module],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.material,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ColorConstant.textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isDone)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: ColorConstant.lightGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        context.l10n.filterDone,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                module.title,
                softWrap: true,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: ColorConstant.textDarkGreyColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CommonGradientProgressBarWidget(
                percentage: (percentage.clamp(0, 100)) / 100,
                colors: const [
                  ColorConstant.linearSecondary,
                  ColorConstant.linearPrimary,
                ],
                stops: const [0.2, 1.0],
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage% Selesai',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      children: List.generate(
        3,
            (index) => Padding(
          padding: const EdgeInsets.only(bottom: Dimens.spacePadding),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimens.radius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
