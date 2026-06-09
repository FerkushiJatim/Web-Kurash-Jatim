import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _fullDate = DateFormat('dd MMMM yyyy', 'id_ID');
  static final DateFormat _shortDate = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _dateTime =
      DateFormat('dd MMM yyyy, HH:mm', 'id_ID');
  static final DateFormat _monthYear = DateFormat('MMMM yyyy', 'id_ID');
  static final DateFormat _dayName = DateFormat('EEEE', 'id_ID');

  static String fullDate(DateTime date) => _fullDate.format(date);
  static String shortDate(DateTime date) => _shortDate.format(date);
  static String dateTime(DateTime date) => _dateTime.format(date);
  static String monthYear(DateTime date) => _monthYear.format(date);
  static String dayName(DateTime date) => _dayName.format(date);
}

