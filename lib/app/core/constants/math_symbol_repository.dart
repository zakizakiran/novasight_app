import '../../data/models/math_symbol.dart';

class MathSymbolRepository {
  // Kategori 0: Aritmatika Dasar & Eksponen
  static final List<MathSymbol> basicCategory = [
    // Parentheses
    const MathSymbol(
      id: 'parens',
      visualLabel: '(□)',
      renderSyntax: r'(\Box)',
      semanticText: 'Kurung dengan isi',
      slotCount: 1,
      type: MathSymbolType.parens,
    ),

    // Numbers

    const MathSymbol(
      id: '0',
      visualLabel: '0',
      renderSyntax: '0',
      semanticText: 'Angka nol',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '1',
      visualLabel: '1',
      renderSyntax: '1',
      semanticText: 'Angka satu',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '2',
      visualLabel: '2',
      renderSyntax: '2',
      semanticText: 'Angka dua',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '3',
      visualLabel: '3',
      renderSyntax: '3',
      semanticText: 'Angka tiga',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '4',
      visualLabel: '4',
      renderSyntax: '4',
      semanticText: 'Angka empat',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '5',
      visualLabel: '5',
      renderSyntax: '5',
      semanticText: 'Angka lima',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '6',
      visualLabel: '6',
      renderSyntax: '6',
      semanticText: 'Angka enam',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '7',
      visualLabel: '7',
      renderSyntax: '7',
      semanticText: 'Angka tujuh',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '8',
      visualLabel: '8',
      renderSyntax: '8',
      semanticText: 'Angka delapan',
      type: MathSymbolType.number,
    ),

    const MathSymbol(
      id: '9',
      visualLabel: '9',
      renderSyntax: '9',
      semanticText: 'Angka sembilan',
      type: MathSymbolType.number,
    ),

    // Operators

    const MathSymbol(
      id: 'plus',
      visualLabel: '+',
      renderSyntax: '+',
      semanticText: 'Tambah',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'minus',
      visualLabel: '−',
      renderSyntax: '-',
      semanticText: 'Kurang',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'multiply',
      visualLabel: '×',
      renderSyntax: r'\times',
      semanticText: 'Kali',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'divide',
      visualLabel: '÷',
      renderSyntax: r'\div',
      semanticText: 'Bagi',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'equals',
      visualLabel: '=',
      renderSyntax: '=',
      semanticText: 'Sama dengan',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'gt',
      visualLabel: '>',
      renderSyntax: '>',
      semanticText: 'Lebih besar dari',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'lt',
      visualLabel: '<',
      renderSyntax: '<',
      semanticText: 'Lebih kecil dari',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'gte',
      visualLabel: '≥',
      renderSyntax: r'\ge',
      semanticText: 'Lebih besar atau sama dengan',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'lte',
      visualLabel: '≤',
      renderSyntax: r'\le',
      semanticText: 'Lebih kecil atau sama dengan',
      type: MathSymbolType.operator,
    ),

    const MathSymbol(
      id: 'not_equal',
      visualLabel: '≠',
      renderSyntax: r'\ne',
      semanticText: 'Tidak sama dengan',
      type: MathSymbolType.operator,
    ),

    // Fraction

    const MathSymbol(
      id: 'frac',
      visualLabel: '□/□',
      renderSyntax: r'\frac{□}{□}',
      semanticText: 'Pecahan',
      slotCount: 2,
      type: MathSymbolType.fraction,
    ),

    // Square root

    const MathSymbol(
      id: 'sqrt',
      visualLabel: '√□',
      renderSyntax: r'\sqrt{□}',
      semanticText: 'Akar kuadrat',
      slotCount: 1,
      type: MathSymbolType.root,
    ),

    // nth root

    const MathSymbol(
      id: 'root_n',
      visualLabel: 'ⁿ√□',
      renderSyntax: r'\sqrt[□]{□}',
      semanticText: 'Akar pangkat n',
      slotCount: 2,
      type: MathSymbolType.root,
    ),

    // Power

    const MathSymbol(
      id: 'power',
      visualLabel: '□^□',
      renderSyntax: r'□^{□}',
      semanticText: 'Pangkat',
      slotCount: 2,
      type: MathSymbolType.power,
    ),

    // Percent

    const MathSymbol(
      id: 'percent',
      visualLabel: '%',
      renderSyntax: r'\%',
      semanticText: 'Persen',
      type: MathSymbolType.operator,
    ),

    // Decimal

    const MathSymbol(
      id: 'dot',
      visualLabel: '.',
      renderSyntax: '.',
      semanticText: 'Titik desimal',
      type: MathSymbolType.operator,
    ),

    // Constants

    const MathSymbol(
      id: 'pi',
      visualLabel: 'π',
      renderSyntax: r'\pi',
      semanticText: 'Pi',
      type: MathSymbolType.text,
    ),

    const MathSymbol(
      id: 'infinity',
      visualLabel: '∞',
      renderSyntax: r'\infty',
      semanticText: 'Tak hingga',
      type: MathSymbolType.text,
    ),
  ];

  // Kategori 1: Fungsi & Logaritma
  static final List<MathSymbol> functionsCategory = [
    // Absolute value

    const MathSymbol(
      id: 'abs',
      visualLabel: '|□|',
      renderSyntax: r'\left|□\right|',
      semanticText: 'Nilai mutlak',
      slotCount: 1,
      type: MathSymbolType.parens,
    ),

    // Function f(x)

    const MathSymbol(
      id: 'fx',
      visualLabel: 'f(□)',
      renderSyntax: 'f(□)',
      semanticText: 'Fungsi f',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    const MathSymbol(
      id: 'fxy',
      visualLabel: 'f(□,□)',
      renderSyntax: 'f(□,□)',
      semanticText: 'Fungsi f dengan dua argumen',
      slotCount: 2,
      type: MathSymbolType.function,
    ),

    // Natural logarithm

    const MathSymbol(
      id: 'ln',
      visualLabel: 'ln(□)',
      renderSyntax: r'\ln(□)',
      semanticText: 'Logaritma natural',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // Logarithm

    const MathSymbol(
      id: 'log',
      visualLabel: 'log(□)',
      renderSyntax: r'\log(□)',
      semanticText: 'Logaritma',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // Log base

    const MathSymbol(
      id: 'log_base',
      visualLabel: 'log□(□)',
      renderSyntax: r'\log_{□}(□)',
      semanticText: 'Logaritma dengan basis',
      slotCount: 2,
      type: MathSymbolType.function,
    ),

    // log base 10

    const MathSymbol(
      id: 'log10',
      visualLabel: 'log₁₀(□)',
      renderSyntax: r'\log_{10}(□)',
      semanticText: 'Logaritma basis sepuluh',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // log base 2

    const MathSymbol(
      id: 'log2',
      visualLabel: 'log₂(□)',
      renderSyntax: r'\log_{2}(□)',
      semanticText: 'Logaritma basis dua',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // Exponential

    const MathSymbol(
      id: 'exp',
      visualLabel: 'exp(□)',
      renderSyntax: r'\exp(□)',
      semanticText: 'Fungsi eksponensial',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // Signum

    const MathSymbol(
      id: 'sign',
      visualLabel: 'sgn(□)',
      renderSyntax: r'\operatorname{sgn}(□)',
      semanticText: 'Fungsi signum',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // Factorial

    const MathSymbol(
      id: 'fact',
      visualLabel: '□!',
      renderSyntax: '□!',
      semanticText: 'Faktorial',
      slotCount: 1,
      type: MathSymbolType.function,
    ),

    // Subscript

    const MathSymbol(
      id: 'subscript',
      visualLabel: '□₍□₎',
      renderSyntax: r'□_{□}',
      semanticText: 'Indeks bawah',
      slotCount: 2,
      type: MathSymbolType.subscript,
    ),

    // Vector

    const MathSymbol(
      id: 'vector',
      visualLabel: '⟨□,□,□⟩',
      renderSyntax: '⟨□,□,□⟩',
      semanticText: 'Vektor tiga dimensi',
      slotCount: 3,
      type: MathSymbolType.text,
    ),

    // Complex number

    const MathSymbol(
      id: 'var_i',
      visualLabel: 'i',
      renderSyntax: 'i',
      semanticText: 'Unit imajiner i',
      type: MathSymbolType.text,
    ),

    const MathSymbol(
      id: 'const_e',
      visualLabel: 'e',
      renderSyntax: 'e',
      semanticText: 'Konstanta Euler e',
      type: MathSymbolType.text,
    ),

    // Complex conjugate

    const MathSymbol(
      id: 'z_bar',
      visualLabel: 'z̄',
      renderSyntax: r'\bar{z}',
      semanticText: 'Konjugat kompleks z',
      type: MathSymbolType.text,
    ),

    // Binomial coefficient

    const MathSymbol(
      id: 'binom',
      visualLabel: 'C(□,□)',
      renderSyntax: r'\binom{□}{□}',
      semanticText: 'Koefisien binomial',
      slotCount: 2,
      type: MathSymbolType.function,
    ),

    // Permutation

    const MathSymbol(
      id: 'perm',
      visualLabel: 'P(□,□)',
      renderSyntax: 'P(□,□)',
      semanticText: 'Permutasi',
      slotCount: 2,
      type: MathSymbolType.function,
    ),

    // Combination

    const MathSymbol(
      id: 'comb',
      visualLabel: 'C(□,□)',
      renderSyntax: 'C(□,□)',
      semanticText: 'Kombinasi',
      slotCount: 2,
      type: MathSymbolType.function,
    ),
  ];

  // Kategori 2: Trigonometri & Hiperbolik
  static final List<MathSymbol> trigCategory = [
    const MathSymbol(
      id: 'rad',
      visualLabel: 'rad',
      renderSyntax: 'rad',
      semanticText: 'Radian',
      type: MathSymbolType.text,
    ),
    const MathSymbol(
      id: 'sin',
      visualLabel: 'sin(□)',
      renderSyntax: r'\sin(□)',
      semanticText: 'Sinus dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'cos',
      visualLabel: 'cos(□)',
      renderSyntax: r'\cos(□)',
      semanticText: 'Kosinus dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'tan',
      visualLabel: 'tan(□)',
      renderSyntax: r'\tan(□)',
      semanticText: 'Tangen dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'cot',
      visualLabel: 'cot(□)',
      renderSyntax: r'\cot(□)',
      semanticText: 'Kotangen dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'sec',
      visualLabel: 'sec(□)',
      renderSyntax: r'\sec(□)',
      semanticText: 'Sekan dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'csc',
      visualLabel: 'csc(□)',
      renderSyntax: r'\csc(□)',
      semanticText: 'Kosekan dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arcsin',
      visualLabel: 'arcsin(□)',
      renderSyntax: r'\arcsin(□)',
      semanticText: 'Arkus sinus dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arccos',
      visualLabel: 'arccos(□)',
      renderSyntax: r'\arccos(□)',
      semanticText: 'Arkus kosinus dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arctan',
      visualLabel: 'arctan(□)',
      renderSyntax: r'\arctan(□)',
      semanticText: 'Arkus tangen dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arccot',
      visualLabel: 'arccot(□)',
      renderSyntax: r'\arccot(□)',
      semanticText: 'Arkus kotangen dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arcsec',
      visualLabel: 'arcsec(□)',
      renderSyntax: r'\arcsec(□)',
      semanticText: 'Arkus sekan dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arccsc',
      visualLabel: 'arccsc(□)',
      renderSyntax: r'\arccsc(□)',
      semanticText: 'Arkus kosekan dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'sinh',
      visualLabel: 'sinh(□)',
      renderSyntax: r'\sinh(□)',
      semanticText: 'Sinus hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'cosh',
      visualLabel: 'cosh(□)',
      renderSyntax: r'\cosh(□)',
      semanticText: 'Kosinus hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'tanh',
      visualLabel: 'tanh(□)',
      renderSyntax: r'\tanh(□)',
      semanticText: 'Tangen hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'coth',
      visualLabel: 'coth(□)',
      renderSyntax: r'\coth(□)',
      semanticText: 'Kotangen hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arsinh',
      visualLabel: 'arsinh(□)',
      renderSyntax: r'\operatorname{arsinh}(□)',
      semanticText: 'Arkus sinus hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arcosh',
      visualLabel: 'arcosh(□)',
      renderSyntax: r'\operatorname{arcosh}(□)',
      semanticText: 'Arkus kosinus hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'artanh',
      visualLabel: 'artanh(□)',
      renderSyntax: r'\operatorname{artanh}(□)',
      semanticText: 'Arkus tangen hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
    const MathSymbol(
      id: 'arcoth',
      visualLabel: 'arcoth(□)',
      renderSyntax: r'\operatorname{arcoth}(□)',
      semanticText: 'Arkus kotangen hiperbolik dari kotak',
      slotCount: 1,
      type: MathSymbolType.function,
    ),
  ];

  // Kategori 3: Kalkulus & Limit
  static final List<MathSymbol> calculusCategory = [
    // --------------------------------------------------
    // LIMIT
    // --------------------------------------------------

    const MathSymbol(
      id: 'lim',
      visualLabel: 'lim',
      renderSyntax: r'\lim_{□ \to □} □',
      semanticText: 'Limit',
      slotCount: 3,
      type: MathSymbolType.limit,
    ),

    // --------------------------------------------------
    // DERIVATIVE
    // --------------------------------------------------

    const MathSymbol(
      id: 'ddx',
      visualLabel: 'd/dx □',
      renderSyntax: r'\frac{d}{dx} □',
      semanticText: 'Turunan terhadap x',
      slotCount: 1,
      type: MathSymbolType.derivative,
    ),

    const MathSymbol(
      id: 'd_dvar',
      visualLabel: 'd/d□ □',
      renderSyntax: r'\frac{d}{d□} □',
      semanticText: 'Turunan terhadap variabel',
      slotCount: 2,
      type: MathSymbolType.derivative,
    ),

    const MathSymbol(
      id: 'd2_dx2',
      visualLabel: 'd²/dx² □',
      renderSyntax: r'\frac{d^2}{dx^2} □',
      semanticText: 'Turunan kedua terhadap x',
      slotCount: 1,
      type: MathSymbolType.derivative,
    ),

    // --------------------------------------------------
    // INTEGRAL
    // --------------------------------------------------

    const MathSymbol(
      id: 'int_indef',
      visualLabel: '∫ □ dx',
      renderSyntax: r'\int □\,dx',
      semanticText: 'Integral tak tentu terhadap x',
      slotCount: 1,
      type: MathSymbolType.integral,
    ),

    const MathSymbol(
      id: 'int_def',
      visualLabel: '∫□^□ □',
      renderSyntax: r'\int_{□}^{□} □',
      semanticText: 'Integral tentu',
      slotCount: 3,
      type: MathSymbolType.integral,
    ),

    // --------------------------------------------------
    // DIFFERENTIAL
    // --------------------------------------------------

    const MathSymbol(
      id: 'dx',
      visualLabel: 'dx',
      renderSyntax: 'dx',
      semanticText: 'Diferensial d x',
      type: MathSymbolType.text,
    ),

    const MathSymbol(
      id: 'dy',
      visualLabel: 'dy',
      renderSyntax: 'dy',
      semanticText: 'Diferensial d y',
      type: MathSymbolType.text,
    ),

    const MathSymbol(
      id: 'dvar',
      visualLabel: 'd□',
      renderSyntax: 'd□',
      semanticText: 'Diferensial dari variabel',
      slotCount: 1,
      type: MathSymbolType.text,
    ),

    // --------------------------------------------------
    // SUMMATION
    // --------------------------------------------------

    const MathSymbol(
      id: 'summation',
      visualLabel: '∑',
      renderSyntax: r'\sum_{□=□}^{□} □',
      semanticText: 'Sigma penjumlahan',
      slotCount: 4,
      type: MathSymbolType.summation,
    ),

    // --------------------------------------------------
    // SEQUENCE
    // --------------------------------------------------

    const MathSymbol(
      id: 'seq_a_n',
      visualLabel: 'aₙ',
      renderSyntax: r'a_{□}',
      semanticText: 'Suku barisan a dengan indeks',
      slotCount: 1,
      type: MathSymbolType.subscript,
    ),

    const MathSymbol(
      id: 'y_prime',
      visualLabel: 'y′',
      renderSyntax: "y'",
      semanticText: 'y aksen',
      type: MathSymbolType.text,
    ),

    const MathSymbol(
      id: 'y_double_prime',
      visualLabel: 'y″',
      renderSyntax: "y''",
      semanticText: 'y dua aksen',
      type: MathSymbolType.text,
    ),
  ];

  static final List<String> qwertyRow1 = ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'];
  static final List<String> qwertyRow2 = ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'];
  static final List<String> qwertyRow3 = ['z', 'x', 'c', 'v', 'b', 'n', 'm'];
}