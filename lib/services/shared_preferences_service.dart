import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/saved_stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeSavedStopwatchState(SavedStopwatchModel model) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList("history") ?? [];
  history.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  history.add(jsonEncode(model));
  prefs.setStringList("history", history);
}

Future<void> storeStopwatchState(StopwatchModel model) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> home = prefs.getStringList("home") ?? [];
  home.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  home.add(jsonEncode(model));
  prefs.setStringList("home", home);
}

Future<void> saveStopwatch(StopwatchModel stopwatchModel) async {
  final prefs = await SharedPreferences.getInstance();
  SavedStopwatchModel.nextId = prefs.getInt("nextSavedStopwatchId") ?? 1;
  SavedStopwatchModel model = SavedStopwatchModel(
      SavedStopwatchModel.nextId++,
      stopwatchModel.name,
      stopwatchModel.startTimestamp,
      stopwatchModel.elapsedTime);
  model.lapTimes = stopwatchModel.lapList;
  model.lapTimes.add(
      LapModel(stopwatchModel.lapCount + 1, stopwatchModel.elapsedLapTime));
  Duration split = Duration.zero;
  for (LapModel lap in model.lapTimes) {
    model.splitTimes.add(LapModel(lap.id, split = lap.lapTime + split));
  }
  List<String> history = prefs.getStringList("history") ?? [];
  history.add(jsonEncode(model));
  prefs.setStringList("history", history);
  prefs.setInt("nextSavedStopwatchId", SavedStopwatchModel.nextId);
  stopwatchModel.reset();
}
