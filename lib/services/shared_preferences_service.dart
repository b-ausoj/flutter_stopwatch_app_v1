import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/home_controller.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/saved_stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logAllSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  log("logAllSharedPreferences");
  var keys = prefs.getKeys();
  for (var key in keys) {
    log("$key: ${prefs.get(key)}");
  }
  log("logAllSharedPreferences end");
}

Future<void> loadScreens(List<String> screens, List<StartController> startControllers, var update) async {
  screens.clear();
  final prefs = await SharedPreferences.getInstance();
  log("loadScreens${prefs.getStringList("screens")}");
  screens.addAll(prefs.getStringList("screens") ?? []);
  for (String screen in screens) {
    StartController controller = StartController(screen);
    startControllers.add(controller);
    controller.refreshBadgeState();
  }
  update();
}

Future<void> storeScreens(List<String> screens) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList("screens", screens);
}

Future<void> loadHomeState(HomeController homeController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> home = prefs.getStringList(homeController.name) ?? [];
  for (String entry in home) {
    dynamic json = jsonDecode(entry);
    log(json["name"]);
    homeController.stopwatchCards.add(StopwatchCard(
      json["name"],
      homeController.deleteStopwatch,
      homeController.changedState,
      json["id"],
      key: Key("${json["id"]}"),
      json: json,
      homeController: homeController,
    ));
  }
  StopwatchModel.nextId = prefs.getInt("nextStopwatchId") ?? 1;
  homeController.setSorting(SortCriterion.values[prefs.getInt("order") ?? 0], SortDirection.values[prefs.getInt("direction") ?? 0]);
  homeController.refreshBadgeState();
  Timer(const Duration(milliseconds: 100), () => log("after update badge${homeController.badgeLabel}"));
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
      false,
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

Future<void> storeHomeState(HomeController homeController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> home = [];
  for (StopwatchCard card in homeController.stopwatchCards) {
    home.add(jsonEncode(card.stopwatchModel));
    log(jsonEncode(card.stopwatchModel));
  }
  prefs.setStringList(homeController.name, home);
  prefs.setInt("nextStopwatchId", StopwatchModel.nextId);
  prefs.setInt("order", SortCriterion.values.indexOf(homeController.order));
  prefs.setInt("direction", SortDirection.values.indexOf(homeController.orientation));
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

Future<void> storeStopwatchState(StopwatchModel model, HomeController homeController) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> home = prefs.getStringList(homeController.name) ?? [];
  home.removeWhere(
    (element) => jsonDecode(element)["id"] == model.id,
  );
  home.add(jsonEncode(model));
  prefs.setStringList(homeController.name, home);
}
