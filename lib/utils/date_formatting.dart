import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatToMonthYear(DateTime dateTime) {
    return DateFormat('MMM yyyy').format(dateTime);
  }

  static String formatToDayMonth(DateTime dateTime) {
    return DateFormat('EEE, MMM dd').format(dateTime);
  }
}
