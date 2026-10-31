import 'package:flutter/material.dart';

class CommonSwitchWidget<T> extends StatelessWidget {
  final T selectedValue;
  final List<T> values;
  final ValueChanged<T> onChanged;
  final String Function(T value) labelBuilder;

  final double height;
  final Duration animationDuration;
  final Color backgroundColor;
  final Color selectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final BorderRadius borderRadius;
  final TextStyle? textStyle;

  const CommonSwitchWidget({
    super.key,
    required this.selectedValue,
    required this.values,
    required this.onChanged,
    required this.labelBuilder,
    this.height = 50,
    this.animationDuration = const Duration(milliseconds: 250),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.selectedColor = const Color(0xFF2196F3),
    this.selectedTextColor = Colors.white,
    this.unselectedTextColor = Colors.black54,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(12),
    ),
    this.textStyle,
  }) : assert(values.length >= 2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedIndex = values.indexOf(selectedValue);

    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = constraints.maxWidth / values.length;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: animationDuration,
                curve: Curves.easeInOut,
                left: selectedIndex < 0
                    ? 0
                    : selectedIndex * itemWidth,
                top: 0,
                bottom: 0,
                width: itemWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: selectedColor,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
              Row(
                children: [
                  for (final value in values)
                    Expanded(
                      child: _buildItem(
                        context: context,
                        value: value,
                        theme: theme,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem({
    required BuildContext context,
    required T value,
    required ThemeData theme,
  }) {
    final isSelected = value == selectedValue;
    final label = labelBuilder(value);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => onChanged(value),
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: animationDuration,
            curve: Curves.easeInOut,
            style: (textStyle ?? theme.textTheme.titleMedium!).copyWith(
              fontWeight: isSelected
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: isSelected
                  ? selectedTextColor
                  : unselectedTextColor,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
