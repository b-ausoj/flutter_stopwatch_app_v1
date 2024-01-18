import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';

String durationToString(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    int hSeconds = duration.inMilliseconds ~/
        100 %
        10; // ~/ 10 % 100 for hunderts of a second
    return "${minutes < 10 ? "0$minutes" : "$minutes"}:${seconds < 10 ? "0$seconds" : "$seconds"}.$hSeconds";
  }

  String formatLapTimes(List<LapModel> lapTimes) {
    StringBuffer result = StringBuffer();
    for (LapModel lap in lapTimes) {
      result.write(
          "${durationToString(lap.lapTime)}${lap.id == lapTimes.length ? "" : "\n"}");
    }
    return result.toString();
  }

  String formatSplitTimes(List<LapModel> splitTimes) {
    StringBuffer result = StringBuffer();
    for (LapModel lap in splitTimes) {
      result.write(
          "${durationToString(lap.lapTime)}${lap.id == splitTimes.length ? "" : "\n"}");
    }
    return result.toString();
  }

  String formatLapCount(List<LapModel> lapTimes) {
    StringBuffer result = StringBuffer();
    for (LapModel lap in lapTimes) {
      result.write("\n${lap.id < 10 ? "0${lap.id}" : "${lap.id}"}");
    }
    return result.toString();
  }
