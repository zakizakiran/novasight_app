
import 'package:flutter_test/flutter_test.dart';
import 'package:novasight_app/app/core/utils/math_latex_parser.dart';

import 'package:novasight_app/app/data/models/math_symbol.dart';


void main() {
  late MathLatexParser parser;

  setUp(() {
    parser = MathLatexParser();
  });

  test('definite integral has correct bounds and integrand', () {
    final nodes = parser.parse(r'\int_{5}^{7} 7\,dx');

    expect(nodes, hasLength(1));

    final integral = nodes.first;
    expect(integral.symbol.id, 'int_def');
    expect(integral.slots, hasLength(3));

    expect(integral.slots[0].children.single.symbol.id, '5');
    expect(integral.slots[1].children.single.symbol.id, '7');

    final integrand = integral.slots[2].children;
    expect(
      integrand.map((node) => node.symbol.id),
      ['7', 'differential_x'],
    );
  });

  test('indefinite integral preserves power and differential', () {
    final nodes = parser.parse(r'\int x^2\,dx');

    expect(nodes, hasLength(1));

    final integral = nodes.first;
    expect(integral.symbol.id, 'int_indef');

    final integrand = integral.slots[0].children;
    expect(
      integrand.map((node) => node.symbol.id),
      ['power', 'differential_x'],
    );
  });

  test('limit keeps its three slots', () {
    final nodes = parser.parse(r'\lim_{x\to5} 5');

    expect(nodes, hasLength(1));

    final limit = nodes.first;
    expect(limit.symbol.id, 'lim');
    expect(limit.slots, hasLength(3));

    expect(limit.slots[0].children.single.symbol.id, 'x');
    expect(limit.slots[1].children.single.symbol.id, '5');
    expect(limit.slots[2].children.single.symbol.id, '5');
  });

  test('summation assigns variable, bounds and summand', () {
    final nodes = parser.parse(r'\sum_{i=1}^{n} i');

    expect(nodes, hasLength(1));

    final sum = nodes.first;
    expect(sum.symbol.id, 'summation');
    expect(sum.slots, hasLength(4));

    expect(sum.slots[0].children.single.symbol.id, 'var_i');
    expect(sum.slots[1].children.single.symbol.id, '1');
    expect(sum.slots[2].children.single.symbol.id, 'n');
    expect(sum.slots[3].children.single.symbol.id, 'var_i');
  });

  test('fraction keeps numerator and denominator', () {
    final nodes = parser.parse(r'\frac{1}{2}');

    expect(nodes, hasLength(1));
    expect(nodes.first.symbol.id, 'frac');
    expect(nodes.first.slots[0].children.single.symbol.id, '1');
    expect(nodes.first.slots[1].children.single.symbol.id, '2');
  });

  test('square root keeps its content', () {
    final nodes = parser.parse(r'\sqrt{x}');

    expect(nodes, hasLength(1));
    expect(nodes.first.symbol.id, 'sqrt');
    expect(nodes.first.slots[0].children.single.symbol.id, 'x');
  });

  test('logarithm with base two uses log2', () {
    final nodes = parser.parse(r'\log_{2}(x)');

    expect(nodes, hasLength(1));
    expect(nodes.first.symbol.id, 'log2');
    expect(nodes.first.slots[0].children.single.symbol.id, 'x');
  });

  test('binomial coefficient keeps both arguments', () {
    final nodes = parser.parse(r'\binom{5}{2}');

    expect(nodes, hasLength(1));
    expect(nodes.first.symbol.id, 'binom');
    expect(nodes.first.slots[0].children.single.symbol.id, '5');
    expect(nodes.first.slots[1].children.single.symbol.id, '2');
  });
}
