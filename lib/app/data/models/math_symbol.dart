import 'package:get/get.dart';

enum MathSymbolType {
  text,
  number,
  operator,

  function,

  parens,
  fraction,
  root,
  power,
  subscript,

  integral,
  derivative,
  limit,
  summation,
}

class MathSymbol {
  final String id;
  final String visualLabel;
  final String renderSyntax;
  final String semanticText;
  final MathSymbolType type;

  /// Number of editable slots this symbol has.
  final int slotCount;

  const MathSymbol({
    required this.id,
    required this.visualLabel,
    required this.renderSyntax,
    required this.semanticText,
    this.type = MathSymbolType.text,
    this.slotCount = 0,
  });
}

class MathNode {
  final MathSymbol symbol;
  final List<MathSlot> slots;
  MathSlot? parentSlot;

  MathNode({
    required this.symbol,
    this.parentSlot,
    List<MathSlot>? slots,
  }) : slots = slots ?? _buildSlots(symbol) {
    for (var slot in this.slots) {
      slot.parentNode = this;
    }
  }

  MathNode copy({MathSlot? parentSlot}) {
    final copiedNode = MathNode(
      symbol: symbol,
      parentSlot: parentSlot,
      slots: [],
    );

    copiedNode.slots.addAll(
      slots.map(
            (slot) => slot.copy(parentNode: copiedNode),
      ),
    );

    return copiedNode;
  }

  static List<MathSlot> _buildSlots(MathSymbol symbol) {
    switch (symbol.type) {
      case MathSymbolType.fraction:
        return [
          MathSlot(label: 'Pembilang'),
          MathSlot(label: 'Penyebut'),
        ];

      case MathSymbolType.root:
        if (symbol.slotCount == 2) {
          return [
            MathSlot(label: 'Pangkat'),
            MathSlot(label: 'Isi Akar'),
          ];
        }

        return [
          MathSlot(label: 'Isi Akar'),
        ];

      case MathSymbolType.power:
        return [
          MathSlot(label: 'Basis'),
          MathSlot(label: 'Pangkat'),
        ];

      case MathSymbolType.subscript:
        return [
          MathSlot(label: 'Basis'),
          MathSlot(label: 'Indeks'),
        ];

      case MathSymbolType.parens:
        return [
          MathSlot(label: 'Isi Kurung'),
        ];

      case MathSymbolType.function:
        return List.generate(
          symbol.slotCount,
              (i) => MathSlot(
            label: symbol.slotCount == 1
                ? 'Argumen'
                : 'Argumen ${i + 1}',
          ),
        );

      case MathSymbolType.limit:
        return [
          MathSlot(label: 'Variabel'),
          MathSlot(label: 'Nilai Pendekatan'),
          MathSlot(label: 'Isi Limit'),
        ];

      case MathSymbolType.integral:
        if (symbol.slotCount == 3) {
          return [
            MathSlot(label: 'Batas Bawah'),
            MathSlot(label: 'Batas Atas'),
            MathSlot(label: 'Integran'),
          ];
        }

        return [
          MathSlot(label: 'Integran'),
        ];

      case MathSymbolType.derivative:
        return [
          MathSlot(label: 'Variabel'),
          MathSlot(label: 'Fungsi'),
        ];

      case MathSymbolType.summation:
        return [
          MathSlot(label: 'Variabel'),
          MathSlot(label: 'Nilai Awal'),
          MathSlot(label: 'Nilai Akhir'),
          MathSlot(label: 'Suku'),
        ];

      default:
        return List.generate(
          symbol.slotCount,
              (i) => MathSlot(label: 'Slot ${i + 1}'),
        );
    }
  }
}

class MathSlot {
  final String label;
  final RxList<MathNode> children = <MathNode>[].obs;
  final RxInt cursorIndex = 0.obs;
  MathNode? parentNode;

  MathSlot({required this.label, this.parentNode});
  MathSlot copy({MathNode? parentNode}) {
    final copiedSlot = MathSlot(
      label: label,
      parentNode: parentNode,
    );

    copiedSlot.children.addAll(
      children.map(
            (child) => child.copy(parentSlot: copiedSlot),
      ),
    );

    copiedSlot.cursorIndex.value = cursorIndex.value;

    return copiedSlot;
  }
}
