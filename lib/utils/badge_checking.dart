// get all configurations and for every configuration get all stopwatches
// check for every stopwatch if it is running
// if one is running and its not the current configuration, show a badge at the menu burger
// if the navdrawer is open, show a badge at the corresponding configuration where the stopwatch is running

// TODO: BIG TODO: update this as no longer via shared preferences but via the list of setups

import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<SetupModel> getAllRunningConfigurations(List<SetupModel> allSetups) {
  List<SetupModel> runningSetups = [];

  for (SetupModel setup in allSetups) {
    for (StopwatchModel stopwatch in setup.stopwatches) {
      if (stopwatch.isRunning) {
        runningSetups.add(setup);
        break;
      }
    }
  }

  return runningSetups;
}

Future<int> getUnseenRecordingsCount() async {
  int count = 0;

  final prefs = await SharedPreferences.getInstance();
  List<String> recordings = prefs.getStringList("recordings") ?? [];

  for (String entry in recordings) {
    dynamic json = jsonDecode(entry);
    if (!json["viewed"]) {
      count++;
    }
  }
  return count;
}

bool isBackBadgeRequired(List<SetupModel> allSetups) {
  return getAllRunningConfigurations(allSetups).isNotEmpty;
}

// menu badge only if there are any running stopwatches or new recordings entries
Future<bool> isMenuBadgeRequired(
    List<SetupModel> allSetups, SetupModel? setup) async {
  // check if there are any running stopwatches
  List<SetupModel> runningSetups = getAllRunningConfigurations(allSetups);
  runningSetups.remove(setup);
  if (runningSetups.isNotEmpty) {
    return true;
  }
  // check if there are any unseen recordings entries
  int unseenRecordingsCount = await getUnseenRecordingsCount();
  return unseenRecordingsCount > 0;
}

bool isTextBadgeRequired(List<SetupModel> allSetups, SetupModel setup) {
  // check if there are any running stopwatches
  List<SetupModel> runningConfigurations =
      getAllRunningConfigurations(allSetups);
  return runningConfigurations.contains(setup);
}
