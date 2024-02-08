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

class HomeController extends BadgeController {
  // TODO: auf github schauen wo überall die cardsCount aktualisiert wird

  BuildContext context;

  final List<StopwatchCard> _stopwatchCards = [];
  final List<String> _oldHome = [];
  @override
  String name;

  int _cardsCount = 0;
  SortCriterion _order = SortCriterion.creationDate;
  SortDirection _direction = SortDirection.ascending;

  int badgeLabel = 0;
  bool badgeVisible = false;

  HomeController(this.context, this.name);

  get order => _order;
  get orientation => _direction;

  get stopwatchCards => _stopwatchCards;

  Future<void> addStopwatch() async {
    int id = StopwatchModel.nextId++;
    // TODO: not taking the card count but the highest number a stopwatch has in "Athlete X" or cardsCount (whatever is bigger)
    _stopwatchCards.add(StopwatchCard("Athlete ${++_cardsCount}",
        (int id, String name) => deleteStopwatch(id, name), changedState, id,
        key: Key("$id"), homeController: this));
    _cardsCount = _stopwatchCards.length;
    storeHomeState(this);
    changedState();
  }

  void changedState() => sortAndListCards(_stopwatchCards, _order, _direction);

  void deleteAllStopwatches() {
    _oldHome.clear();
    for (StopwatchCard card in _stopwatchCards) {
      if (card.stopwatchModel.state == StopwatchState.running) {
        showShortSnackBar(context, "Can't delete while running");
        return;
      }
      _oldHome.add(jsonEncode(card.stopwatchModel));
    }
    _stopwatchCards.clear();
    _cardsCount = 0;
    storeHomeState(this);
    showLongSnackBar(context, "All stopwatches have been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              restoreAllStopwatches(_oldHome);
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
    _cardsCount = _stopwatchCards.length;
    storeHomeState(this);
    showLongSnackBar(context, "'$name' has been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              _stopwatchCards.add(deleted);
              _cardsCount = _stopwatchCards.length;
              changedState();
              storeHomeState(this);
            }));
  }

  @override
  void refreshBadgeState() {
    isMenuBadgeRequired(name).then((value) => badgeVisible = value);
    getUnseenRecordsCount().then((value) => badgeLabel = value);
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
    storeHomeState(this);
    showLongSnackBar(context, "All stopwatches has been reseted",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              for (var element in _stopwatchCards) {
                element.stopwatchModel.restore();
                storeHomeState(this);
              }
            }));
  }

  void restoreAllStopwatches(List<String> oldHome) {
    _stopwatchCards.clear();
    for (String entry in oldHome) {
      dynamic json = jsonDecode(entry);
      _stopwatchCards.add(StopwatchCard(
        json["name"],
        (int id, String name) => deleteStopwatch(id, name),
        changedState,
        json["id"],
        key: Key("${json["id"]}"),
        json: json,
        homeController: this,
      ));
    }
    _cardsCount = _stopwatchCards.length;
    storeHomeState(this);
  }

  void setSorting(SortCriterion order, SortDirection direction) {
    _order = order;
    _direction = direction;
    changedState();
    storeHomeState(this); // TODO: a bit redundant
  }
  
  void startAllStopwatches() {
    for (var element in _stopwatchCards) {
      element.stopwatchModel.start();
    }
    storeHomeState(this);
  }
}