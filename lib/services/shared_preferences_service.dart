import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/recordings_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/recording_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/recording_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This function is only executed once per app lifecycle namely for the initialization
Future<void> loadData(List<SetupModel> setups, String key) async {
  final prefs = await SharedPreferences.getInstance();
  StopwatchModel.nextId = prefs.getInt("nextStopwatchId") ?? 1;
  List<String> jsons = prefs.getStringList(key) ?? [];
  for (String json in jsons) {
    setups.add(SetupModel.fromJson(jsonDecode(json)));
  }
}

Future<void> loadSettings(SettingsModel settingsModel) async {
  final prefs = await SharedPreferences.getInstance();
  String? json = prefs.getString("settings");
  if (json != null) {
    settingsModel.copyFrom(json);
  }
}

Future<void> storeSettings(SettingsModel settings) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("settings", jsonEncode(settings));
}

Future<void> loadRecordings(
    RecordingsPageController recordingsPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = prefs.getStringList("recordings") ?? [];
  for (String entry in recordings.reversed) {
    recordingsPageController.recordingCards.add(RecordingCard(
      recordingsPageController.deleteRecoding,
      recordingsPageController.settings,
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

Future<void> logAllSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  log("\nlogAllSharedPreferences\n\n");
  var keys = prefs.getKeys();
  for (var key in keys) {
    log("$key: ${prefs.get(key)}");
  }
  log("\nlogAllSharedPreferences end\n\n");
}

Future<void> resetSharedPreferences() async {
  // TODO: only for debugging
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<void> saveStopwatch(
    StopwatchModel stopwatchModel, String setupName) async {
  final prefs = await SharedPreferences.getInstance();
  RecordingModel.nextId = prefs.getInt("nextRecordingId") ?? 1;
  RecordingModel model = RecordingModel(
      RecordingModel.nextId++,
      stopwatchModel.name,
      stopwatchModel.startTimestamp,
      false,
      setupName,
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

// TODO: Should test this function
Future<void> storeData(List<SetupModel> setups, String key) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt("nextStopwatchId", StopwatchModel.nextId);
  List<String> jsons = [];
  for (SetupModel setupModel in setups) {
    jsons.add(jsonEncode(setupModel));
  }
  prefs.setStringList(key, jsons);
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

Future<void> storeRecordingState(RecordingModel model) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = prefs.getStringList("recordings") ?? [];
  recordings.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  recordings.add(jsonEncode(model));
  prefs.setStringList("recordings", recordings);
}
