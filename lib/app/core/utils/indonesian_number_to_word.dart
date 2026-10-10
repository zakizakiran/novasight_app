
class IndonesianNumberToWords {
  static String convert(int number) {
    if (number < 0) {
      return 'negatif ${convert(-number)}';
    }

    if (number < 12) {
      return [
        'nol',
        'satu',
        'dua',
        'tiga',
        'empat',
        'lima',
        'enam',
        'tujuh',
        'delapan',
        'sembilan',
        'sepuluh',
        'sebelas',
      ][number];
    }

    if (number < 20) {
      return '${convert(number - 10)} belas';
    }

    if (number < 100) {
      final tens = number ~/ 10;
      final remainder = number % 10;

      return '${convert(tens)} puluh'
          '${remainder == 0 ? '' : ' ${convert(remainder)}'}';
    }

    if (number < 200) {
      return 'seratus${number == 100 ? '' : ' ${convert(number - 100)}'}';
    }

    if (number < 1000) {
      final remainder = number % 100;

      return '${convert(number ~/ 100)} ratus'
          '${remainder == 0 ? '' : ' ${convert(remainder)}'}';
    }

    if (number < 2000) {
      return 'seribu${number == 1000 ? '' : ' ${convert(number - 1000)}'}';
    }

    if (number < 1000000) {
      final remainder = number % 1000;

      return '${convert(number ~/ 1000)} ribu'
          '${remainder == 0 ? '' : ' ${convert(remainder)}'}';
    }

    if (number < 1000000000) {
      final remainder = number % 1000000;

      return '${convert(number ~/ 1000000)} juta'
          '${remainder == 0 ? '' : ' ${convert(remainder)}'}';
    }

    if (number < 1000000000000) {
      final remainder = number % 1000000000;

      return '${convert(number ~/ 1000000000)} miliar'
          '${remainder == 0 ? '' : ' ${convert(remainder)}'}';
    }

    return number.toString();
  }
}
