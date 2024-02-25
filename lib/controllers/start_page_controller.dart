import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StartController extends BadgeController {
  final String sharedPreferencesKey;
  final List<SetupModel> setups = [];

  // needs the label/visible for the menu(drawr) icon an the setups list items
  // TODO: use better naming for the list
  List<bool> badgeVisibles = [];
  late final AppLifecycleListener appLifecycleListener;

  late Timer timer;

  void Function() refreshScreen;

  StartController(this.refreshScreen, this.sharedPreferencesKey) {
    loadData(setups, sharedPreferencesKey).then((value) {
      refreshBadgeState();
      refreshScreen();
    });
    appLifecycleListener = AppLifecycleListener(
        onPause: () => storeData(setups, sharedPreferencesKey));
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      storeData(setups, sharedPreferencesKey);
      log("");
      log("stored data controller\n");
      for (SetupModel setup in setups) {
        log(setup.toString());
      }
      log("");
    });
  }

  @override
  void refreshBadgeState() {
    badgeVisibles = List.filled(setups.length, false);
    // could do all of that in parallel instead of .then
    isMenuBadgeRequired("").then((value) => badgeVisible = value);
    getUnseenRecordingsCount().then((value) => badgeLabel = value);

    for (int i = 0; i < setups.length; i++) {
      isTextBadgeRequired(setups[i].name)
          .then((value) => badgeVisibles[i] = value);
    }
    refreshScreen(); // calls set state because start badge doesn't have a ticker with setState
  }

  void removeSetup(SetupModel setup) {
    setups.remove(setup);
    refreshScreen();
    refreshBadgeState();
  }
}
