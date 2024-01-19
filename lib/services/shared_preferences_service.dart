import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/managers/home_manager.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/saved_stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadHomeState(HomeManager homeManager) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> home = prefs.getStringList("home") ?? [];
  for (String entry in home) {
    dynamic json = jsonDecode(entry);
    homeManager.stopwatchCards.add(StopwatchCard(
      json["name"],
      homeManager.deleteStopwatch,
      homeManager.changedState,
      json["id"],
      key: Key("${json["id"]}"),
      json: json,
    ));
  }
  StopwatchModel.nextId = prefs.getInt("nextStopwatchId") ?? 1;
  homeManager.setSorting(SortCriterion.values[prefs.getInt("order") ?? 0], SortDirection.values[prefs.getInt("direction") ?? 0]);
}

Future<void> resetSharedPreferences() async {
  // TODO: only for debugging
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
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

Future<void> storeHomeState(HomeManager homeManager) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> home = [];
  for (StopwatchCard card in homeManager.stopwatchCards) {
    home.add(jsonEncode(card.stopwatchModel));
  }
  prefs.setStringList("home", home);
  prefs.setInt("nextStopwatchId", StopwatchModel.nextId);
  prefs.setInt("order", SortCriterion.values.indexOf(homeManager.order));
  prefs.setInt("direction", SortDirection.values.indexOf(homeManager.orientation));
}

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
