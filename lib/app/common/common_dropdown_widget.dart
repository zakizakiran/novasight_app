import 'package:flutter/material.dart';
import 'package:novasight_app/app/core/Dimens.dart';
import 'package:novasight_app/app/core/styles/colors/color_constant.dart';
class CommonDropdownWidget<T> extends StatefulWidget {
  final List<T> listValue;
  final T? selectedValue;
  final String initialLabel;
  final String? title;
  final Function(T data) onSelect;
  final String Function(T)? itemLabel;
  final bool isEnabled;

  const CommonDropdownWidget({
    super.key,
    this.title,
    required this.listValue,
    this.selectedValue,
    required this.onSelect,
    this.initialLabel = "Pilih",
    this.itemLabel,
    this.isEnabled = true,
  });

  @override
  State<CommonDropdownWidget<T>> createState() => _CommonDropdownWidgetState<T>();
}

class _CommonDropdownWidgetState<T> extends State<CommonDropdownWidget<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final IconData icon = _isExpanded
        ? Icons.keyboard_arrow_up_rounded
        : Icons.keyboard_arrow_down_rounded;
    final bool enabled = widget.isEnabled;

    final String displayText = widget.selectedValue != null
        ? (widget.itemLabel?.call(widget.selectedValue as T) ??
            widget.selectedValue.toString())
        : widget.initialLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.spacePadding,
      children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: enabled ? null : ColorConstant.textGreyColor,
                ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.innerPadding,
            vertical: Dimens.innerMediumPadding,
          ),
          width: double.infinity,
          decoration: BoxDecoration(
            color: enabled ? ColorConstant.background : ColorConstant.grey.withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
            border: BoxBorder.all(
              color: !enabled
                  ? ColorConstant.grey.withOpacity(0.5)
                  : (widget.selectedValue != null && !_isExpanded
                      ? ColorConstant.primary
                      : ColorConstant.grey),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Semantics(
                button: true,
                enabled: enabled,
                label: "${widget.title ?? 'Pilihan'}: $displayText",
                child: InkWell(
                  onTap: enabled
                      ? () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        }
                      : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          displayText,
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: enabled
                                    ? (widget.selectedValue != null
                                        ? ColorConstant.black
                                        : ColorConstant.textGreyColor)
                                    : ColorConstant.textGreyColor,
                              ),
                        ),
                      ),
                      const SizedBox(width: Dimens.spacePadding),
                      Icon(
                        icon,
                        color: enabled ? ColorConstant.black : ColorConstant.textGreyColor,
                        size: Dimens.iconMediumSize,
                      ),
                    ],
                  ),
                ),
              ),
              if (_isExpanded && enabled)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(color: ColorConstant.grey, height: 0.5),
                      if (widget.listValue.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimens.spaceMediumPadding,
                          ),
                          child: Text(
                            "Tidak ada pilihan tersedia",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ColorConstant.textGreyColor,
                                ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: widget.listValue.length,
                          itemBuilder: (context, i) {
                            final data = widget.listValue[i];
                            final String label = widget.itemLabel?.call(data) ?? data.toString();
                            return Semantics(
                              button: true,
                              label: "Pilih $label",
                              child: InkWell(
                                onTap: () {
                                  widget.onSelect(data);
                                  setState(() {
                                    _isExpanded = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: Dimens.spaceMediumPadding,
                                  ),
                                  child: Text(label),
                                ),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
