import 'package:cloud_firestore/cloud_firestore.dart';

String formatFirebaseTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String formattedDate = "${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
  String formattedTime = "${_formatHour(dateTime.hour)}:${_formatMinute(dateTime.minute)}";

  return "$formattedDate at $formattedTime";
}

String _getMonthName(int month) {
  const monthNames = [
    "", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return monthNames[month];
}

String _formatHour(int hour) {
  return hour < 10 ? "0$hour" : "$hour";
}

String _formatMinute(int minute) {
  return minute < 10 ? "0$minute" : "$minute";
}
