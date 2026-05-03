import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime normalizeDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String formatToMonthYear(DateTime dateTime) {
    return DateFormat('MMM yyyy').format(dateTime);
  }

  static String formatToDayMonth(DateTime dateTime) {
    return DateFormat('EEE, MMM dd').format(dateTime);
  }
}
