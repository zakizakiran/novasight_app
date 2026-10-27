import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/modules/accessbility/controllers/accessibility_controller.dart';


class TextScaleDialogWidget extends GetView<AccessibilityController> {
  final VoidCallback onBack;

  const TextScaleDialogWidget({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Obx(() {
      final scale = controller.textScale.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.currentSize,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          Semantics(
            liveRegion: true,
            label: l10n.textSizePercent((scale * 100).round()),
            child: Text(
              '${(scale * 100).round()}%',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              IconButton(
                tooltip: l10n.reduceTextSize,
                constraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                onPressed: scale > 0.8
                    ? controller.decreaseTextScale
                    : null,
                icon: const Icon(Icons.remove),
              ),
              Expanded(
                child: Slider(
                  value: scale,
                  min: 0.8,
                  max: 2.0,
                  divisions: 12,
                  label: '${(scale * 100).round()}%',
                  semanticFormatterCallback: (value) =>
                      l10n.textSizePercent((value * 100).round()),
                  onChanged: controller.setTextScale,
                ),
              ),
              IconButton(
                tooltip: l10n.enlargeTextSize,
                constraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                onPressed: scale < 2.0
                    ? controller.increaseTextScale
                    : null,
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.sampleTextTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.sampleTextBody,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: controller.resetTextScale,
            icon: const Icon(Icons.restart_alt),
            label: Text(l10n.resetTextScale),
          ),

          const SizedBox(height: 8),

          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back),
            label: Text(l10n.backToSettings),
          ),
        ],
      );
    });
  }
}
