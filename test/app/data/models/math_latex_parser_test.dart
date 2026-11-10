
import 'package:flutter_test/flutter_test.dart';
import 'package:lydera_app/app/core/utils/math_latex_parser.dart';
import 'package:lydera_app/app/core/utils/math_latex_serializer.dart';
import 'package:lydera_app/app/core/utils/math_semantic_serializer.dart';


void main() {
  late MathLatexParser parser;
  late MathSemanticSerializer semanticSerializer;
  late MathLatexSerializer latexSerializer;

  setUp(() {
    parser = MathLatexParser();
    semanticSerializer = MathSemanticSerializer();
    latexSerializer = MathLatexSerializer();
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

  test('semantic serializer reads absolute value, logs, factorial, decimals and Greek symbols', () {
    expect(
      semanticSerializer.serializeLatex(r'\left|x - 3\right|', parser),
      'nilai mutlak dari x Kurang tiga',
    );
    expect(
      semanticSerializer.serializeLatex(r'\log_{2}(8)', parser),
      'logaritma basis dua dari delapan',
    );
    expect(
      semanticSerializer.serializeLatex(r'\log_{3}(9)', parser),
      'logaritma basis tiga dari sembilan',
    );
    expect(
      semanticSerializer.serializeLatex(r'5!', parser),
      'lima faktorial',
    );
    expect(
      semanticSerializer.serializeLatex(r'3.14', parser),
      'tiga koma satu empat',
    );
    expect(
      semanticSerializer.serializeLatex(r'\alpha + \theta = 90^\circ', parser),
      'alfa Tambah teta Sama dengan sembilan puluh derajat',
    );
  });

  test('toAccessibleText converts inline LaTeX and symbols inside Indonesian sentences', () {
    expect(
      MathSemanticSerializer.toAccessibleText(
        r'Hitung nilai $\frac{3}{4} + \sqrt[3]{8}$ untuk $x^2 \ge 4$',
      ),
      'Hitung nilai pecahan dengan pembilang tiga dan penyebut empat Tambah akar pangkat tiga dari delapan untuk x pangkat dua Lebih besar atau sama dengan empat',
    );
    expect(
      MathSemanticSerializer.toAccessibleText(
        r'Jika \frac{1}{2} × 4 = 2, maka x_1 ≠ 0',
      ),
      'Jika pecahan dengan pembilang satu dan penyebut dua kali 4 = 2, maka x indeks satu tidak sama dengan 0',
    );
  });

  test('latex serializer round-trips abs, log_base, factorial, and binomial without placeholder boxes', () {
    for (final expr in [
      r'\left|x\right|',
      r'\log_{3}(x)',
      r'\log_{2}(x)',
      r'5!',
      r'\binom{5}{2}',
    ]) {
      final nodes = parser.parse(expr);
      final serialized = latexSerializer.serializeNodes(nodes);
      expect(serialized.contains('□'), isFalse);
      expect(serialized, expr);
    }
  });
}
