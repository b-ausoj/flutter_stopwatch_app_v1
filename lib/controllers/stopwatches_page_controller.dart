import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';
import 'package:flutter_stopwatch_app_v1/utils/snackbar_utils.dart';
import 'package:flutter_stopwatch_app_v1/utils/sorting.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_card.dart';

class StopwatchesPageController extends BadgeController {
  // TODO: auf github schauen wo überall die cardsCount aktualisiert wird

  BuildContext context;

  final List<StopwatchCard> _stopwatchCards = [];
  final List<String> _oldStopwatchesPage = [];
  String name;

  SortCriterion _order = SortCriterion.creationDate;
  SortDirection _direction = SortDirection.ascending;

  StopwatchesPageController(this.context, this.name);

  get order => _order;
  get orientation => _direction;

  get stopwatchCards => _stopwatchCards;

  Future<void> addStopwatch() async {
    int id = StopwatchModel.nextId++;
    // TODO: not taking the card count but the highest number a stopwatch has in "Athlete X" or cardsCount (whatever is bigger)
    _stopwatchCards.add(StopwatchCard("Athlete ${_stopwatchCards.length + 1}",
        (int id, String name) => deleteStopwatch(id, name), changedState, id,
        key: Key("$id"), stopwatchesPageController: this));
    storeStopwatchesPageState(this);
    changedState();
  }

  void changedState() {
    sortAndListCards(_stopwatchCards, _order, _direction);
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
    storeStopwatchesPageState(this);
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
        element.id == id &&
        element.stopwatchModel.state != StopwatchState.running);
    if (index == -1) {
      showShortSnackBar(context, "Can't delete while running");
      return;
    }
    StopwatchCard deleted = _stopwatchCards.removeAt(index);
    storeStopwatchesPageState(this);
    showLongSnackBar(context, "'$name' has been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              _stopwatchCards.add(deleted);
              _stopwatchCards.length;
              changedState();
              storeStopwatchesPageState(this);
            }));
  }

  @override
  void refreshBadgeState() {
    isMenuBadgeRequired(name).then((value) => badgeVisible = value);
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
    storeStopwatchesPageState(this);
    showLongSnackBar(context, "All stopwatches has been reseted",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              for (var element in _stopwatchCards) {
                element.stopwatchModel.restore();
                storeStopwatchesPageState(this);
              }
            }));
  }

  void restoreAllStopwatches(List<String> oldStopwatchesPage) {
    _stopwatchCards.clear();
    for (String entry in oldStopwatchesPage) {
      dynamic json = jsonDecode(entry);
      _stopwatchCards.add(StopwatchCard(
        json["name"],
        (int id, String name) => deleteStopwatch(id, name),
        changedState,
        json["id"],
        key: Key("${json["id"]}"),
        json: json,
        stopwatchesPageController: this,
      ));
    }
    storeStopwatchesPageState(this);
  }

  void setSorting(SortCriterion order, SortDirection direction) {
    _order = order;
    _direction = direction;
    changedState();
    storeStopwatchesPageState(this); // TODO: a bit redundant
  }

  void startAllStopwatches() {
    for (var element in _stopwatchCards) {
      element.stopwatchModel.start();
    }
    storeStopwatchesPageState(this);
  }

  bool isFabActive() {
    return stopwatchCards.isNotEmpty &&
        stopwatchCards.every((element) =>
            element.stopwatchModel.state == StopwatchState.reseted);
  }
}
