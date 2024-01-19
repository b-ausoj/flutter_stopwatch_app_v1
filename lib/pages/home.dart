import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/sorting.dart';
import 'package:flutter_stopwatch_app_v1/widgets/add_stopwatch_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/home_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/sort_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_stopwatch_app_v1/enums/home_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<StopwatchCard> _stopwatchCards = [];
  List<String> oldHome = [];
  int cardsCount = 0;
  SortCriterion _order = SortCriterion.creationDate;
  SortDirection _orientation = SortDirection.ascending;

  @override
  void initState() {
    super.initState();
    _loadHomeState();
    _ticker = createTicker((elapsed) {
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void changedState() {
    sortAndListCards(_stopwatchCards, _order, _orientation);
  }

  Future<void> _storeHomeState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> home = [];
    for (StopwatchCard card in _stopwatchCards) {
      home.add(jsonEncode(card.stopwatchModel));
    }
    prefs.setStringList("home", home);
    prefs.setInt("nextStopwatchId", StopwatchModel.nextId);
  }

  Future<void> _loadHomeState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> home = prefs.getStringList("home") ?? [];
    for (String entry in home) {
      dynamic json = jsonDecode(entry);
      _stopwatchCards.add(StopwatchCard(
        json["name"],
        deleteStopwatch,
        changedState,
        json["id"],
        key: Key("${json["id"]}"),
        json: json,
      ));
    }
    StopwatchModel.nextId = prefs.getInt("nextStopwatchId") ?? 1;
    _stopwatchCards.sort(
      (a, b) => a.stopwatchModel.id.compareTo(b.stopwatchModel.id),
    );
    cardsCount = _stopwatchCards.length;
  }

  Future<void> _resetSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void deleteStopwatch(int id, String name) {
    int index = _stopwatchCards.indexWhere((element) =>
        element.id == id &&
        element.stopwatchModel.state != StopwatchState.running);
    if (index == -1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Can't delete while running"),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    StopwatchCard deleted = _stopwatchCards.removeAt(index);
    cardsCount = _stopwatchCards.length;
    _storeHomeState();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("'$name' has been removed"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            _stopwatchCards.add(deleted);
            _stopwatchCards.sort(
              (a, b) => a.stopwatchModel.id.compareTo(b.stopwatchModel.id),
            );
            cardsCount = _stopwatchCards.length;
            _storeHomeState();
          }),
    ));
  }

  void restoreAllStopwatches() {
    _stopwatchCards.clear();
    for (String entry in oldHome) {
      dynamic json = jsonDecode(entry);
      _stopwatchCards.add(StopwatchCard(
        json["name"],
        deleteStopwatch,
        changedState,
        json["id"],
        key: Key("${json["id"]}"),
        json: json,
      ));
    }
    _stopwatchCards.sort(buildSort(_order, _orientation));
    cardsCount = _stopwatchCards.length;
  }

  void deleteAllStopwatches() {
    oldHome = [];
    for (StopwatchCard card in _stopwatchCards) {
      if (card.stopwatchModel.state == StopwatchState.running) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Can't delete while running"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
      oldHome.add(jsonEncode(card.stopwatchModel));
    }
    _stopwatchCards.clear();
    cardsCount = 0;
    _storeHomeState();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("All stopwatches have been removed"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            restoreAllStopwatches();
          }),
    ));
  }

  void startAllStopwatches() {
    for (var element in _stopwatchCards) {
      element.stopwatchModel.start();
    }
    _storeHomeState();
  }

  void resetAllStopwatches() {
    // save all in json string list
    // call everyone to reset itself
    // if undo then delete list and load json
    for (StopwatchCard card in _stopwatchCards) {
      if (card.stopwatchModel.state == StopwatchState.running) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Can't reset while running"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
    }
    for (StopwatchCard card in _stopwatchCards) {
      card.stopwatchModel.reset();
    }
    _storeHomeState();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text("All stopwatches has been reseted"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            for (var element in _stopwatchCards) {
              element.stopwatchModel.restore();
            }
          }),
    ));
  }

  Future<void> addStopwatch() async {
    int id = StopwatchModel.nextId++;
    // TODO: not taking the card count but the highest number a stopwatch has in "Athlete X" or cardsCount (whatever is bigger)
    _stopwatchCards.add(StopwatchCard(
        "Athlete ${++cardsCount}", deleteStopwatch, changedState, id,
        key: Key("$id")));
    _storeHomeState();
  }

  bool isFabActive() {
    return _stopwatchCards.isNotEmpty &&
        _stopwatchCards.every((element) =>
            element.stopwatchModel.state == StopwatchState.reseted);
  }

  Future<void> _showOrderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SortDialog(_order, _orientation,
            (SortCriterion order, SortDirection orientation) {
          _order = order;
          _orientation = orientation;
          _stopwatchCards.sort(buildSort(_order, _orientation));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stopwatch by Josua"),
        actions: [
          HomePopupMenuButton(
            onSelected: (HomeMenuItem item) {
              switch (item) {
                case HomeMenuItem.addStopwatch:
                  addStopwatch();
                  break;
                case HomeMenuItem.saveAll:
                  for (var element in _stopwatchCards) {
                    saveStopwatch(element.stopwatchModel);
                    storeStopwatchState(element.stopwatchModel);
                  }
                  changedState();
                  break;
                case HomeMenuItem.resetAll:
                  resetAllStopwatches();
                  break;
                case HomeMenuItem.deleteAll:
                  deleteAllStopwatches();
                  break;
                case HomeMenuItem.changeOrder:
                  _showOrderDialog();
                  break;
                case HomeMenuItem.settings:
                  //_resetSharedPreferences(); TODO: here can easy reset
                  break;
                default:
                  throw Exception("Invalid HomeMenuItem state");
              }
            },
          )
        ],
      ),
      drawer: const NavDrawer(),
      floatingActionButton: isFabActive()
          ? FloatingActionButton.extended(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1E7927),
              onPressed: () {
                startAllStopwatches();
                HapticFeedback.lightImpact();
              },
              label: const Text("START ALL"),
              icon: const Icon(Icons.play_arrow),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReorderableListView(
          buildDefaultDragHandles: _order == SortCriterion.customReordable,
          footer: AddStopwatchCard(addStopwatch),
          children: _stopwatchCards,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var item = _stopwatchCards.removeAt(oldIndex);
            _stopwatchCards.insert(newIndex, item);
          },
        ),
      ),
    );
  }
}
