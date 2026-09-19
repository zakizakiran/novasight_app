import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/dimens.dart';
import '../../../../core/styles/colors/color_constant.dart';
import '../../controllers/generate_exam_controller.dart';

class Step1View extends GetView<GenerateExamController> {
  const Step1View({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.innerPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Modul Sumber',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Pilih satu modul untuk dijadikan sumber soal ujian.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstant.textGreyColor,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoadingModules.value &&
                  controller.availableModules.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorConstant.primary,
                  ),
                );
              }

              if (controller.availableModules.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.library_books_outlined,
                        size: 48,
                        color: ColorConstant.textGreyColor,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Belum ada modul yang tersedia.',
                        style: TextStyle(color: ColorConstant.textGreyColor),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => controller.loadModules(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorConstant.primary,
                          foregroundColor: ColorConstant.white,
                        ),
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                );
              }

              final currentSelectedId = controller.selectedModuleId.value;

              return ListView.separated(
                itemCount: controller.availableModules.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final module = controller.availableModules[index];
                  bool isSelected = currentSelectedId == module.id;

                  final dateStr =
                      DateFormat('dd MMM yyyy').format(module.createdAt);

                  return GestureDetector(
                    onTap: () => controller.selectModule(module),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorConstant.primary.withValues(alpha: 0.05)
                            : ColorConstant.white,
                        borderRadius: BorderRadius.circular(Dimens.radius),
                        border: Border.all(
                          color: isSelected
                              ? ColorConstant.primary
                              : ColorConstant.grey.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? []
                            : [
                                BoxShadow(
                                  color: ColorConstant.shadowColor.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? ColorConstant.primary
                                  : ColorConstant.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.description,
                              color: isSelected
                                  ? ColorConstant.white
                                  : ColorConstant.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? ColorConstant.primary
                                            : ColorConstant.textDarkGreyColor,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Dibuat: $dateStr',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: ColorConstant.textGreyColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: ColorConstant.primary,
                            ),
                          if (!isSelected)
                            Icon(
                              Icons.circle_outlined,
                              color: ColorConstant.grey.withValues(alpha: 0.5),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
