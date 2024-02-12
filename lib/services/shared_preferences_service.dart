import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/recordings_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/controllers/stopwatches_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/recording_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/recording_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> loadScreens(List<String> screens, var update) async {
  screens.clear();
  final prefs = await SharedPreferences.getInstance();
  screens.addAll(prefs.getStringList("screens") ?? []);
  update();
}

Future<void> renameScreen(String oldName, String newName, var update) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> screens = prefs.getStringList("screens") ?? [];
  int indexToReplace = screens.indexOf(oldName);
  if (indexToReplace != -1) {
    screens[indexToReplace] = newName;
  }
  prefs.setStringList("screens", screens);

  List<String> stopwatchesPage = prefs.getStringList(oldName) ?? [];
  prefs.setStringList(newName, stopwatchesPage);
  prefs.remove(oldName);

  update();
}

Future<String> deleteScreen(String name) async {
  final prefs = await SharedPreferences.getInstance();

  List<String> screens = prefs.getStringList("screens") ?? [];
  String screen = screens.elementAt(screens.indexOf(name));
  screens.remove(name); //TODO: shoudl always be true
  prefs.setStringList("screens", screens);

  prefs.remove(name);

  return screen;
}

Future<void> restoreScreen(String name, String screen) async {}

Future<void> loadRecordings(
    RecordingsPageController recordingsPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = prefs.getStringList("recordings") ?? [];
  for (String entry in recordings.reversed) {
    recordingsPageController.recordingCards.add(RecordingCard(
      recordingsPageController.deleteRecoding,
      json: jsonDecode(entry),
      key: Key(entry),
    ));
  }
  recordingsPageController.recordingCards.sort(
    (a, b) =>
        -a.recordingModel.startingTime.compareTo(b.recordingModel.startingTime),
  );
  recordingsPageController.createRecordingList();
  recordingsPageController.refresh();
}

Future<void> storeRecordingsState(
    RecordingsPageController recordingsPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = [];
  for (RecordingCard card in recordingsPageController.recordingCards) {
    recordings.add(jsonEncode(card.recordingModel));
  }
  prefs.setStringList("recordings", recordings);
}

Future<void> loadStopwatchesPageState(
    StopwatchesPageController stopwatchesPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> stopwatchesPage =
      prefs.getStringList(stopwatchesPageController.name) ?? [];
  for (String entry in stopwatchesPage) {
    dynamic json = jsonDecode(entry);
    stopwatchesPageController.stopwatchCards.add(StopwatchCard(
      json["name"],
      stopwatchesPageController.deleteStopwatch,
      stopwatchesPageController.changedState,
      json["id"],
      key: Key("${json["id"]}"),
      json: json,
      stopwatchesPageController: stopwatchesPageController,
    ));
  }
  StopwatchModel.nextId = prefs.getInt("nextStopwatchId") ?? 1;
  stopwatchesPageController.setSorting(
      SortCriterion.values[prefs.getInt("order") ?? 0],
      SortDirection.values[prefs.getInt("direction") ?? 0]);
  stopwatchesPageController.refreshBadgeState();
}

Future<void> logAllSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  log("logAllSharedPreferences");
  var keys = prefs.getKeys();
  for (var key in keys) {
    log("$key: ${prefs.get(key)}");
  }
  log("logAllSharedPreferences end");
}

Future<void> resetSharedPreferences() async {
  // TODO: only for debugging
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<void> saveStopwatch(
    StopwatchModel stopwatchModel, String screenName) async {
  final prefs = await SharedPreferences.getInstance();
  RecordingModel.nextId = prefs.getInt("nextRecordingId") ?? 1;
  RecordingModel model = RecordingModel(
      RecordingModel.nextId++,
      stopwatchModel.name,
      stopwatchModel.startTimestamp,
      false,
      screenName,
      stopwatchModel.elapsedTime);
  model.lapTimes = stopwatchModel.lapList;
  model.lapTimes.add(
      LapModel(stopwatchModel.lapCount + 1, stopwatchModel.elapsedLapTime));
  Duration split = Duration.zero;
  for (LapModel lap in model.lapTimes) {
    model.splitTimes.add(LapModel(lap.id, split = lap.lapTime + split));
  }
  List<String> recordings = prefs.getStringList("recordings") ?? [];
  recordings.add(jsonEncode(model));
  prefs.setStringList("recordings", recordings);
  prefs.setInt("nextRecordingId", RecordingModel.nextId);
  stopwatchModel.reset();
}

Future<void> storeRecordingState(RecordingModel model) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = prefs.getStringList("recordings") ?? [];
  recordings.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  recordings.add(jsonEncode(model));
  prefs.setStringList("recordings", recordings);
}

Future<void> storeScreens(List<String> screens) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList("screens", screens);
}

Future<void> storeStopwatchesPageState(
    StopwatchesPageController stopwatchesPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> stopwatchesPage = [];
  for (StopwatchCard card in stopwatchesPageController.stopwatchCards) {
    stopwatchesPage.add(jsonEncode(card.stopwatchModel));
  }
  prefs.setStringList(stopwatchesPageController.name, stopwatchesPage);
  prefs.setInt("nextStopwatchId", StopwatchModel.nextId);
  prefs.setInt(
      "order", SortCriterion.values.indexOf(stopwatchesPageController.order));
  prefs.setInt("direction",
      SortDirection.values.indexOf(stopwatchesPageController.orientation));
}

Future<void> storeStopwatchState(StopwatchModel model,
    StopwatchesPageController stopwatchesPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> stopwatchesPage =
      prefs.getStringList(stopwatchesPageController.name) ?? [];
  stopwatchesPage.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  stopwatchesPage.add(jsonEncode(model));
  prefs.setStringList(stopwatchesPageController.name, stopwatchesPage);
}
