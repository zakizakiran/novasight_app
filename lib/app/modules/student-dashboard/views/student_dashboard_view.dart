import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/common/common_gradient_progress_bar_widget.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/border_style.dart';
import 'package:novasight_app/app/core/styles/box_shadow_style.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/data/models/student_model.dart';
import 'package:novasight_app/app/data/models/student_quiz_model.dart';
import 'package:novasight_app/app/routes/app_pages.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/student_dashboard_controller.dart';

class StudentDashboardView extends GetView<StudentDashboardController> {
  const StudentDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 3.5,
            width: double.infinity,
            decoration: const BoxDecoration(color: ColorConstant.primary),
          ),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.onRefresh,
              color: ColorConstant.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 20),
                    _buildMetricCards(context),
                    const SizedBox(height: 30),
                    _buildTasksSection(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Obx(() {
      final name = controller.studentName.value.isNotEmpty
          ? controller.studentName.value
          : 'Siswa';
      final subtitle = controller.classroomSubtitle.value.isNotEmpty
          ? controller.classroomSubtitle.value
          : 'Memuat data kelas...';

      return Semantics(
        container: true,
        label: 'Informasi Profil Siswa: $name, $subtitle',
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat belajar 👋',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorConstant.white.withValues(alpha: 0.9),
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: ColorConstant.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
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
              'Modul Belum Selesai',
              semanticsLabel: '$modulesCount Modul Belum Selesai',
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildInfoCard(
              context,
              examCount,
              'Ujian Belum Selesai',
              semanticsLabel: '$examCount Ujian Belum Selesai',
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
              fit: BoxFit.scaleDown,
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
          'Materi dan Soal Ujian',
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
    return Obx(() {
      final current = controller.selectedFilter.value;
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              context,
              'Semua',
              current == StudentTaskStatus.semua,
              () => controller.onFilterChanged(StudentTaskStatus.semua),
            ),
            const SizedBox(width: 10),
            _buildFilterChip(
              context,
              'Materi',
              current == StudentTaskStatus.materi,
              () => controller.onFilterChanged(StudentTaskStatus.materi),
            ),
            const SizedBox(width: 10),
            _buildFilterChip(
              context,
              'Soal Ujian',
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
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
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
      if (controller.isLoadingTasks.value) {
        return _buildShimmerLoading();
      }

      if (controller.tasksErrorMessage.value.isNotEmpty) {
        return Center(
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
                  label: 'Coba lagi memuat tugas',
                  child: ElevatedButton(
                    onPressed: controller.onRefresh,
                    child: const Text('Coba Lagi'),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      final filter = controller.selectedFilter.value;
      final showModules =
          filter == StudentTaskStatus.semua || filter == StudentTaskStatus.materi;
      final showExams = filter == StudentTaskStatus.semua ||
          filter == StudentTaskStatus.soalUjian;

      final modules = showModules ? controller.taskModules : <StudentModuleModel>[];
      final exams =
          showExams ? controller.taskExams : <QuizRequestStudentResponse>[];

      final totalItems = modules.length + exams.length;
      if (totalItems == 0) {
        return Center(
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
                  'Belum ada materi atau soal ujian pada kategori ini.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                      ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: totalItems,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) =>
            const SizedBox(height: Dimens.spacePadding),
        itemBuilder: (context, index) {
          if (index < modules.length) {
            final module = modules[index];
            return _buildModuleCard(context, module);
          } else {
            final exam = exams[index - modules.length];
            return _buildExamCard(context, exam);
          }
        },
      );
    });
  }

  Widget _buildExamCard(BuildContext context, QuizRequestStudentResponse quiz) {
    final isDone = quiz.progress?.isDone == true;
    final score = quiz.progress?.score;
    final scoreText = score != null ? score.toInt().toString() : '-';

    return Semantics(
      button: true,
      label:
          'Kartu Soal Ujian: ${quiz.title}, Modul: ${quiz.module.title}, Status: ${isDone ? "Selesai dikerjakan, Nilai: $scoreText" : "Belum dikerjakan"}',
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
                  Text(
                    'Soal Ujian',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: ColorConstant.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
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
                        'Nilai: $scoreText',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstant.green,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            ColorConstant.linearSecondary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Belum Dikerjakan',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstant.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                quiz.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: ColorConstant.textDarkGreyColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (quiz.module.title.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  quiz.module.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: ColorConstant.textGreyColor,
                      ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${quiz.maxDurationMinutes} Menit • ${quiz.questionCounts} Soal',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isDone ? 'Evaluaizer (Hasil Ujian)' : 'Kerjakan',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: ColorConstant.primary,
                              fontWeight: FontWeight.bold,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context, StudentModuleModel module) {
    final percentage = module.progress?.progressPercentage ?? 0;
    final isDone = module.progress?.isDone ?? false;

    return Semantics(
      button: true,
      label:
          'Kartu Materi: ${module.title}, Progres: $percentage% selesai, Status: ${isDone ? "Selesai" : "Belum Selesai"}',
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
                    'Materi',
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
                        'Selesai',
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
