import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_card.dart';

import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';

List<StopwatchCard> sortAndListCards(List<StopwatchCard> list, SortCriterion order, SortDirection orientation) {
  list.sort(buildSort(order, orientation));
  return list;
}

buildSort(SortCriterion order, SortDirection orientation) => ((StopwatchCard a, StopwatchCard b) {
  int sign = orientation == SortDirection.ascending ? 1 : -1;
  switch (order) {
    case SortCriterion.creationDate:
      return sign * a.id.compareTo(b.id);
    case SortCriterion.name:
      return sign * a.stopwatchModel.name.compareTo(b.stopwatchModel.name);
    case SortCriterion.longestTime:
      return sign * a.stopwatchModel.elapsedTimeRounded.compareTo(b.stopwatchModel.elapsedTimeRounded);
    case SortCriterion.longestLapTime:
      // TODO: wenn gestoppt, dann unten, nur aktive oben
      return sign * a.stopwatchModel.elapsedLapTimeRounded.compareTo(b.stopwatchModel.elapsedLapTimeRounded);
    default: // i dont know yet what to do if custom/reordable
      return 0;
  }
});

