class DateFormat{
  static String formatTimeAgo(int milliseconds) {
  // Lấy thời điểm hiện tại
  DateTime now = DateTime.now();

  // Tạo đối tượng DateTime từ số milliseconds
  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(milliseconds);

  // Tính khoảng thời gian giữa timestamp và thời điểm hiện tại
  Duration difference = now.difference(timestamp);

  // Xử lý hiển thị thời gian "cách đây bao lâu"
  if (difference.inSeconds < 60) {
    return '${difference.inSeconds}s ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago ';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inDays}d ago';
  }
}

}