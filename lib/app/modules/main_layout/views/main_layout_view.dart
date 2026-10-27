import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:lydera_app/app/core/utils/l10n_extension.dart';
import 'package:lydera_app/app/core/utils/user_roles.dart';
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
                color: Colors.black.withValues(alpha: .1),
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
                      left:
                          controller.currentIndex.value * itemWidth +
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
                            )
                            .toList(),
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

  String _getItemTitle(BuildContext context, int index) {
    final l10n = context.l10n;
    if (controller.currentRole == UserRoles.siswa) {
      switch (index) {
        case 0:
          return l10n.navDashboard;
        case 1:
          return l10n.navModule;
        case 2:
          return l10n.navExam;
        case 3:
          return l10n.navClarifier;
        case 4:
          return l10n.navProfile;
        default:
          return '';
      }
    } else {
      switch (index) {
        case 0:
          return l10n.navDashboard;
        case 1:
          return l10n.navModule;
        case 2:
          return l10n.navExam;
        case 3:
          return l10n.navProfile;
        default:
          return '';
      }
    }
  }

  Widget _bottomBar({
    required int selectedIndex,
    required int index,
    required BottomNavItem item,
  }) {
    return Builder(
      builder: (context) {
        final selected = selectedIndex == index;
        final title = _getItemTitle(context, index);
        final label = selected
            ? "${context.l10n.currentPosition} $title"
            : title;

        return Semantics(
          button: true,
          label: label,
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
                    color: selected ? ColorConstant.primary : Colors.grey,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title.isNotEmpty ? title : item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 12,
                      color: selected ? ColorConstant.primary : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
