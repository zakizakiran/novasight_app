import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../common/common_card_widget.dart';
import '../../../core/dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../routes/app_pages.dart';
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
                          'Modul Terbaru',
                          'Lihat semua',
                          onActionTap: () => controller.onSeeAllModule(),
                        ),
                        _buildModuleList(context),
                        const SizedBox(height: 24),
                        _buildSectionTitle(
                          context,
                          'Soal Ujian Terbaru',
                          'Lihat semua',
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
                  'Selamat pagi',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorConstant.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Bayu',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: ColorConstant.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Matematika - SLBN A-CITEUREUP',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ColorConstant.white.withValues(alpha: 0.9),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(context, Icons.menu_book, '2', 'Total Modul'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(context, Icons.assignment, '1', 'Soal Ujian'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(context, Icons.group, '34', 'Total Siswa'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String count,
    String label,
  ) {
    return CommonCardWidget(
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
                                    'Kode Kelas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: ColorConstant.textGreyColor,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'NSG-4821',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(
                                          color: ColorConstant.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bagikan ke siswa agar bisa bergabung',
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
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                Dimens.radiusMedium,
                              ),
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(text: 'NSG-4821'),
                                );
                                Get.snackbar(
                                  'Berhasil',
                                  'Kode kelas berhasil disalin',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: ColorConstant.green,
                                  colorText: ColorConstant.white,
                                  margin: const EdgeInsets.all(
                                    Dimens.innerPadding,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Salin Kode',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: ColorConstant.primary,
                                        fontWeight: FontWeight.bold,
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

  Widget _buildModuleList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildModuleItem(
            context,
            'BAB 1 : Eksponen dan Logaritma',
            'Kelas 10 · 7 Jun 2026',
          ),
          const SizedBox(height: 12),
          _buildModuleItem(
            context,
            'Persamaan Kuadrat',
            'Kelas 11 · 14 Jun 2026',
          ),
        ],
      ),
    );
  }

  Widget _buildModuleItem(BuildContext context, String title, String subtitle) {
    return CommonCardWidget(
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
    );
  }

  Widget _buildExamList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Column(
        children: [
          const SizedBox(height: 12),
          CommonCardWidget(
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
                        'UTS Kelas X',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.informationColor,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '5 soal · BAB 1: Eksponen dan Logaritma',
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
        ],
      ),
    );
  }
}
