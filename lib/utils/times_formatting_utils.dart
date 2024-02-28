import 'package:flutter_stopwatch_app_v1/enums/time_format.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';

String dateTimeToString(DateTime dateTime) {
  String d = dateTime.day < 10 ? "0${dateTime.day}" : "${dateTime.day}";
  String m = dateTime.month < 10 ? "0${dateTime.month}" : "${dateTime.month}";
  String y = "${dateTime.year}";
  String h = dateTime.hour < 10 ? "0${dateTime.hour}" : "${dateTime.hour}";
  String min =
      dateTime.minute < 10 ? "0${dateTime.minute}" : "${dateTime.minute}";
  //String sec = dateTime.second < 10 ? "0${dateTime.second}" : "${dateTime.second}";
  return "$h:$min $d.$m.$y";
}

String durationToString(Duration duration) {
  int minutes = duration.inMinutes;
  int seconds = duration.inSeconds % 60;
  int hSeconds = duration.inMilliseconds ~/
      100 %
      10; // ~/ 10 % 100 for hunderts of a second
  return "${minutes < 10 ? "0$minutes" : "$minutes"}:${seconds < 10 ? "0$seconds" : "$seconds"}.$hSeconds";
}

String durationToStringExport(Duration duration, TimeFormat timeFormat) {
  if (timeFormat == TimeFormat.mmsshs) return durationToString(duration);
  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;
  return "${hours < 10 ? "0$hours" : "$hours"}:${minutes < 10 ? "0$minutes" : "$minutes"}:${seconds < 10 ? "0$seconds" : "$seconds"}";
}

String formatLapCount(List<LapModel> lapTimes) {
  StringBuffer result = StringBuffer();
  for (LapModel lap in lapTimes) {
    result.write("\n${lap.id < 10 ? "0${lap.id}" : "${lap.id}"}");
  }
  return result.toString();
}

String formatLapTimes(List<LapModel> lapTimes) {
  StringBuffer result = StringBuffer();
  for (LapModel lap in lapTimes) {
    result.write(
        "${durationToString(lap.lapTime)}${lap.id == lapTimes.length ? "" : "\n"}");
  }
  return result.toString();
}

String formatPastLaps(List<LapModel> lapList, bool showAllLaps) {
  if (lapList.isEmpty) {
    return "";
  } else if (showAllLaps) {
    StringBuffer result = StringBuffer();
    for (LapModel lap in lapList.reversed) {
      result.write(
          "${lap.id < 10 ? "0${lap.id}" : "${lap.id}"} ${durationToString(lap.lapTime)}${lap.id == 1 ? "" : "\n"}");
    }
    return result.toString();
  } else {
    LapModel lap = lapList.last;
    return "${lap.id < 10 ? "0${lap.id}" : "${lap.id}"} ${durationToString(lap.lapTime)}";
  }
}
