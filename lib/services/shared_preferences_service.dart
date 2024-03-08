import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/recordings_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/recording_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/recording_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This function is only executed once per app lifecycle namely for the initialization
// and loades all the data i.e. the setups with their stopwatches
Future<void> _loadData(List<SetupModel> setups, String key) async {
  final prefs = await SharedPreferences.getInstance();
  // loades the next stopwatch id (so it is unique)
  StopwatchModel.nextId = prefs.getInt("nextStopwatchId") ?? 1;
  // loades the setups with their stopwatchs
  List<String> jsons = prefs.getStringList(key) ?? [];
  for (String json in jsons) {
    SetupModel loaded = SetupModel.fromJson(jsonDecode(json));
    SetupModel setup = SetupModel(loaded.name, loaded.id, loaded.criterion,
        loaded.direction, loaded.stopwatches);
    setups.add(setup);
  }
}

// This function is a wrapper around the loadData (without the release build doesn't work)
loadStart(StartController startController) async {
  _loadData(startController.allSetups, startController.sharedPreferencesKey)
      .then((value) => startController.refreshBadgeState());
}

// This function is only executed once per app lifecycle namely for the initialization
// and loades the settings
Future<void> loadSettings(SettingsModel settingsModel) async {
  final prefs = await SharedPreferences.getInstance();
  String? json = prefs.getString("settings");
  if (json != null) {
    settingsModel.copyFrom(json);
  }
}

// This function stores the settings into shared preferences
Future<void> storeSettings(SettingsModel settings) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString("settings", jsonEncode(settings));
}

// This function gets executed everytime a user opens the recordings page
// and loades all the recordings and then calls the function so it creates
// the set of cards to be displayed
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

// Only for debugging
Future<void> logAllSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  log("\nlogAllSharedPreferences\n\n");
  var keys = prefs.getKeys();
  for (var key in keys) {
    log("$key: ${prefs.get(key)}");
  }
  log("\nlogAllSharedPreferences end\n\n");
}

// Only for debugging
Future<void> resetSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

// This function turns the given stopwatchModel into a recording and then saves 
// the recording into shared preferences recordings list
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

// This function stores the data i.e. next stopwatch id and all the setups
// with their stopwatchs into shared preferences, can get executed periodically
Future<void> storeData(List<SetupModel> setups, String key) async {
  final prefs = await SharedPreferences.getInstance();
  // stores the next stopwatch id (so it is unique)
  prefs.setInt("nextStopwatchId", StopwatchModel.nextId);
  // stores the setups with their stopwatchs
  List<String> jsons = [];
  for (SetupModel setupModel in setups) {
    jsons.add(jsonEncode(setupModel));
  }
  prefs.setStringList(key, jsons);
}

// This function stores all the recordings into shared preferences
// and is used when some recordings got deleted or the were read and some state chages
// (use when more than one changed or some got deleted)
Future<void> storeRecordingsState(
    RecordingsPageController recordingsPageController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = [];
  for (RecordingCard card in recordingsPageController.recordingCards) {
    recordings.add(jsonEncode(card.recordingModel));
  }
  prefs.setStringList("recordings", recordings);
}

// This function overrides a recording in shared preferences with the given one
// and is used when a recording got renamed (use when only one recording changes)
Future<void> storeRecordingState(RecordingModel model) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = prefs.getStringList("recordings") ?? [];
  // iterate over the recordings and only the correct one should be removed
  recordings.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  // and then added the updated one
  recordings.add(jsonEncode(model));
  prefs.setStringList("recordings", recordings);
}
