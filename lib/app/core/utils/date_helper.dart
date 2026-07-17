import 'package:intl/intl.dart';

class DateHelper {
  static String dateFormat(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
}