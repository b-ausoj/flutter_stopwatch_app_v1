import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StartController extends BadgeController {
  final String sharedPreferencesKey;
  final List<SetupModel> allSetups = [];

  // needs the label/visible for the menu(drawr) icon an the setups list items
  // TODO: use better naming for the list
  List<bool> badgeVisibles = [];
  late final AppLifecycleListener appLifecycleListener;

  late Timer timer;

  void Function() refreshScreen;

  StartController(this.refreshScreen, this.sharedPreferencesKey) {
    loadData(allSetups, sharedPreferencesKey).then((value) {
      refreshBadgeState();
      refreshScreen();
    });
    appLifecycleListener = AppLifecycleListener(onStateChange: (_) => helper());
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      storeData(allSetups, sharedPreferencesKey);
      log("");
      log("stored data controller\n");
      for (SetupModel setup in allSetups) {
        log(setup.toString());
      }
      log("");
    });
  }

  void helper() {
    log("before");
    storeData(allSetups, sharedPreferencesKey).then((value) => log("after"));
  }

  @override
  void refreshBadgeState() {
    badgeVisibles = List.filled(allSetups.length, false);
    // could do all of that in parallel instead of .then
    isMenuBadgeRequired(allSetups, null).then((value) => badgeVisible = value);
    getUnseenRecordingsCount().then((value) => badgeLabel = value);

    for (int i = 0; i < allSetups.length; i++) {
      badgeVisibles[i] = isTextBadgeRequired(allSetups, allSetups[i]);
    }
    refreshScreen(); // calls set state because start badge doesn't have a ticker with setState
  }

  void removeSetup(SetupModel setup) {
    allSetups.remove(setup);
    refreshScreen();
    refreshBadgeState();
  }
}
