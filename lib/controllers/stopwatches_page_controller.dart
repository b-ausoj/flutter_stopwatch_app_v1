import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';
import 'package:flutter_stopwatch_app_v1/utils/snackbar_utils.dart';
import 'package:flutter_stopwatch_app_v1/utils/sorting.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/stopwatch_card.dart';

class StopwatchesPageController extends BadgeController {
  BuildContext context;
  final List<SetupModel> allSetups;
  final List<StopwatchCard> _stopwatchCards = [];
  final List<String> _oldStopwatchesPage = [];
  final SetupModel setupModel;

  StopwatchesPageController(this.allSetups, this.context, this.setupModel) {
    for (var element in setupModel.stopwatches) {
      _stopwatchCards.add(StopwatchCard(
        element,
        changedState,
        key: Key("${element.id}"),
        stopwatchesPageController: this,
      ));
    }
    changedState();
  }

  get direction => setupModel.direction;
  String get name => setupModel.name;
  set name(String value) => setupModel.name = value;
  get order => setupModel.order;
  List<StopwatchCard> get stopwatchCards => _stopwatchCards;

  Future<void> addStopwatch() async {
    // TODO: not taking the card count but the highest number a stopwatch has in "Athlete X" or cardsCount (whatever is bigger)
    int id = StopwatchModel.nextId++;

    StopwatchModel model =
        StopwatchModel("Athlete ${_stopwatchCards.length + 1}", id);
    _stopwatchCards.add(StopwatchCard(model, changedState,
        key: Key("$id"), stopwatchesPageController: this));
    setupModel.stopwatches.add(model);
    changedState();
  }

  void changedState() {
    sortAndListCards(_stopwatchCards, setupModel.order, setupModel.direction);
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
    setupModel.stopwatches.clear();
    _stopwatchCards.clear();
    showLongSnackBar(context, "All stopwatches have been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              // TODO: reimplement the undo (with the setupmodel.stopwatches)
              /*
              restoreAllStopwatches(_oldStopwatchesPage);
              changedState();*/
            }));
  }

  void deleteStopwatch(int id, String name) {
    int index = _stopwatchCards.indexWhere((element) =>
        element.stopwatchModel.id == id &&
        element.stopwatchModel.state != StopwatchState.running);
    int index2 =
        setupModel.stopwatches.indexWhere((element) => element.id == id);
    if (index == -1) {
      showShortSnackBar(context, "Can't delete while running");
      return;
    }
    StopwatchCard deleted = _stopwatchCards.removeAt(index);
    StopwatchModel deletedModel = setupModel.stopwatches.removeAt(index2);
    showLongSnackBar(context, "'$name' has been removed",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              _stopwatchCards.add(deleted);
              setupModel.stopwatches.insert(index2, deletedModel);
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
    isMenuBadgeRequired(allSetups, setupModel)
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
    setupModel.order = order;
    setupModel.direction = direction;
    changedState();
  }

  void startAllStopwatches() {
    for (var element in _stopwatchCards) {
      element.stopwatchModel.start();
    }
  }

  void onReorder(int oldIndex, int newIndex) {
    StopwatchCard stopwatchCard = stopwatchCards.removeAt(oldIndex);
    stopwatchCards.insert(newIndex, stopwatchCard);

    StopwatchModel stopwatchModel = setupModel.stopwatches.removeAt(oldIndex);
    setupModel.stopwatches.insert(newIndex, stopwatchModel);
  }
}
