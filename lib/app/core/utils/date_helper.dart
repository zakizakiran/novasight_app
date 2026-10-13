import 'package:intl/intl.dart';

class DateHelper {
  static String dateFormat(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }
  static String dateTimeFormat(DateTime date) {
    return DateFormat('d MMM yyyy, HH:mm:ss').format(date);
  }
}