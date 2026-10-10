
import '../../data/models/math_symbol.dart';

class MathLatexSerializer {
  String serializeNodes(List<MathNode> nodes) {
    return nodes
        .map(serializeNode)
        .where((value) => value.isNotEmpty)
        .join();
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
        return node.symbol.renderSyntax;
    }
  }

  String _serializeFraction(MathNode node) {
    if (node.slots.length < 2) {
      return '';
    }

    final numerator = serializeSlot(node.slots[0]);
    final denominator = serializeSlot(node.slots[1]);

    return '\\frac{$numerator}{$denominator}';
  }

  String _serializeRoot(MathNode node) {
    if (node.slots.length == 1) {
      final content = serializeSlot(node.slots[0]);

      return '\\sqrt{$content}';
    }

    if (node.slots.length == 2) {
      final index = serializeSlot(node.slots[0]);
      final content = serializeSlot(node.slots[1]);

      return '\\sqrt[$index]{$content}';
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

    return '$base^{$exponent}';
  }

  String _serializeSubscript(MathNode node) {
    if (node.slots.length < 2) {
      return '';
    }

    final base = serializeSlot(node.slots[0]);
    final index = serializeSlot(node.slots[1]);

    return '${base}_{$index}';
  }

  String _serializeParentheses(MathNode node) {
    if (node.slots.isEmpty) {
      return r'\left(\right)';
    }

    final content = serializeSlot(node.slots[0]);

    return '\\left($content\\right)';
  }

  String _serializeFunction(MathNode node) {
    final arguments = node.slots
        .map(serializeSlot)
        .toList();

    final name = switch (node.symbol.id) {
      'sin' => r'\sin',
      'cos' => r'\cos',
      'tan' => r'\tan',
      'cot' => r'\cot',
      'sec' => r'\sec',
      'csc' => r'\csc',
      'arcsin' => r'\arcsin',
      'arccos' => r'\arccos',
      'arctan' => r'\arctan',
      'arccot' => r'\arccot',
      'arcsec' => r'\arcsec',
      'arccsc' => r'\arccsc',
      'sinh' => r'\sinh',
      'cosh' => r'\cosh',
      'tanh' => r'\tanh',
      'coth' => r'\coth',
      'ln' => r'\ln',
      'log' => r'\log',
      'exp' => r'\exp',
      'sign' => r'\operatorname{sgn}',
      _ => node.symbol.renderSyntax,
    };

    return '$name(${arguments.join(',')})';
  }

  String _serializeLimit(MathNode node) {
    if (node.slots.length < 3) {
      return '';
    }

    final variable = serializeSlot(node.slots[0]);
    final target = serializeSlot(node.slots[1]);
    final content = serializeSlot(node.slots[2]);

    return r'\lim_{'
    '$variable'
    r'\to'
    '$target}'
        ' $content';
  }

  String _serializeIntegral(MathNode node) {
    if (node.slots.length == 1) {
      final integrand = serializeSlot(node.slots[0]);

      return r'\int ' '$integrand' r'\,dx';
    }

    if (node.slots.length == 3) {
      final lower = serializeSlot(node.slots[0]);
      final upper = serializeSlot(node.slots[1]);
      final integrand = serializeSlot(node.slots[2]);

      return r'\int_{'
      '$lower'
      r'}^{'
      '$upper'
      r'} '
      '$integrand'
      r'\,dx';
    }

    return '';
  }

  String _serializeDerivative(MathNode node) {
    if (node.symbol.id == 'ddx') {
      if (node.slots.length < 1) {
        return '';
      }

      final content = serializeSlot(node.slots[0]);

      return r'\frac{d}{dx} ' '$content';
    }

    if (node.symbol.id == 'd_dvar') {
      if (node.slots.length < 2) {
        return '';
      }

      final variable = serializeSlot(node.slots[0]);
      final content = serializeSlot(node.slots[1]);

      return r'\frac{d}{d'
      '$variable'
      r'} '
      '$content';
    }

    if (node.symbol.id == 'd2_dx2') {
      if (node.slots.length < 1) {
        return '';
      }

      final content = serializeSlot(node.slots[0]);

      return r'\frac{d^2}{dx^2} ' '$content';
    }

    return '';
  }

  String _serializeSummation(MathNode node) {
    if (node.slots.length < 4) {
      return '';
    }

    final variable = serializeSlot(node.slots[0]);
    final start = serializeSlot(node.slots[1]);
    final end = serializeSlot(node.slots[2]);
    final term = serializeSlot(node.slots[3]);

    return r'\sum_{'
    '$variable=$start'
    r'}^{'
    '$end'
    r'} '
    '$term';
  }

  String serializeSlot(MathSlot slot) {
    return slot.children
        .map(serializeNode)
        .where((value) => value.isNotEmpty)
        .join();
  }
}