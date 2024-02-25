import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/models/configuration_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StartController extends BadgeController {
  final String sharedPreferencesKey;
  final List<ConfigurationModel> configurations = [];

  // needs the label/visible for the menu(drawr) icon an the configuration list items
  // TODO: use better naming for the list
  List<bool> badgeVisibles = [];
  late final AppLifecycleListener appLifecycleListener;

  late Timer timer;

  void Function() refreshScreen;

  StartController(this.refreshScreen, this.sharedPreferencesKey) {
    loadData(configurations, sharedPreferencesKey).then((value) {
      refreshBadgeState();
      refreshScreen();
    });
    appLifecycleListener = AppLifecycleListener(
        onPause: () => storeData(configurations, sharedPreferencesKey));
    timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      storeData(configurations, sharedPreferencesKey);
      log("");
      log("stored data controller\n");
      for (ConfigurationModel configuration in configurations) {
        log(configuration.toString());
      }
      log("");
    });
  }

  @override
  void refreshBadgeState() {
    badgeVisibles = List.filled(configurations.length, false);
    // could do all of that in parallel instead of .then
    isMenuBadgeRequired("").then((value) => badgeVisible = value);
    getUnseenRecordingsCount().then((value) => badgeLabel = value);

    for (int i = 0; i < configurations.length; i++) {
      isTextBadgeRequired(configurations[i].name)
          .then((value) => badgeVisibles[i] = value);
    }
    refreshScreen(); // calls set state because start badge doesn't have a ticker with setState
  }

  void removeConfiguration(ConfigurationModel configuration) {
    configurations.remove(configuration);
    refreshScreen();
    refreshBadgeState();
  }
}
