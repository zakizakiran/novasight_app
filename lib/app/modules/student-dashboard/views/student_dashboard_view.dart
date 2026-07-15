import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/svg/svg_constant.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/common/common_card_widget.dart';
import 'package:novasight_app/app/data/model/module_model.dart';
import 'package:novasight_app/app/modules/module/views/widgets/module_card_widget.dart';
import 'package:novasight_app/app/routes/app_pages.dart';
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
            height: MediaQuery.sizeOf(context).height / 4,
            width: double.infinity,
            decoration: const BoxDecoration(color: ColorConstant.primary),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat pagi 👋',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: ColorConstant.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fariz',
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(color: ColorConstant.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Matematika • Kelas 10 • SLBN A-CITEUREUP',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: ColorConstant.white),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: ColorConstant.white,
                        child: const Icon(
                          Icons.person,
                          color: ColorConstant.grey,
                        ),
                        // backgroundImage: AssetImage('assets/avatar.png'), // Use image if available
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          '2',
                          'Modul Belum Selesai',
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildInfoCard(
                          context,
                          '2',
                          'Ujian Belum Selesai',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  Text(
                    'Materi dan Soal Ujian',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.textDarkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      _buildFilterChip(context, 'Semua', true),
                      const SizedBox(width: 10),
                      _buildFilterChip(context, 'Materi', false),
                      const SizedBox(width: 10),
                      _buildFilterChip(context, 'Soal Ujian', false),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listModule.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, i) {
                      return ModuleCardWidget(
                        module: listModule[i],
                        onDetail: (module) {
                          Get.toNamed(
                            Routes.MODULE_DETAIL,
                            arguments: module.id,
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: Dimens.spacePadding);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String number, String label) {
    return CommonCardWidget(
      boxShadow: [
        BoxShadow(
          color: ColorConstant.shadowColor,
          blurRadius: 10,
          offset: const Offset(0, 4),
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
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    return Semantics(
      button: true,
      label: 'Filter ',
      child: InkWell(
        onTap: () {
          // Add onTap functionality later if needed
        },
        child: Container(
          decoration: BoxDecoration(
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
          padding: const EdgeInsets.all(Dimens.innerMediumPadding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: Dimens.spaceMediumPadding,
            children: [
              if (isSelected)
                SvgPicture.asset(
                  SvgConstant.iconCheck,
                  colorFilter: const ColorFilter.mode(
                    ColorConstant.white,
                    BlendMode.srcIn,
                  ),
                  height: Dimens.iconRegularSize,
                  width: Dimens.iconRegularSize,
                ),
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
    );
  }
}
