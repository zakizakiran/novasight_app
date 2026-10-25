import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
import 'package:novasight_app/app/core/utils/l10n_extension.dart';
import 'package:novasight_app/app/modules/accessbility/controllers/accessibility_controller.dart';

class LanguageDialogWidget extends GetView<AccessibilityController> {
  final VoidCallback onBack;

  const LanguageDialogWidget({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Obx(() {
      final currentCode = controller.locale.value.languageCode;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LanguageOptionTile(
            title: l10n.indonesian,
            subtitle: 'Bahasa Indonesia',
            isSelected: currentCode == 'id',
            onTap: () => controller.changeLanguage(const Locale('id', 'ID')),
          ),
          const SizedBox(height: 10),
          _LanguageOptionTile(
            title: l10n.english,
            subtitle: 'English (US)',
            isSelected: currentCode == 'en',
            onTap: () => controller.changeLanguage(const Locale('en', 'US')),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: Text(l10n.back),
          ),
        ],
      );
    });
  }
}

class _LanguageOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOptionTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      container: true,
      button: true,
      selected: isSelected,
      label: '$title, $subtitle',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? ColorConstant.primary.withValues(alpha: 0.08)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? ColorConstant.primary : theme.colorScheme.outline,
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: isSelected ? ColorConstant.primary : theme.colorScheme.outline,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? ColorConstant.primary
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check,
                  color: ColorConstant.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
