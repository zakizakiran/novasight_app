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
  const CommonDropdownWidget({
    super.key,
    this.title,
    required this.listValue,
    this.selectedValue,
    required this.onSelect,
    this.initialLabel = "Pilih",
    this.itemLabel
  });

  @override
  State<CommonDropdownWidget<T>> createState() => _CommonDropdownWidgetState<T>();
}

class _CommonDropdownWidgetState<T> extends State<CommonDropdownWidget<T>> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final IconData icon = _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.spacePadding,
      children: [
        if(widget.title != null)
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700
              )
          ),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimens.innerPadding,
              vertical: Dimens.innerMediumPadding
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: ColorConstant.background,
              borderRadius: const BorderRadius.all(Radius.circular(Dimens.radius)),
              border: BoxBorder.all(
                  color: widget.selectedValue != null  && !_isExpanded? ColorConstant.primary : ColorConstant.grey,
                  width: 1.5
              )
          ),
          child: Column(
            children: [
              InkWell(
                onTap: (){
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.selectedValue != null
                            ? widget.itemLabel?.call(widget.selectedValue as T)
                            ?? widget.selectedValue.toString() :
                        widget.initialLabel,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimens.spacePadding,),
                    Icon(
                      icon,
                      color: ColorConstant.black,
                      size: Dimens.iconMediumSize,
                    )
                  ],
                ),
              ),
              if(_isExpanded)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 300
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(color: ColorConstant.grey,height: 0.5,),
                      ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, i){
                            final data = widget.listValue[i];
                            return InkWell(
                              onTap: (){
                                widget.onSelect(data);
                                setState(() {
                                  _isExpanded = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimens.spaceMediumPadding),
                                child: Text(widget.itemLabel?.call(data) ?? data.toString()),
                              ),
                            );
                          },
                          itemCount: widget.listValue.length
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
