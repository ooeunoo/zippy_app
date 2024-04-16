// import 'package:intl/intl.dart';

// DateTime getTodayDateTime() {
//   DateTime now = DateTime.now();
//   DateTime dateOnly = DateTime(now.year, now.month, now.day);
//   return dateOnly;
// }

// int? minuteToSecond(int? minutes) {
//   if (minutes == null) return null;
//   return minutes * 60;
// }

// String secondToMinute(int sec) {
//   return (sec / 60).toStringAsFixed(0);
// }

// String secondToMinuteSecond(int sec) {
//   int min = sec ~/ 60;
//   int remainSec = sec % 60;
//   String mm = min < 10 ? '0$min' : '$min';
//   String ss = remainSec < 10 ? '0$remainSec' : '$remainSec';
//   return '$mm:$ss';
// }

// String formatCreatedAt(DateTime createdAt) {
//   // 요일 포맷 형식 (한글화)
//   DateFormat dayFormat = DateFormat.EEEE('ko_KR');
//   // 시간 포맷 형식 (오전, 시간)
//   DateFormat timeFormat = DateFormat('a h:mm', 'ko_KR');

//   // 로컬 시간으로 적용
//   String day = dayFormat.format(createdAt.toLocal());
//   String time = timeFormat
//       .format(createdAt.toLocal())
//       .replaceFirst('AM', '오전')
//       .replaceFirst('PM', '오후');
//   return '$day, $time';
// }
