import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/date_helper.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import '../../../common/common_card_widget.dart';
import '../../../core/dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../controllers/teacher_dashboard_controller.dart';

class TeacherDashboardView extends GetView<TeacherDashboardController> {

  const TeacherDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 230 + MediaQuery.of(context).padding.top,
                      decoration: const BoxDecoration(
                        color: ColorConstant.primary,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).padding.top + 20,
                        ),
                        _buildHeaderContent(context),
                        const SizedBox(height: 24),
                        _buildStatsRow(context),
                        const SizedBox(height: 16),
                        _buildClassCodeCard(context),
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                          context,
                          context.l10n.newestModules,
                          context.l10n.seeAll,
                          onActionTap: () => controller.onSeeAllModule(),
                        ),
                        _buildModuleList(context),
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                          context,
                          context.l10n.newestExams,
                          context.l10n.seeAll,
                          onActionTap: () => controller.onSeeAllExam()
                        ),
                        _buildExamList(context),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.greetingMorning,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorConstant.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.teacherName.value.isNotEmpty
                        ? controller.teacherName.value
                        : l10n.teacher,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: ColorConstant.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    controller.classSubtitle.value.isNotEmpty
                        ? controller.classSubtitle.value
                        : (controller.className.value.isNotEmpty
                            ? controller.className.value
                            : l10n.teacherDashboard),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: ColorConstant.white.withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 32,
            backgroundColor: ColorConstant.white,
            child: Icon(Icons.person, size: 40, color: ColorConstant.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Obx(() {
        final isLoading = controller.isLoadingDashboard.value;
        final data = controller.dashboardData.value;
        final totalModules =
            isLoading && data == null ? '-' : (data?.totalModules.toString() ?? '0');
        final totalExams =
            isLoading && data == null ? '-' : (data?.totalExams.toString() ?? '0');
        final totalStudents =
            isLoading && data == null ? '-' : (data?.totalStudents.toString() ?? '0');

        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                Icons.menu_book,
                totalModules,
                l10n.totalModules,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                Icons.assignment,
                totalExams,
                l10n.examQuestions,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                Icons.group,
                totalStudents,
                l10n.totalStudents,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String count,
    String label,
  ) {
    return Semantics(
      label: '$label: $count',
      child: CommonCardWidget(
        boxShadow: const [
          BoxShadow(
            color: ColorConstant.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: ColorConstant.primary),
            const SizedBox(height: 8),
            Text(
              count,
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstant.textGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCodeCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(Dimens.radius),
          border: Border.all(
            color: ColorConstant.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimens.radius),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 6,
                  decoration: const BoxDecoration(
                    color: ColorConstant.primary,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.radius),
                      bottomLeft: Radius.circular(Dimens.radius),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimens.innerPadding),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: ColorConstant.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(
                                  Dimens.radius,
                                ),
                              ),
                              child: const Icon(
                                Icons.key,
                                size: 28,
                                color: ColorConstant.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.l10n.classCode,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: ColorConstant.textGreyColor,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(
                                    () => Text(
                                      controller.classCode.value.isNotEmpty
                                          ? controller.classCode.value
                                          : (controller.isLoadingClassroom.value
                                              ? context.l10n.loading
                                              : context.l10n.noClassYet),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge
                                          ?.copyWith(
                                            color: ColorConstant.primary,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    context.l10n.shareCodeDescription,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: ColorConstant.textGreyColor,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Material(
                            color: ColorConstant.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              Dimens.radiusMedium,
                            ),
                            child: Semantics(
                              button: true,
                              label: context.l10n.copyClassCode,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(
                                  Dimens.radiusMedium,
                                ),
                                onTap: () => controller.onCopyClassCode(),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.copy,
                                        size: 18,
                                        color: ColorConstant.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        context.l10n.copyClassCode,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(
                                              color: ColorConstant.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    String title,
    String actionText, {
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorConstant.textDarkGreyColor,
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: ColorConstant.primary),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return DateHelper.dateFormat(dt);
  }

  Widget _buildModuleList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Obx(() {
        if (controller.isLoadingDashboard.value &&
            controller.dashboardData.value == null) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: ColorConstant.primary,
              ),
            ),
          );
        }

        final modules = controller.dashboardData.value?.newestModules ?? [];
        if (modules.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CommonCardWidget(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    context.l10n.noModulesCreated,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: modules.map((module) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildModuleItem(
                context,
                module.title,
                _formatDate(module.createdAt),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget _buildModuleItem(BuildContext context, String title, String subtitle) {
    return Semantics(
      label: 'Modul: $title, Dibuat: $subtitle',
      child: CommonCardWidget(
        boxShadow: const [
          BoxShadow(
            color: ColorConstant.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorConstant.background,
                borderRadius: BorderRadius.circular(Dimens.radius),
              ),
              child: const Icon(
                Icons.description,
                size: 28,
                color: ColorConstant.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.informationColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConstant.textGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExamList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Obx(() {
        final exams = controller.dashboardData.value?.newestExams ?? [];
        if (exams.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 12),
            child: CommonCardWidget(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    context.l10n.noRecentExams,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConstant.textGreyColor,
                        ),
                  ),
                ),
              ),
            ),
          );
        }

        return Column(
          children: exams.map((exam) {
            final title = exam is Map ? exam['title']?.toString() ?? 'Ujian' : 'Ujian';
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Semantics(
                label: 'Soal Ujian: $title',
                child: CommonCardWidget(
                  boxShadow: const [
                    BoxShadow(
                      color: ColorConstant.shadowColor,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.informationColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}
