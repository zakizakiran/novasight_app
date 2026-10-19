import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/text_scale_dialog_widget.dart';

import '../../../../common/common_dialog_widget.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../accessbility/controllers/accessibility_controller.dart';

class SettingsDialogWidget extends GetView<AccessibilityController> {
  const SettingsDialogWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const SettingsDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final showTextScale = controller.showTextScaleSettings.value;

      return PopScope(
        canPop: !showTextScale,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && showTextScale) {
            controller.backToSettings();
          }
        },
        child: CommonDialogWidget(
          title: showTextScale ? 'Ukuran Teks' : 'Pengaturan',
          description: showTextScale
              ? 'Sesuaikan ukuran teks agar lebih mudah dibaca.'
              : 'Sesuaikan pengaturan aplikasi sesuai kebutuhan Anda.',
          icon: Icon(
            showTextScale ? Icons.text_fields : Icons.settings_outlined,
            size: 40,
            color: ColorConstant.linearPrimary,
          ),
          content: showTextScale
              ? TextScaleDialogWidget(
            onBack: controller.backToSettings,
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SettingsOptionTile(
                icon: Icons.language,
                title: 'Bahasa',
                description: 'Ubah bahasa aplikasi',
                onTap: () {
                  SnackbarHelper.showError(
                    title: "Gagal",
                    message: 'Pengafturan bahasa belum tersedia.',
                  );
                },
              ),
              const SizedBox(height: 12),
              _SettingsOptionTile(
                icon: Icons.text_fields,
                title: 'Ukuran teks',
                description: 'Perbesar atau perkecil teks',
                onTap: controller.openTextScaleSettings,
              ),
            ],
          ),
          actions: TextButton(
            onPressed: controller.backToSettings,
            child: const Text('Tutup'),
          ),
        ),
      );
    });
  }
}

class _SettingsOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SettingsOptionTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      button: true,
      label: title,
      hint: '$description. Ketuk dua kali untuk membuka.',
      onTap: onTap,
      child: ExcludeSemantics(
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(minHeight: 76),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 30,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}