import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/language_dialog_widget.dart';
import 'package:novasight_app/app/modules/profile/views/widgets/text_scale_dialog_widget.dart';

import '../../../../common/common_dialog_widget.dart';
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
      final showLanguage = controller.showLanguageSettings.value;
      final isSubView = showTextScale || showLanguage;
      final l10n = context.l10n;

      String title = l10n.settings;
      String description = l10n.settingsDescription;
      IconData icon = Icons.settings_outlined;

      if (showTextScale) {
        title = l10n.textSize;
        description = l10n.textSizeAdjustDescription;
        icon = Icons.text_fields;
      } else if (showLanguage) {
        title = l10n.selectLanguage;
        description = l10n.selectLanguageDescription;
        icon = Icons.language;
      }

      Widget content;
      if (showTextScale) {
        content = TextScaleDialogWidget(
          onBack: controller.backToSettings,
        );
      } else if (showLanguage) {
        content = LanguageDialogWidget(
          onBack: controller.backToSettings,
        );
      } else {
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SettingsOptionTile(
              icon: Icons.language,
              title: l10n.language,
              description: l10n.languageDescription,
              onTap: controller.openLanguageSettings,
            ),
            const SizedBox(height: 12),
            _SettingsOptionTile(
              icon: Icons.text_fields,
              title: l10n.textSize,
              description: l10n.textSizeDescription,
              onTap: controller.openTextScaleSettings,
            ),
          ],
        );
      }

      return PopScope(
        canPop: !isSubView,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && isSubView) {
            controller.backToSettings();
          }
        },
        child: CommonDialogWidget(
          title: title,
          description: description,
          icon: Icon(
            icon,
            size: 40,
            color: ColorConstant.linearPrimary,
          ),
          content: content,
          actions: TextButton(
            onPressed: controller.backToSettings,
            child: Text(l10n.close),
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