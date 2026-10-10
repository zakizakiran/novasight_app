import '../../data/models/math_symbol.dart';
import 'indonesian_number_to_word.dart';

class MathSemanticSerializer {

  String serializeNodes(List<MathNode> nodes) {
    return _serializeSequence(nodes);
  }

  String serializeNode(MathNode node) {
    switch (node.symbol.type) {
      case MathSymbolType.fraction:
        return _serializeFraction(node);

      case MathSymbolType.root:
        return _serializeRoot(node);

      case MathSymbolType.power:
        return _serializePower(node);

      case MathSymbolType.subscript:
        return _serializeSubscript(node);

      case MathSymbolType.parens:
        return _serializeParentheses(node);

      case MathSymbolType.function:
        return _serializeFunction(node);

      case MathSymbolType.limit:
        return _serializeLimit(node);

      case MathSymbolType.integral:
        return _serializeIntegral(node);

      case MathSymbolType.derivative:
        return _serializeDerivative(node);

      case MathSymbolType.summation:
        return _serializeSummation(node);

      case MathSymbolType.text:
      case MathSymbolType.number:
      case MathSymbolType.operator:
      default:
        return node.symbol.semanticText;
    }
  }

  String serializeSlot(MathSlot slot) {
    return _serializeSequence(slot.children);
  }

  String _serializeSequence(List<MathNode> nodes) {
    final parts = <String>[];
    var index = 0;

    while (index < nodes.length) {
      if (nodes[index].symbol.type == MathSymbolType.number) {
        final digits = StringBuffer();

        while (index < nodes.length &&
            nodes[index].symbol.type == MathSymbolType.number) {
          final digit = _extractNumber(nodes[index]);

          if (digit == null) {
            break;
          }

          digits.write(digit);
          index++;
        }

        if (digits.isNotEmpty) {
          final rawNumber = digits.toString();
          final number = int.tryParse(rawNumber);

          if (number != null && !rawNumber.startsWith('0')) {
            parts.add(IndonesianNumberToWords.convert(number));
          } else {
            parts.addAll(rawNumber.split('').map(
                  (digit) => IndonesianNumberToWords.convert(int.parse(digit)),
            ));
          }

          continue;
        }
      }

      parts.add(serializeNode(nodes[index]));
      index++;
    }

    return parts.where((text) => text.isNotEmpty).join(' ');
  }

  String? _extractNumber(MathNode node) {
    final candidates = [
      node.symbol.renderSyntax,
      node.symbol.visualLabel,
      node.symbol.semanticText,
    ];

    for (final candidate in candidates) {
      final value = candidate.trim();

      if (RegExp(r'^\d+$').hasMatch(value)) {
        return value;
      }

      final match = RegExp(r'\d+').firstMatch(value);

      if (match != null) {
        return match.group(0);
      }
    }

    return null;
  }

  String _serializeFraction(MathNode node) {
    if (node.slots.length < 2) {
      return '';
    }

    final numerator = serializeSlot(node.slots[0]);
    final denominator = serializeSlot(node.slots[1]);

    if (numerator.isEmpty && denominator.isEmpty) {
      return 'pecahan kosong';
    }

    if (numerator.isEmpty) {
      return 'pecahan dengan pembilang kosong dan penyebut $denominator';
    }

    if (denominator.isEmpty) {
      return 'pecahan dengan pembilang $numerator dan penyebut kosong';
    }

    return 'pecahan dengan pembilang $numerator '
        'dan penyebut $denominator';
  }

  String _serializeRoot(MathNode node) {
    if (node.slots.length == 1) {
      final content = serializeSlot(node.slots[0]);

      if (content.isEmpty) {
        return 'akar kuadrat kosong';
      }

      return 'akar kuadrat dari $content';
    }

    if (node.slots.length == 2) {
      final index = serializeSlot(node.slots[0]);
      final content = serializeSlot(node.slots[1]);

      if (index.isEmpty && content.isEmpty) {
        return 'akar pangkat kosong';
      }

      if (index.isEmpty) {
        return 'akar pangkat dari $content';
      }

      if (content.isEmpty) {
        return 'akar pangkat $index dari kosong';
      }

      return 'akar pangkat $index dari $content';
    }

    return '';
  }

  String _serializePower(MathNode node) {
    if (node.slots.length < 2) {
      return '';
    }

    final base = serializeSlot(node.slots[0]);
    final exponent = serializeSlot(node.slots[1]);

    if (base.isEmpty) {
      return '';
    }

    if (exponent.isEmpty) {
      return base;
    }

    return '$base pangkat $exponent';
  }

  String _serializeSubscript(MathNode node) {
    if (node.slots.length < 2) {
      return '';
    }

    final base = serializeSlot(node.slots[0]);
    final index = serializeSlot(node.slots[1]);

    if (base.isEmpty) {
      return '';
    }

    if (index.isEmpty) {
      return base;
    }

    return '$base indeks $index';
  }

  String _serializeParentheses(MathNode node) {
    if (node.slots.isEmpty) {
      return 'kurung kosong';
    }

    final content = serializeSlot(node.slots[0]);

    if (content.isEmpty) {
      return 'kurung kosong';
    }

    return 'kurung buka $content kurung tutup';
  }

  String _serializeFunction(MathNode node) {
    final functionName = _functionSemanticName(node.symbol.id);

    if (node.slots.isEmpty) {
      return functionName;
    }

    final arguments = node.slots
        .map(serializeSlot)
        .where((text) => text.isNotEmpty)
        .toList();

    if (arguments.isEmpty) {
      return functionName;
    }

    if (arguments.length == 1) {
      return '$functionName dari ${arguments[0]}';
    }

    return '$functionName dengan argumen ${arguments.join(' dan ')}';
  }

  String _functionSemanticName(String id) {
    switch (id) {
      case 'sin':
        return 'sinus';

      case 'cos':
        return 'cosinus';

      case 'tan':
        return 'tangen';

      case 'cot':
        return 'kotangen';

      case 'sec':
        return 'sekan';

      case 'csc':
        return 'kosekan';

      case 'arcsin':
        return 'arkus sinus';

      case 'arccos':
        return 'arkus cosinus';

      case 'arctan':
        return 'arkus tangen';

      case 'arccot':
        return 'arkus kotangen';

      case 'arcsec':
        return 'arkus sekan';

      case 'arccsc':
        return 'arkus kosekan';

      case 'sinh':
        return 'sinus hiperbolik';

      case 'cosh':
        return 'cosinus hiperbolik';

      case 'tanh':
        return 'tangen hiperbolik';

      case 'coth':
        return 'kotangen hiperbolik';

      case 'ln':
        return 'logaritma natural';

      case 'log':
      case 'log10':
        return 'logaritma';

      case 'exp':
        return 'eksponensial';

      case 'sign':
        return 'fungsi tanda';

      default:
        return id;
    }
  }

  String _serializeLimit(MathNode node) {
    if (node.slots.length < 3) {
      return '';
    }

    final variable = serializeSlot(node.slots[0]);
    final approach = serializeSlot(node.slots[1]);
    final content = serializeSlot(node.slots[2]);

    if (variable.isEmpty && approach.isEmpty && content.isEmpty) {
      return 'limit kosong';
    }

    final limitTarget = variable.isEmpty ? 'variabel' : variable;
    final approachTarget =
    approach.isEmpty ? 'nilai yang tidak ditentukan' : approach;

    if (content.isEmpty) {
      return 'limit saat $limitTarget mendekati $approachTarget';
    }

    return 'limit dari $content saat '
        '$limitTarget mendekati $approachTarget';
  }

  String _serializeIntegral(MathNode node) {
    if (node.slots.length == 1) {
      final integrand = serializeSlot(node.slots[0]);

      if (integrand.isEmpty) {
        return 'integral kosong';
      }

      return 'integral dari $integrand';
    }

    if (node.slots.length == 3) {
      final lower = serializeSlot(node.slots[0]);
      final upper = serializeSlot(node.slots[1]);
      final integrand = serializeSlot(node.slots[2]);

      if (lower.isEmpty && upper.isEmpty && integrand.isEmpty) {
        return 'integral tentu kosong';
      }

      return 'integral dari $lower sampai $upper '
          'dari $integrand';
    }

    return '';
  }

  String _serializeDerivative(MathNode node) {
    final arguments = node.slots
        .map(serializeSlot)
        .where((text) => text.isNotEmpty)
        .toList();

    switch (node.symbol.id) {
      case 'ddx':
        if (arguments.isEmpty) {
          return 'turunan terhadap x';
        }

        return 'turunan terhadap x dari ${arguments.join(' ')}';

      case 'dydx':
        if (arguments.isEmpty) {
          return 'turunan y terhadap x';
        }

        return 'turunan y terhadap x dari ${arguments.join(' ')}';

      case 'd_dvar':
        if (arguments.length >= 2) {
          return 'turunan terhadap ${arguments[0]} '
              'dari ${arguments[1]}';
        }

        return 'turunan';

      case 'd2_dx2':
        if (arguments.isEmpty) {
          return 'turunan kedua terhadap x';
        }

        return 'turunan kedua terhadap x dari ${arguments.join(' ')}';

      case 'y_prime':
        if (arguments.isEmpty) {
          return 'y aksen';
        }

        return 'turunan dari ${arguments.join(' ')}';

      case 'y_double_prime':
        if (arguments.isEmpty) {
          return 'y aksen dua';
        }

        return 'turunan kedua dari ${arguments.join(' ')}';

      default:
        if (arguments.isEmpty) {
          return node.symbol.semanticText;
        }

        return '${node.symbol.semanticText} ${arguments.join(' ')}';
    }
  }

  String _serializeSummation(MathNode node) {
    if (node.slots.length < 4) {
      return '';
    }

    final variable = serializeSlot(node.slots[0]);
    final start = serializeSlot(node.slots[1]);
    final end = serializeSlot(node.slots[2]);
    final term = serializeSlot(node.slots[3]);

    if (variable.isEmpty &&
        start.isEmpty &&
        end.isEmpty &&
        term.isEmpty) {
      return 'penjumlahan kosong';
    }

    final variableText =
    variable.isEmpty ? 'variabel' : variable;
    final startText =
    start.isEmpty ? 'nilai awal' : start;
    final endText =
    end.isEmpty ? 'nilai akhir' : end;

    if (term.isEmpty) {
      return 'penjumlahan dari $variableText '
          'mulai $startText sampai $endText';
    }

    return 'penjumlahan $term '
        'untuk $variableText dari $startText sampai $endText';
  }
}


