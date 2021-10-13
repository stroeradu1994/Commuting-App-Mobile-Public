import 'package:commuting_app_mobile/utils/calendar_time.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeUtils {
  static toTimeAgoFromDateTime(DateTime dateTime) {
    return timeago.format(dateTime, allowFromNow: true, locale: 'ro');
  }

  static toTimeAgoFromString(String dateTime) {
    return toTimeAgoFromDateTime(DateTime.parse(dateTime.toString()));
  }

  static toCalendarTimeFromString(String dateTime) {
    return toCalendarTimeFromDateTime(DateTime.parse(dateTime));
  }

  static toCalendarTimeFromDateTime(DateTime dateTime) {
    return CalendarTime(dateTime).toHuman;
  }

  static getFormattedDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy | kk:mm').format(dateTime);
  }

  static getDateTime(String dateTime) {
    return DateTime.parse(dateTime);
  }

}