// get all screens and for every screen get all stopwatches
// check for every stopwatch if it is running
// if one is running and its not the current screen, show a badge at the menu burger
// if the navdrawer is open, show a badge at the corresponding screen where the stopwatch is running

import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<String>> getAllRunningScreens() async {
  List<String> runningScreens = [];

  final prefs = await SharedPreferences.getInstance();
  List<String> allScreens = prefs.getStringList("screens") ?? [];

  for (String screen in allScreens) {
    List<String> allStopwatches = prefs.getStringList(screen) ?? [];
    for (String stopwatch in allStopwatches) {
      dynamic json = jsonDecode(stopwatch);
      if (json["state"] == "${StopwatchState.running}") {
        runningScreens.add(screen);
        break;
      }
    }
  }

  return runningScreens;
}

Future<int> getUnseenRecordsCount() async {
  int count = 0;

  final prefs = await SharedPreferences.getInstance();
  List<String> history = prefs.getStringList("history") ?? [];

  for (String entry in history) {
    dynamic json = jsonDecode(entry);
    if (!json["viewed"]) {
      count++;
    }
  }
  return count;
}

// menu badge only if there are any running stopwatches or new records entries
Future<bool> isMenuBadgeRequired(String screen) async {
  // check if there are any running stopwatches
  List<String> runningScreens = await getAllRunningScreens();
  runningScreens.remove(screen);
  if (runningScreens.isNotEmpty) {
    return true;
  }
  // check if there are any unseen records entries
  int unseenRecordsCount = await getUnseenRecordsCount();
  return unseenRecordsCount > 0;
}

Future<bool> isTextBadgeRequired(String screen) async {
  // check if there are any running stopwatches
  List<String> runningScreens = await getAllRunningScreens();
  return runningScreens.contains(screen);
}
