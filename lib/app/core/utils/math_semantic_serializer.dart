import '../../data/models/math_symbol.dart';
import 'indonesian_number_to_word.dart';
import 'math_latex_parser.dart';

class MathSemanticSerializer {
  // ponytail: regex-based inline detector covers 1-level nested braces; upgrade to full TeX lexer if deeply nested inline formulas appear without $ delimiters.
  static final MathLatexParser _defaultParser = MathLatexParser();
  static final MathSemanticSerializer _instance = MathSemanticSerializer();

  static String toAccessibleText(String text, [MathLatexParser? parser]) {
    return _instance.serializeTextWithMath(text, parser);
  }

  String serializeLatex(String latex, [MathLatexParser? parser]) {
    if (latex.trim().isEmpty) return '';
    final nodes = (parser ?? _defaultParser).parse(latex);
    return serializeNodes(nodes);
  }

  String serializeTextWithMath(String text, [MathLatexParser? parser]) {
    if (text.trim().isEmpty) return '';
    final p = parser ?? _defaultParser;

    var result = text.replaceAllMapped(
      RegExp(
        r'\$\$([\s\S]+?)\$\$|\\\[([\s\S]+?)\\\]|\\\(([\s\S]+?)\\\)|\$([^$\n]+?)\$',
      ),
      (m) {
        final expr = m.group(1) ?? m.group(2) ?? m.group(3) ?? m.group(4) ?? '';
        final spoken = serializeLatex(expr, p);
        return spoken.isEmpty ? expr : ' $spoken ';
      },
    );

    result = result.replaceAllMapped(
      RegExp(r'\\(?:text|mathrm|mathbf|mathit)\s*\{([^{}]*)\}'),
      (m) => m.group(1) ?? '',
    );

    result = result.replaceAllMapped(
      RegExp(
        r'\\(?:frac|binom)\s*\{(?:[^{}]|\{[^{}]*\})*\}\s*\{(?:[^{}]|\{[^{}]*\})*\}'
        r'|\\sqrt\s*(?:\[[^\]]*\])?\s*\{(?:[^{}]|\{[^{}]*\})*\}'
        r'|\\(?:bar|overline)\s*\{(?:[^{}]|\{[^{}]*\})*\}'
        r'|\\(?:lim|sum|int)(?:\s*[_^]\s*(?:\{(?:[^{}]|\{[^{}]*\})*\}|[a-zA-Z0-9]+))+(?:\s*(?:\{(?:[^{}]|\{[^{}]*\})*\}|[a-zA-Z0-9^_\\]+))?'
        r'|\\(?:sin|cos|tan|cot|sec|csc|arcsin|arccos|arctan|arccot|arcsec|arccsc|sinh|cosh|tanh|coth|ln|log)(?:_\{[^{}]+\}|_\d+)?\s*(?:\([^()]+\)|\{[^{}]+\})'
        r'|\\left\|[^|]+\\right\|'
        r'|\b[a-zA-Z0-9]+(?:\^(?:\{[^{}]+\}|[0-9a-zA-Z+-]+)|_(?:\{[^{}]+\}|[0-9a-zA-Z+-]+))+'
        r'|\\(?:times|div|pm|mp|cdot|le|leq|ge|geq|ne|neq|approx|equiv|propto|infty|pi|alpha|beta|gamma|Gamma|delta|Delta|epsilon|varepsilon|theta|Theta|lambda|Lambda|mu|sigma|Sigma|tau|phi|varphi|Phi|omega|Omega|to|rightarrow|degree|circ)\b',
      ),
      (m) {
        final expr = m.group(0) ?? '';
        final spoken = serializeLatex(expr, p);
        return spoken.isEmpty ? expr : ' $spoken ';
      },
    );

    const unicodeReplacements = <String, String>{
      '×': ' kali ',
      '÷': ' bagi ',
      '±': ' kurang lebih ',
      '∓': ' lebih kurang ',
      '≤': ' lebih kecil atau sama dengan ',
      '≥': ' lebih besar atau sama dengan ',
      '≠': ' tidak sama dengan ',
      '≈': ' kira-kira sama dengan ',
      '≡': ' ekuivalen dengan ',
      '∝': ' sebanding dengan ',
      '∞': ' tak hingga ',
      'π': ' pi ',
      '°': ' derajat ',
      '→': ' mendekati ',
    };
    unicodeReplacements.forEach((symbol, spoken) {
      result = result.replaceAll(symbol, spoken);
    });

    return result.replaceAll(RegExp(r'[ \t]{2,}'), ' ').trim();
  }

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
        if (node.symbol.id == 'vector' && node.slots.isNotEmpty) {
          final items = node.slots.map(serializeSlot).toList();
          if (items.every((e) => e.isEmpty)) {
            return 'vektor tiga dimensi kosong';
          }
          return 'vektor ${items.map((e) => e.isEmpty ? 'kosong' : e).join(' koma ')}';
        }
        if (node.symbol.id == 'dvar' && node.slots.isNotEmpty) {
          final v = serializeSlot(node.slots[0]);
          return v.isEmpty ? 'diferensial variabel kosong' : 'diferensial d $v';
        }
        return node.symbol.semanticText;
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

          if (index + 1 < nodes.length &&
              (nodes[index].symbol.id == 'dot' ||
                  nodes[index].symbol.renderSyntax == '.') &&
              nodes[index + 1].symbol.type == MathSymbolType.number) {
            index++; // consume decimal dot
            parts.add('koma');
            while (index < nodes.length &&
                nodes[index].symbol.type == MathSymbolType.number) {
              final decDigits = _extractNumber(nodes[index]);
              if (decDigits == null) break;
              parts.addAll(
                decDigits.split('').map(
                      (d) => IndonesianNumberToWords.convert(int.parse(d)),
                    ),
              );
              index++;
            }
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

    if (base.isEmpty && exponent.isEmpty) {
      return 'pangkat kosong';
    }

    if (base.isEmpty) {
      return 'basis kosong pangkat $exponent';
    }

    if (exponent.isEmpty) {
      return '$base pangkat kosong';
    }

    if (exponent.toLowerCase() == 'derajat') {
      return '$base derajat';
    }

    return '$base pangkat $exponent';
  }

  String _serializeSubscript(MathNode node) {
    if (node.slots.length == 1) {
      final index = serializeSlot(node.slots[0]);
      if (index.isEmpty) {
        return 'a indeks kosong';
      }
      return 'a indeks $index';
    }

    if (node.slots.length < 2) {
      return '';
    }

    final base = serializeSlot(node.slots[0]);
    final index = serializeSlot(node.slots[1]);

    if (base.isEmpty && index.isEmpty) {
      return 'indeks kosong';
    }

    if (base.isEmpty) {
      return 'basis kosong indeks $index';
    }

    if (index.isEmpty) {
      return '$base indeks kosong';
    }

    return '$base indeks $index';
  }

  String _serializeParentheses(MathNode node) {
    final isAbs = node.symbol.id == 'abs';

    if (node.slots.isEmpty) {
      return isAbs ? 'nilai mutlak kosong' : 'kurung kosong';
    }

    final content = serializeSlot(node.slots[0]);

    if (content.isEmpty) {
      return isAbs ? 'nilai mutlak kosong' : 'kurung kosong';
    }

    if (isAbs) {
      return 'nilai mutlak dari $content';
    }

    return 'kurung buka $content kurung tutup';
  }

  String _serializeFunction(MathNode node) {
    switch (node.symbol.id) {
      case 'log_base':
        final base = node.slots.isNotEmpty ? serializeSlot(node.slots[0]) : '';
        final arg = node.slots.length > 1 ? serializeSlot(node.slots[1]) : '';
        if (base.isEmpty && arg.isEmpty) {
          return 'logaritma dengan basis kosong';
        }
        if (base.isEmpty) {
          return 'logaritma dari $arg';
        }
        if (arg.isEmpty) {
          return 'logaritma basis $base';
        }
        return 'logaritma basis $base dari $arg';

      case 'fact':
        final arg = node.slots.isNotEmpty ? serializeSlot(node.slots[0]) : '';
        if (arg.isEmpty) {
          return 'faktorial kosong';
        }
        return '$arg faktorial';

      case 'bar':
        final arg = node.slots.isNotEmpty ? serializeSlot(node.slots[0]) : '';
        if (arg.isEmpty) {
          return 'bar kosong';
        }
        return '$arg bar';
    }

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
      case 'fx':
      case 'fxy':
        return 'fungsi f';

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

      case 'arsinh':
        return 'arkus sinus hiperbolik';

      case 'arcosh':
        return 'arkus cosinus hiperbolik';

      case 'artanh':
        return 'arkus tangen hiperbolik';

      case 'arcoth':
        return 'arkus kotangen hiperbolik';

      case 'ln':
        return 'logaritma natural';

      case 'log':
        return 'logaritma';

      case 'log10':
        return 'logaritma basis sepuluh';

      case 'log2':
        return 'logaritma basis dua';

      case 'exp':
        return 'eksponensial';

      case 'sign':
        return 'fungsi tanda';

      case 'binom':
        return 'koefisien binomial';

      case 'perm':
        return 'permutasi';

      case 'comb':
        return 'kombinasi';

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

      final lowerText = lower.isEmpty ? 'batas bawah kosong' : lower;
      final upperText = upper.isEmpty ? 'batas atas kosong' : upper;

      if (integrand.isEmpty) {
        return 'integral dari $lowerText sampai $upperText';
      }

      return 'integral dari $lowerText sampai $upperText '
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


