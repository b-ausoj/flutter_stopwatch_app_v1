// get all configurations and for every configuration get all stopwatches
// check for every stopwatch if it is running
// if one is running and its not the current configuration, show a badge at the menu burger
// if the navdrawer is open, show a badge at the corresponding configuration where the stopwatch is running

// TODO: BIG TODO: update this as no longer via shared preferences but via the list of setups

import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getAllRunningConfigurations() async {
  List<String> runningConfigurations = [];

  final prefs = await SharedPreferences.getInstance();
  List<String> allConfigurations = prefs.getStringList("configurations") ?? [];

  for (String configuration in allConfigurations) {
    List<String> allStopwatches = prefs.getStringList(configuration) ?? [];
    for (String stopwatch in allStopwatches) {
      dynamic json = jsonDecode(stopwatch);
      if (json["state"] == "${StopwatchState.running}") {
        runningConfigurations.add(configuration);
        break;
      }
    }
  }

  return runningConfigurations;
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

Future<bool> isBackBadgeRequired() async {
  return (await getAllRunningConfigurations()).isNotEmpty;
}

// menu badge only if there are any running stopwatches or new recordings entries
Future<bool> isMenuBadgeRequired(String configuration) async {
  // check if there are any running stopwatches
  List<String> runningConfigurations = await getAllRunningConfigurations();
  runningConfigurations.remove(configuration);
  if (runningConfigurations.isNotEmpty) {
    return true;
  }
  // check if there are any unseen recordings entries
  int unseenRecordingsCount = await getUnseenRecordingsCount();
  return unseenRecordingsCount > 0;
}

Future<bool> isTextBadgeRequired(String configuration) async {
  // check if there are any running stopwatches
  List<String> runningConfigurations = await getAllRunningConfigurations();
  return runningConfigurations.contains(configuration);
}
