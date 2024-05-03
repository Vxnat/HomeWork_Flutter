import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUntil {
  // Format Date về kiểu dd/MM/yyyy
  static String formatDate(DateTime date) {
    // Tạo định dạng ngày mới
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    // Sử dụng định dạng để chuyển đổi DateTime thành chuỗi
    final String formattedDate = formatter.format(date);
    // Trả về chuỗi đã định dạng
    return formattedDate;
  }

  static String getFormattedTime(
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
