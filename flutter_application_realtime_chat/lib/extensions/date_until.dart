import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateUntil {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }
    return '${sent.day} ${convertNumberToMonth(sent.month)}';
  }

  static String getLastActiveTime(
      {required BuildContext context, required String lastActive}) {
    final int i = int.tryParse(lastActive) ?? -1;
    if (i == -1) return 'Last seen not available';
    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen today at $formattedTime';
    }
    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }
    String month = convertNumberToMonth(time.month);
    return 'Last seen on ${time.day} $month on $formattedTime';
  }

  static String convertNumberToMonth(int monthNumber) {
    return monthNumber == 1
        ? 'Jan'
        : monthNumber == 2
            ? 'Feb'
            : monthNumber == 3
                ? 'Mar'
                : monthNumber == 4
                    ? 'Apr'
                    : monthNumber == 5
                        ? 'May'
                        : monthNumber == 6
                            ? 'Jun'
                            : monthNumber == 7
                                ? 'Jul'
                                : monthNumber == 8
                                    ? 'Aug'
                                    : monthNumber == 9
                                        ? 'Sep'
                                        : monthNumber == 10
                                            ? 'Oct'
                                            : monthNumber == 11
                                                ? 'Nov'
                                                : monthNumber == 12
                                                    ? 'Dec'
                                                    : 'Invalid Month';
  }
}
