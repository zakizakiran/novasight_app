import 'package:flutter/foundation.dart';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../data/models/math_symbol.dart';
import '../constants/math_symbol_repository.dart';

class MathLatexParser {
  late String _latex;
  int _index = 0;

  List<MathSymbol> get _allSymbols => [
    ...MathSymbolRepository.basicCategory,
    ...MathSymbolRepository.functionsCategory,
    ...MathSymbolRepository.trigCategory,
    ...MathSymbolRepository.calculusCategory,
  ];

  List<MathNode> parse(String latex) {
    _latex = latex;
    _index = 0;
    debugPrint('Parser input: $latex');
    return _parseSequence();
  }

  List<MathNode> _parseSequence({String? endChar}) {
    final nodes = <MathNode>[];

    while (_index < _latex.length) {
      _skipWhitespace();

      if (_index >= _latex.length) break;

      // Handle \right) before parsing the closing delimiter as an atom.
      if (_startsWith(r'\right')) {
        _index += r'\right'.length;
        _skipWhitespace();

        // Consume the delimiter after \right.
        if (_index < _latex.length) {
          if (_latex[_index] == r'\') {
            _readCommand();
          } else {
            _index++;
          }
        }

        // The enclosing sequence will finish here.
        break;
      }

      if (endChar != null && _latex[_index] == endChar) {
        _index++;
        break;
      }

      // Ignore \left but preserve its opening delimiter.
      if (_startsWith(r'\left')) {
        _index += r'\left'.length;
        _skipWhitespace();
        continue;
      }

      if (_latex[_index] == '{') {
        _index++;
        nodes.addAll(_parseSequence(endChar: '}'));
        continue;
      }

      final start = _index;
      final node = _parseAtom();

      if (node == null) {
        if (_index == start) _index++;
        continue;
      }

      switch (node.symbol.type) {
        case MathSymbolType.limit:
          _parseLimit(node);
          nodes.add(node);
          break;

        case MathSymbolType.integral:
          _parseIntegral(node);
          nodes.add(node);
          break;

        case MathSymbolType.summation:
          _parseSummation(node);
          nodes.add(node);
          break;

        default:
          nodes.add(_parsePostfix(node));
      }

      debugPrint('Parser sequences $_index: $endChar');
    }

    return nodes;
  }

  MathNode? _parseAtom() {
    if (_index >= _latex.length) return null;

    final char = _latex[_index];

    if (char == r'\') {
      return _parseCommand();
    }

    if (char == '(' || char == '[') {
      _index++;

      final children = _parseSequence(
        endChar: char == '(' ? ')' : ']',
      );

      final parent = MathNode(
        symbol: _findSymbol('parens') ??
            _customSymbol(
              id: 'parens',
              label: '(□)',
              syntax: r'(\Box)',
              type: MathSymbolType.parens,
              slots: 1,
            ),
      );

      _putInSlot(parent, 0, children);
      return parent;
    }

    if (char == '|') {
      _index++;

      final children = _parseSequence(endChar: '|');

      final parent = MathNode(
        symbol: _findSymbol('abs') ??
            _customSymbol(
              id: 'abs',
              label: '|□|',
              syntax: r'\left|□\right|',
              semantic: 'Nilai mutlak',
              type: MathSymbolType.parens,
              slots: 1,
            ),
      );

      _putInSlot(parent, 0, children);
      return parent;
    }

    if (char == ')' || char == ']') return null;

    // Read consecutive digits as one number.
    if (RegExp(r'\d').hasMatch(char)) {
      final start = _index;

      while (_index < _latex.length &&
          RegExp(r'\d').hasMatch(_latex[_index])) {
        _index++;
      }

      final value = _latex.substring(start, _index);

      if (value.length == 1) {
        return _symbolNodeFor(value);
      }

      return MathNode(
        symbol: _customSymbol(
          id: value,
          label: value,
          syntax: value,
          type: MathSymbolType.number,
          slots: 0,
        ),
      );
    }

    _index++;
    return _symbolNodeFor(char);
  }

  MathNode _parsePostfix(MathNode node) {
    var current = node;

    while (_index < _latex.length) {
      _skipWhitespace();

      if (_index >= _latex.length) break;

      final marker = _latex[_index];

      if (marker == '!') {
        _index++;
        final symbol = _findSymbol('fact') ??
            _customSymbol(
              id: 'fact',
              label: '□!',
              syntax: '□!',
              semantic: 'Faktorial',
              type: MathSymbolType.function,
              slots: 1,
            );
        final parent = MathNode(symbol: symbol);
        _putInSlot(parent, 0, [current]);
        current = parent;
        continue;
      }

      if (marker != '^' && marker != '_') break;

      _index++;
      final argument = _parseArgument();

      if (marker == '_' && current.symbol.id == 'log') {
        current = _parseLogWithBase(argument);
        continue;
      }

      final isPower = marker == '^';

      final symbol = _findSymbol(
        isPower ? 'power' : 'subscript',
      ) ??
          _customSymbol(
            id: isPower ? 'power' : 'subscript',
            label: isPower ? '□^□' : '□_□',
            syntax: isPower ? r'□^{□}' : r'□_{□}',
            type: isPower
                ? MathSymbolType.power
                : MathSymbolType.subscript,
            slots: 2,
          );

      final parent = MathNode(symbol: symbol);

      _putInSlot(parent, 0, [current]);
      _putInSlot(parent, 1, argument);

      current = parent;
    }

    return current;
  }

  MathNode _parseLogWithBase(List<MathNode> base) {
    final baseText = base.map((n) => n.symbol.visualLabel).join();

    final specialId = switch (baseText) {
      '2' => 'log2',
      '10' => 'log10',
      _ => 'log_base',
    };

    final symbol = _findSymbol(specialId) ??
        _findSymbol('log_base');

    if (symbol == null) {
      final fallback = MathNode(
        symbol: _customSymbol(
          id: 'log_base',
          label: 'log□(□)',
          syntax: r'\log_{□}(□)',
          type: MathSymbolType.function,
          slots: 2,
        ),
      );

      _putInSlot(fallback, 0, base);
      _putInSlot(fallback, 1, _parseFunctionArgument());
      return fallback;
    }

    final parent = MathNode(symbol: symbol);

    if (specialId == 'log_base') {
      _putInSlot(parent, 0, base);
      _putInSlot(parent, 1, _parseFunctionArgument());
    } else {
      _putInSlot(parent, 0, _parseFunctionArgument());
    }

    return parent;
  }

  List<MathNode> _parseFunctionArgument() {
    _skipWhitespace();

    if (_index >= _latex.length) return [];

    if (_latex[_index] == '(' || _latex[_index] == '{') {
      final opener = _latex[_index++];
      return _parseSequence(
        endChar: opener == '(' ? ')' : '}',
      );
    }

    final atom = _parseAtom();
    if (atom == null) return [];

    if (atom.symbol.type == MathSymbolType.limit) {
      _parseLimit(atom);
      return [atom];
    }

    return [_parsePostfix(atom)];
  }

  void _parseLimit(MathNode node) {
    // Slots: 0 variable, 1 approach value, 2 expression.
    _skipWhitespace();

    if (_index < _latex.length && _latex[_index] == '_') {
      _index++;

      final condition = _parseArgument();

      final arrowIndex = condition.indexWhere(
            (n) =>
        n.symbol.id == 'to' ||
            n.symbol.renderSyntax == r'\to' ||
            n.symbol.renderSyntax == r'\rightarrow',
      );

      if (arrowIndex >= 0) {
        _putInSlot(node, 0, condition.sublist(0, arrowIndex));
        _putInSlot(node, 1, condition.sublist(arrowIndex + 1));
      } else {
        _putInSlot(node, 0, condition);
      }
    }

    _skipWhitespace();

    if (_index >= _latex.length || _latex[_index] == '}') {
      return;
    }

    if (_latex[_index] == '{') {
      _index++;
      _putInSlot(node, 2, _parseSequence(endChar: '}'));
      return;
    }

    final atom = _parseAtom();
    if (atom == null) return;

    if (atom.symbol.type == MathSymbolType.integral) {
      _parseIntegral(atom);
    } else if (atom.symbol.type == MathSymbolType.summation) {
      _parseSummation(atom);
    } else if (atom.symbol.type == MathSymbolType.limit) {
      _parseLimit(atom);
    } else {
      _putInSlot(node, 2, [_parsePostfix(atom)]);
      return;
    }

    _putInSlot(node, 2, [atom]);
  }

  void _parseIntegral(MathNode node) {
    // Definite integral: lower, upper, integrand.
    // Indefinite integral: integrand.
    final hasBounds = node.slots.length >= 3;

    _skipWhitespace();

    while (_index < _latex.length) {
      _skipWhitespace();

      if (_index >= _latex.length) break;

      final marker = _latex[_index];
      if (marker != '_' && marker != '^') break;

      _index++;

      final argument = _parseArgument();

      if (hasBounds) {
        _putInSlot(node, marker == '_' ? 0 : 1, argument);
      }
    }

    final integrand = <MathNode>[];

    while (_index < _latex.length) {
      _skipWhitespace();

      if (_index >= _latex.length) break;

      final char = _latex[_index];

      if (char == '}' || char == ')' || char == ']') break;
      if (_startsWith(r'\right')) break;

      // Ignore TeX spacing commands such as \, before dx.
      if (_startsWith(r'\,')) {
        _readCommand();
        continue;
      }

      if (integrand.isNotEmpty &&
          _isDifferentialAtCurrentPosition()) {
        integrand.add(_parseDifferential());
        break;
      }

      if (char == '{') {
        _index++;
        integrand.addAll(_parseSequence(endChar: '}'));
        continue;
      }

      final start = _index;
      final atom = _parseAtom();

      if (atom == null) {
        if (_index == start) _index++;
        continue;
      }

      if (atom.symbol.type == MathSymbolType.integral) {
        _parseIntegral(atom);
        integrand.add(atom);
      } else if (atom.symbol.type == MathSymbolType.limit) {
        _parseLimit(atom);
        integrand.add(atom);
      } else if (atom.symbol.type == MathSymbolType.summation) {
        _parseSummation(atom);
        integrand.add(atom);
      } else {
        integrand.add(_parsePostfix(atom));
      }
    }

    _putInSlot(node, hasBounds ? 2 : 0, integrand);
  }

  bool _isDifferentialAtCurrentPosition() {
    if (_index >= _latex.length || _latex[_index] != 'd') {
      return false;
    }

    final remaining = _latex.substring(_index);

    return RegExp(r'^d(?:[a-zA-Z]|\\theta)')
        .hasMatch(remaining);
  }

  MathNode _parseDifferential() {
    _index++; // d

    String variable;

    if (_startsWith(r'\theta')) {
      _readCommand();
      variable = 'θ';
    } else {
      variable = _latex[_index++];
    }

    final syntax = variable == 'θ'
        ? r'\,d\theta'
        : '\\,d$variable';

    return MathNode(
      symbol: MathSymbol(
        id: 'differential_$variable',
        visualLabel: 'd$variable',
        renderSyntax: syntax,
        semanticText: 'Diferensial $variable',
        type: MathSymbolType.text,
        slotCount: 0,
      ),
    );
  }

  void _parseSummation(MathNode node) {
    // Slots: variable, initial value, final value, summand.
    _skipWhitespace();

    if (_index < _latex.length && _latex[_index] == '_') {
      _index++;
      final lower = _parseArgument();

      final equalsIndex = lower.indexWhere(
            (n) => n.symbol.visualLabel == '=',
      );

      if (equalsIndex >= 0) {
        _putInSlot(node, 0, lower.sublist(0, equalsIndex));
        _putInSlot(node, 1, lower.sublist(equalsIndex + 1));
      } else {
        _putInSlot(node, 0, lower);
      }
    }

    _skipWhitespace();

    if (_index < _latex.length && _latex[_index] == '^') {
      _index++;
      _putInSlot(node, 2, _parseArgument());
    }

    _skipWhitespace();

    if (_index >= _latex.length || _latex[_index] == '}') {
      return;
    }

    if (_latex[_index] == '{') {
      _index++;
      _putInSlot(node, 3, _parseSequence(endChar: '}'));
      return;
    }

    final atom = _parseAtom();

    if (atom != null) {
      _putInSlot(node, 3, [_parsePostfix(atom)]);
    }
  }

  MathNode? _parseCommand() {
    final command = _readCommand();

    switch (command) {
      case 'frac':
        final numerator = _parseArgument();
        final denominator = _parseArgument();

        final parent = MathNode(
          symbol: _findSymbol('frac') ??
              _customSymbol(
                id: 'frac',
                label: '□/□',
                syntax: r'\frac{□}{□}',
                type: MathSymbolType.fraction,
                slots: 2,
              ),
        );

        _putInSlot(parent, 0, numerator);
        _putInSlot(parent, 1, denominator);
        return parent;

      case 'sqrt':
        List<MathNode>? degree;

        _skipWhitespace();

        if (_index < _latex.length && _latex[_index] == '[') {
          _index++;
          degree = _parseSequence(endChar: ']');
        }

        final content = _parseArgument();

        final parent = MathNode(
          symbol: _findSymbol(degree == null ? 'sqrt' : 'root_n')!,
        );

        if (degree != null) {
          _putInSlot(parent, 0, degree);
          _putInSlot(parent, 1, content);
        } else {
          _putInSlot(parent, 0, content);
        }

        return parent;

      case 'int':
        final definite =
            _hasNextScript('_') || _hasNextScript('^');

        return MathNode(
          symbol: _findSymbol(definite ? 'int_def' : 'int_indef')!,
        );

      case 'sum':
        return MathNode(
          symbol: _findSymbol('summation')!,
        );

      case 'to':
      case 'rightarrow':
        return MathNode(
          symbol: _customSymbol(
            id: 'to',
            label: '→',
            syntax: command == 'to' ? r'\to' : r'\rightarrow',
            semantic: 'mendekati',
            type: MathSymbolType.operator,
            slots: 0,
          ),
        );

      case 'times':
        return _symbolNodeFor('×');

      case 'div':
        return _symbolNodeFor('÷');

      case 'pi':
        return _symbolNodeFor('π');

      case 'infty':
        return _symbolNodeFor('∞');

      case 'le':
      case 'leq':
        return _symbolNodeFor('≤');

      case 'ge':
      case 'geq':
        return _symbolNodeFor('≥');

      case 'neq':
      case 'ne':
        return _symbolNodeFor('≠');

      case 'cdot':
        return _symbolNodeFor('·');

      case 'pm':
        return _symbolNodeFor('±');

      case 'mp':
        return _symbolNodeFor('∓');

      case 'approx':
        return _symbolNodeFor('≈');

      case 'equiv':
        return _symbolNodeFor('≡');

      case 'propto':
        return _symbolNodeFor('∝');

      case 'degree':
      case 'circ':
        return _symbolNodeFor('°');

      case '%':
        return _symbolNodeFor('%');

      case 'text':
      case 'mathrm':
      case 'mathbf':
      case 'mathit':
        final literal = _readBracedLiteral();
        if (literal.isEmpty) return null;
        return MathNode(
          symbol: _customSymbol(
            id: 'text_$literal',
            label: literal,
            syntax: literal,
            semantic: literal,
            type: MathSymbolType.text,
            slots: 0,
          ),
        );

      case 'operatorname':
        final opName = _readBracedLiteral().trim();
        final mappedId = opName == 'sgn' ? 'sign' : opName;
        final opSymbol = _findSymbol(mappedId);
        if (opSymbol != null) {
          final node = MathNode(symbol: opSymbol);
          if (opSymbol.type == MathSymbolType.function &&
              opSymbol.slotCount > 0) {
            _parseFunctionArguments(node);
          }
          return node;
        }
        return MathNode(
          symbol: _customSymbol(
            id: mappedId,
            label: opName,
            syntax: opName,
            semantic: opName,
            type: MathSymbolType.text,
            slots: 0,
          ),
        );

      case ' ':
      case ',':
      case ';':
      case '!':
      case 'quad':
      case 'qquad':
        return null;

      case 'binom':
        final upper = _parseArgument();
        final lower = _parseArgument();

        final parent = MathNode(
          symbol: _findSymbol('binom')!,
        );

        _putInSlot(parent, 0, upper);
        _putInSlot(parent, 1, lower);
        return parent;

      case 'bar':
      case 'overline':
        final content = _parseArgument();

        final parent = MathNode(
          symbol: _customSymbol(
            id: 'bar',
            label: 'bar(□)',
            syntax: r'\bar{□}',
            semantic: 'bar',
            type: MathSymbolType.function,
            slots: 1,
          ),
        );

        _putInSlot(parent, 0, content);
        return parent;

      default:
        final greek = _greekCommandMap[command];
        if (greek != null) {
          return MathNode(
            symbol: _customSymbol(
              id: command,
              label: greek.$1,
              syntax: '\\$command',
              semantic: greek.$2,
              type: MathSymbolType.text,
              slots: 0,
            ),
          );
        }

        final symbol = _findSymbol(command);

        if (symbol != null) {
          final node = MathNode(symbol: symbol);

          if (symbol.type == MathSymbolType.function &&
              symbol.slotCount > 0) {
            _parseFunctionArguments(node);
          }

          return node;
        }

        return MathNode(
          symbol: _customSymbol(
            id: command,
            label: command,
            syntax: '\\$command',
            type: MathSymbolType.text,
            slots: 0,
          ),
        );
    }
  }

  void _parseFunctionArguments(MathNode node) {
    _skipWhitespace();

    if (_index >= _latex.length) return;

    if (_latex[_index] == '(') {
      _index++;
      final args = _splitAtCommas(_parseSequence(endChar: ')'));

      for (var i = 0; i < args.length && i < node.slots.length; i++) {
        _putInSlot(node, i, args[i]);
      }

      return;
    }

    if (_latex[_index] == '{') {
      _index++;
      final args = _parseSequence(endChar: '}');

      if (node.slots.isNotEmpty) {
        _putInSlot(node, 0, args);
      }
    }
  }

  List<List<MathNode>> _splitAtCommas(List<MathNode> nodes) {
    final result = <List<MathNode>>[[]];

    for (final node in nodes) {
      if (node.symbol.id == ',') {
        result.add([]);
      } else {
        result.last.add(node);
      }
    }

    return result;
  }

  List<MathNode> _parseArgument() {
    _skipWhitespace();

    if (_index >= _latex.length) return [];

    if (_latex[_index] == '{') {
      _index++;
      return _parseSequence(endChar: '}');
    }

    final atom = _parseAtom();
    if (atom == null) return [];

    if (atom.symbol.type == MathSymbolType.limit) {
      _parseLimit(atom);
    } else if (atom.symbol.type == MathSymbolType.integral) {
      _parseIntegral(atom);
    } else if (atom.symbol.type == MathSymbolType.summation) {
      _parseSummation(atom);
    } else {
      return [_parsePostfix(atom)];
    }

    return [atom];
  }

  String _readCommand() {
    _index++;

    if (_index >= _latex.length) return '';

    if (!RegExp(r'[a-zA-Z]').hasMatch(_latex[_index])) {
      return _latex[_index++];
    }

    final start = _index;

    while (_index < _latex.length &&
        RegExp(r'[a-zA-Z]').hasMatch(_latex[_index])) {
      _index++;
    }

    return _latex.substring(start, _index);
  }

  void _skipWhitespace() {
    while (_index < _latex.length &&
        _latex[_index].trim().isEmpty) {
      _index++;
    }
  }

  bool _startsWith(String value) =>
      _latex.startsWith(value, _index);

  bool _hasNextScript(String marker) {
    var position = _index;

    while (position < _latex.length &&
        _latex[position].trim().isEmpty) {
      position++;
    }

    return position < _latex.length &&
        _latex[position] == marker;
  }

  void _putInSlot(
      MathNode parent,
      int slotIndex,
      List<MathNode> children,
      ) {
    if (slotIndex < 0 || slotIndex >= parent.slots.length) {
      throw FormatException(
        'Invalid slot $slotIndex for ${parent.symbol.id}',
      );
    }

    final slot = parent.slots[slotIndex];

    slot.children.assignAll(
      children.map((node) {
        node.parentSlot = slot;
        return node;
      }),
    );
  }

  MathNode _symbolNodeFor(String value) {
    for (final symbol in _allSymbols) {
      if (symbol.renderSyntax == value ||
          symbol.id == value ||
          symbol.visualLabel == value) {
        return MathNode(symbol: symbol);
      }
    }

    final isNumber = RegExp(r'^\d$').hasMatch(value);
    final isOperator = '+-=<>*/×÷−≤≥≠·±∓≈≡∝°!,:→'.contains(value);
    final semantic = _charSemanticMap[value] ?? value;

    return MathNode(
      symbol: _customSymbol(
        id: value,
        label: value,
        syntax: value,
        semantic: semantic,
        type: isNumber
            ? MathSymbolType.number
            : isOperator
            ? MathSymbolType.operator
            : MathSymbolType.text,
        slots: 0,
      ),
    );
  }

  String _readBracedLiteral() {
    _skipWhitespace();
    if (_index >= _latex.length || _latex[_index] != '{') return '';
    _index++;
    final start = _index;
    var depth = 1;
    while (_index < _latex.length && depth > 0) {
      if (_latex[_index] == '{') {
        depth++;
      } else if (_latex[_index] == '}') {
        depth--;
        if (depth == 0) break;
      }
      _index++;
    }
    final content = _latex.substring(start, _index);
    if (_index < _latex.length && _latex[_index] == '}') _index++;
    return content;
  }

  static const Map<String, (String, String)> _greekCommandMap = {
    'alpha': ('α', 'alfa'),
    'beta': ('β', 'beta'),
    'gamma': ('γ', 'gamma'),
    'Gamma': ('Γ', 'gamma besar'),
    'delta': ('δ', 'delta'),
    'Delta': ('Δ', 'delta besar'),
    'epsilon': ('ε', 'epsilon'),
    'varepsilon': ('ε', 'epsilon'),
    'zeta': ('ζ', 'zeta'),
    'eta': ('η', 'eta'),
    'theta': ('θ', 'teta'),
    'vartheta': ('θ', 'teta'),
    'Theta': ('Θ', 'teta besar'),
    'iota': ('ι', 'iota'),
    'kappa': ('κ', 'kapa'),
    'lambda': ('λ', 'lambda'),
    'Lambda': ('Λ', 'lambda besar'),
    'mu': ('μ', 'mu'),
    'nu': ('ν', 'nu'),
    'xi': ('ξ', 'ksi'),
    'Xi': ('Ξ', 'ksi besar'),
    'Pi': ('Π', 'pi besar'),
    'rho': ('ρ', 'ro'),
    'sigma': ('σ', 'sigma'),
    'Sigma': ('Σ', 'sigma besar'),
    'tau': ('τ', 'tau'),
    'upsilon': ('υ', 'upsilon'),
    'phi': ('φ', 'fi'),
    'varphi': ('φ', 'fi'),
    'Phi': ('Φ', 'fi besar'),
    'chi': ('χ', 'khi'),
    'psi': ('ψ', 'psi'),
    'Psi': ('Ψ', 'psi besar'),
    'omega': ('ω', 'omega'),
    'Omega': ('Ω', 'omega besar'),
  };

  static const Map<String, String> _charSemanticMap = {
    '*': 'Kali',
    '·': 'Kali',
    '/': 'Per',
    '±': 'Kurang lebih',
    '∓': 'Lebih kurang',
    '≈': 'Kira-kira sama dengan',
    '≡': 'Ekuivalen dengan',
    '∝': 'Sebanding dengan',
    '°': 'Derajat',
    '!': 'Faktorial',
    ',': 'koma',
    ':': 'banding',
    '→': 'mendekati',
    '√': 'Akar kuadrat',
    'α': 'alfa',
    'β': 'beta',
    'γ': 'gamma',
    'Γ': 'gamma besar',
    'δ': 'delta',
    'Δ': 'delta besar',
    'ε': 'epsilon',
    'ζ': 'zeta',
    'η': 'eta',
    'θ': 'teta',
    'Θ': 'teta besar',
    'λ': 'lambda',
    'Λ': 'lambda besar',
    'μ': 'mu',
    'σ': 'sigma',
    'Σ': 'sigma besar',
    'τ': 'tau',
    'φ': 'fi',
    'Φ': 'fi besar',
    'ψ': 'psi',
    'ω': 'omega',
    'Ω': 'omega besar',
  };

  MathSymbol? _findSymbol(String id) {
    for (final symbol in _allSymbols) {
      if (symbol.id == id) return symbol;
    }

    return null;
  }

  MathSymbol _customSymbol({
    required String id,
    required String label,
    required String syntax,
    String? semantic,
    required MathSymbolType type,
    required int slots,
  }) {
    return MathSymbol(
      id: id,
      visualLabel: label,
      renderSyntax: syntax,
      semanticText: semantic ?? label,
      type: type,
      slotCount: slots,
    );
  }
}
