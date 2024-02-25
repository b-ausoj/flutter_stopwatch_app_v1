import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/configuration_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';
import 'package:flutter_stopwatch_app_v1/utils/snackbar_utils.dart';
import 'package:flutter_stopwatch_app_v1/utils/sorting.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/stopwatch_card.dart';

class StopwatchesPageController extends BadgeController {
  BuildContext context;

  final List<StopwatchCard> _stopwatchCards = [];
  final List<String> _oldStopwatchesPage = [];
  ConfigurationModel configurationModel;

  StopwatchesPageController(this.context, this.configurationModel) {
    for (var element in configurationModel.stopwatches) {
      _stopwatchCards.add(StopwatchCard(
        element,
        changedState,
        key: Key("${element.id}"),
        stopwatchesPageController: this,
      ));
    }
  }

  get direction => configurationModel.direction;
  String get name => configurationModel.name;
  set name(String value) => configurationModel.name = value;
  get order => configurationModel.order;
  get stopwatchCards => _stopwatchCards;

  Future<void> addStopwatch() async {
    // TODO: not taking the card count but the highest number a stopwatch has in "Athlete X" or cardsCount (whatever is bigger)
    int id = StopwatchModel.nextId++;
    
    StopwatchModel model = StopwatchModel("Athlete ${_stopwatchCards.length + 1}", id);
    _stopwatchCards.add(StopwatchCard(model, changedState,
        key: Key("$id"), stopwatchesPageController: this));
    configurationModel.stopwatches.add(model);
    changedState();
  }

  void changedState() {
    sortAndListCards(_stopwatchCards, configurationModel.order,
        configurationModel.direction);
    refreshBadgeState();
  }

  void deleteAllStopwatches() {
    _oldStopwatchesPage.clear();
    for (StopwatchCard card in _stopwatchCards) {
      if (card.stopwatchModel.state == StopwatchState.running) {
        showShortSnackBar(context, "Can't delete while running");
        return;
      }
      _oldStopwatchesPage.add(jsonEncode(card.stopwatchModel));
    }
    _stopwatchCards.clear();
    showLongSnackBar(context, "All stopwatches have been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              restoreAllStopwatches(_oldStopwatchesPage);
              changedState();
            }));
  }

  void deleteStopwatch(int id, String name) {
    int index = _stopwatchCards.indexWhere((element) =>
        element.stopwatchModel.id == id &&
        element.stopwatchModel.state != StopwatchState.running);
    if (index == -1) {
      showShortSnackBar(context, "Can't delete while running");
      return;
    }
    StopwatchCard deleted = _stopwatchCards.removeAt(index);
    showLongSnackBar(context, "'$name' has been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              _stopwatchCards.add(deleted);
              _stopwatchCards.length;
              changedState();
            }));
  }

  bool isFabActive() {
    return stopwatchCards.isNotEmpty &&
        stopwatchCards.every((element) =>
            element.stopwatchModel.state == StopwatchState.reseted);
  }

  @override
  void refreshBadgeState() {
    isMenuBadgeRequired(configurationModel.name)
        .then((value) => badgeVisible = value);
    getUnseenRecordingsCount().then((value) => badgeLabel = value);
  }

  void resetAllStopwatches() {
    // save all in json string list
    // call everyone to reset itself
    // if undo then delete list and load json
    for (StopwatchCard card in _stopwatchCards) {
      if (card.stopwatchModel.state == StopwatchState.running) {
        showShortSnackBar(context, "Can't reset while running");
        return;
      }
    }
    for (StopwatchCard card in _stopwatchCards) {
      card.stopwatchModel.reset();
    }
    showLongSnackBar(context, "All stopwatches has been reseted",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              for (var element in _stopwatchCards) {
                element.stopwatchModel.restore();
              }
            }));
  }

  // TODO: implement
  void restoreAllStopwatches(List<String> oldStopwatchesPage) {
    _stopwatchCards.clear();
    for (String entry in oldStopwatchesPage) {
      dynamic json = jsonDecode(entry);
      _stopwatchCards.add(StopwatchCard(
        json["name"],
        changedState,
        key: Key("${json["id"]}"),
        stopwatchesPageController: this,
      ));
    }
  }

  void setSorting(SortCriterion order, SortDirection direction) {
    configurationModel.order = order;
    configurationModel.direction = direction;
    changedState();
  }

  void startAllStopwatches() {
    for (var element in _stopwatchCards) {
      element.stopwatchModel.start();
    }
  }
}
