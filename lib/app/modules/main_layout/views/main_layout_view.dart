import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import '../../../core/Dimens.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../controllers/main_layout_controller.dart';
import '../model/bottom_nav_item.dart';

class MainLayoutView extends GetView<MainLayoutController> {
  const MainLayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pages = controller.pages;
      final items = controller.bottomItems;

      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            top: Dimens.spacePadding,
            left: Dimens.spacePadding,
            right: Dimens.spacePadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              ),
            ],
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;

                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: controller.currentIndex.value * itemWidth +
                          (itemWidth - 36) / 2,
                      top: 0,
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: ColorConstant.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: items
                            .mapWithIndex(
                              (item, i) => Expanded(
                            child: _bottomBar(
                              selectedIndex: controller.currentIndex.value,
                              index: i,
                              item: item,
                            ),
                          ),
                        ).toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _bottomBar({
    required int selectedIndex,
    required int index,
    required BottomNavItem item,
  }) {
    final selected = selectedIndex == index;
    String label = selected ? "Posisi di" : "";
    return Semantics(
      button: true,
      label: "$label ${item.semanticLabel}",
      excludeSemantics: true,
      child: InkWell(
        onTap: () => controller.changePage(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                color: selected
                    ? ColorConstant.primary
                    : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight:
                  selected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 12,
                  color: selected
                      ? ColorConstant.primary
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
