import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/stopwatch_card.dart';

buildSort(SortCriterion order, SortDirection orientation, SettingsModel settings) => ((StopwatchCard a, StopwatchCard b) {
  int sign = orientation == SortDirection.ascending ? 1 : -1;
  switch (order) {
    case SortCriterion.creationDate: // TODO: delete this case
      return 0;
    case SortCriterion.name:
      return sign * a.stopwatchModel.name.compareTo(b.stopwatchModel.name);
    case SortCriterion.longestTime:
      if (settings.seperateRunningStopped) {
        if (a.stopwatchModel.isRunning && !b.stopwatchModel.isRunning) return -1;
        if (!a.stopwatchModel.isRunning && b.stopwatchModel.isRunning) return 1;
      }
      return sign * a.stopwatchModel.elapsedTimeRounded.compareTo(b.stopwatchModel.elapsedTimeRounded);
    case SortCriterion.longestLapTime:
      if (settings.seperateRunningStopped) {
        if (a.stopwatchModel.isRunning && !b.stopwatchModel.isRunning) return -1;
        if (!a.stopwatchModel.isRunning && b.stopwatchModel.isRunning) return 1;
      }
      return sign * a.stopwatchModel.elapsedLapTimeRounded.compareTo(b.stopwatchModel.elapsedLapTimeRounded);
    default: // i dont know yet what to do if custom/reordable
      return 0;
  }
});

List<StopwatchCard> sortAndListCards(List<StopwatchCard> list, SortCriterion order, SortDirection orientation, SettingsModel settings) {
  list.sort(buildSort(order, orientation, settings));
  return list;
}

