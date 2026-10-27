import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/common_button_widget.dart';
import '../../../core/Dimens.dart';
import '../../../core/constants/math_symbol_repository.dart';
import '../../../core/styles/colors/color_constant.dart';
import '../../../core/utils/l10n_extension.dart';
import '../../../data/models/math_symbol.dart';
import '../controllers/note_controller.dart';

class MathKeyboardWidget extends StatelessWidget {
  const MathKeyboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NoteController>();
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(height: 1, thickness: 1, color: theme.dividerColor),
            _buildTopActionBar(context, controller),
            Obx(() => controller.isAbcMode.value
                ? const SizedBox.shrink()
                : _buildCategoryTabBar(context, controller)),
            Obx(() {
              if (controller.isAbcMode.value) {
                return _buildAbcKeyboardGrid(context, controller);
              }

              switch (controller.activeCategoryTab.value) {
                case 0:
                  return _buildSymbolGrid(context, controller, MathSymbolRepository.basicCategory);
                case 1:
                  return _buildSymbolGrid(context, controller, MathSymbolRepository.functionsCategory);
                case 2:
                  return _buildSymbolGrid(context, controller, MathSymbolRepository.trigCategory);
                case 3:
                  return _buildSymbolGrid(context, controller, MathSymbolRepository.calculusCategory);
                default:
                  return _buildSymbolGrid(context, controller, MathSymbolRepository.basicCategory);
              }
            }),
            Padding(
              padding: const EdgeInsets.all(Dimens.innerPadding),
              child: Semantics(
                button: true,
                label: context.l10n.saveStep,
                child: CommonButtonWidget(
                  buttonName: context.l10n.saveStep,
                  onPressed: controller.saveStep,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopActionBar(BuildContext context, NoteController controller) {
    final theme = Theme.of(context);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => Semantics(
            label: controller.isAbcMode.value ? "Ganti ke keyboard angka & logika" : "Ganti ke keyboard huruf" ,
            button: true,
            excludeSemantics: true,
            child: TextButton(
              onPressed: () => controller.toggleAbcMode(),
              child: Text(
                "abc",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: controller.isAbcMode.value ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ),
          )),
          Semantics(
            label: "Urungkan perubahan",
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.undo, color: Colors.black87),
              onPressed: () => controller.undo(),
            ),
          ),
          Semantics(
            label: "Pindahkan kursor ke kiri",
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => controller.moveCursorLeft(),
            ),
          ),
          Semantics(
            label: "Pindahkan kursor ke kanan",
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.black87),
              onPressed: () => controller.moveCursorRight(),
            ),
          ),
          Semantics(
            label: "Hapus karakter",
            button: true,
            excludeSemantics: true,
            child: IconButton(
              icon: const Icon(Icons.backspace_outlined, color: Colors.black87),
              onPressed: () => controller.deletePrevious(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabBar(BuildContext context, NoteController controller) {
    final categories = [
      "+ -\n× ÷",
      "f(x) e\nlog ln",
      "sin cos\ntan cot",
      "lim dx\n∫ ∑ ∞",
    ];

    final semanticsLabels = [
      "Kategori 1: Aritmatika Dasar",
      "Kategori 2: Fungsi dan Logaritma",
      "Kategori 3: Trigonometri",
      "Kategori 4: Kalkulus dan Limit",
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      color: ColorConstant.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(categories.length, (index) {
          final isSelected = controller.activeCategoryTab.value == index;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Semantics(
                selected: isSelected,
                label: semanticsLabels[index],
                button: true,
                child: InkWell(
                  onTap: () => controller.switchTab(index),
                  borderRadius: BorderRadius.circular(24),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? ColorConstant.primary : Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? ColorConstant.primary : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      categories[index],
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSymbolGrid(
      BuildContext context,
      NoteController controller,
      List<MathSymbol> symbols, {
        int crossAxisCount = 4,
        double keyWidth = 65.0,
        double keyHeight = 50.0,
      }) {
    const double spacing = 1.0;
    final double totalGridHeight = (crossAxisCount * keyHeight) + ((crossAxisCount - 1) * spacing);

    return Container(
      height: totalGridHeight,
      color: Colors.grey.shade200,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: symbols.length,
        semanticChildCount: 0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: keyHeight / keyWidth,
          crossAxisSpacing: spacing,
          mainAxisSpacing: spacing,
        ),
        itemBuilder: (context, index) {
          final symbol = symbols[index];
          return _buildKeyCell(
            context: context,
            symbol: symbol,
            onTap: () => controller.insertSymbol(symbol),
          );
        },
      ),
    );
  }

  Widget _buildKeyCell({
    required BuildContext context,
    required MathSymbol symbol,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: symbol.semanticText,
      button: true,
      excludeSemantics: true,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: ExcludeSemantics(
            child: Center(
              child: _buildVisualKeyContent(context, symbol),
            ),
          )
        ),
      ),
    );
  }

  Widget _buildVisualKeyContent(BuildContext context, MathSymbol symbol) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
    );

    if (symbol.visualLabel.contains('□')) {
      final parts = symbol.visualLabel.split('□');

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            if (parts[i].isNotEmpty) Text(parts[i], style: textStyle),
            if (i < parts.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.0),
                child: DottedBorder(
                  options: RectDottedBorderOptions(
                    color: Colors.black87,
                    strokeWidth: 1.0,
                    dashPattern: [2, 2],
                    padding: EdgeInsets.all(2),
                  ),
                  child: SizedBox(width: 8, height: 10),
                ),
              ),
          ]
        ],
      );
    }

    return Text(symbol.visualLabel, style: textStyle);
  }

  Widget _buildAbcKeyboardGrid(BuildContext context, NoteController controller) {
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildQwertyRow(context, controller, MathSymbolRepository.qwertyRow1),
          const SizedBox(height: 6),
          _buildQwertyRow(context, controller, MathSymbolRepository.qwertyRow2),
          const SizedBox(height: 6),
          _buildQwertyRow(context, controller, MathSymbolRepository.qwertyRow3),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Semantics(
                    label: "Tombol spasi",
                    button: true,
                    child: ElevatedButton(
                      onPressed: () => controller.insertCharacter(" "),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 1,
                      ),
                      child: Text("spasi", style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQwertyRow(BuildContext context, NoteController controller, List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((char) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Semantics(
              label: "Huruf $char",
              button: true,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                elevation: 1,
                child: InkWell(
                  onTap: () => controller.insertCharacter(char),
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: 42,
                    alignment: Alignment.center,
                    child: Text(
                      char,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}