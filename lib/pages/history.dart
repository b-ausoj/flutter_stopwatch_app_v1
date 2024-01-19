import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/history_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/enums/history_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/widgets/saved_stopwatch_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> with SingleTickerProviderStateMixin {
  final List<SavedStopwatchCard> _savedStopwatchCards = [];
  final List<Widget> _historyList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          PopupMenuButton(
            onSelected: (HistoryMenuItem item) {
              // addStopwatch, saveAll, resetAll, deleteAll, changeOrder, settings
              switch (item) {
                case HistoryMenuItem.deleteAll:
                  deleteAllStopwatches();
                  break;
                case HistoryMenuItem.exportAll:
                  break;
                case HistoryMenuItem.settings:
                  break;
                default:
                  throw Exception("Invalid HistoryMenuItem state");
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<HistoryMenuItem>>[
              const PopupMenuItem<HistoryMenuItem>(
                value: HistoryMenuItem.deleteAll,
                child: Row(
                  children: [
                    Icon(Icons.delete_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Delete all'),
                  ],
                ),
              ),
              const PopupMenuItem<HistoryMenuItem>(
                value: HistoryMenuItem.exportAll,
                child: Row(
                  children: [
                    Icon(Icons.save_alt_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Export all'),
                  ],
                ),
              ),
              const PopupMenuItem<HistoryMenuItem>(
                value: HistoryMenuItem.settings,
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Settings'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _historyList.length,
          itemBuilder: (context, index) => _historyList[index],
        ),
      ),
    );
  }

  void createHistoryList() {
    _historyList.clear();
    if (_savedStopwatchCards.isEmpty) return;
    DateTime last = _savedStopwatchCards.first.savedStopwatchModel.startingTime;
    List<Widget> list = [];
    for (SavedStopwatchCard card in _savedStopwatchCards) {
      if (last == card.savedStopwatchModel.startingTime) {
        list.add(card);
      } else {
        var timeStamp = last.copyWith();
        _historyList.add(Card(
          color: const Color(0xFFEFEFEF),
          elevation: 0,
          child: ExpansionTile(
            shape: const Border(),
            controlAffinity: ListTileControlAffinity.leading,
            trailing: PopupMenuButton(
              onSelected: (HistoryCardMenuItem item) {
                switch (item) {
                  case HistoryCardMenuItem.deleteAll:
                    deleteCardStopwatches(timeStamp);
                    break;
                  case HistoryCardMenuItem.exportAll:
                    break;
                }
                setState(() {
                  //selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<HistoryCardMenuItem>>[
                const PopupMenuItem<HistoryCardMenuItem>(
                  value: HistoryCardMenuItem.deleteAll,
                  child: Row(
                    children: [
                      Icon(Icons.delete_outlined),
                      SizedBox(
                        width: 12,
                      ),
                      Text('Delete all'),
                    ],
                  ),
                ),
                const PopupMenuItem<HistoryCardMenuItem>(
                  value: HistoryCardMenuItem.exportAll,
                  child: Row(
                    children: [
                      Icon(Icons.save_alt_outlined),
                      SizedBox(
                        width: 12,
                      ),
                      Text('Export all'),
                    ],
                  ),
                ),
              ],
            ),
            title: Center(child: Text(dateTimeToString(last))),
            children: list,
          ),
        ));
        list = [card];
      }
      last = card.savedStopwatchModel.startingTime;
    }
    if (list.isNotEmpty) {
      _historyList.add(Card(
        color: const Color(0xFFEFEFEF),
        child: ExpansionTile(
          shape: const Border(),
          controlAffinity: ListTileControlAffinity.leading,
          trailing: PopupMenuButton(
            onSelected: (HistoryCardMenuItem item) {
              switch (item) {
                case HistoryCardMenuItem.deleteAll:
                  deleteCardStopwatches(last);
                  break;
                case HistoryCardMenuItem.exportAll:
                  break;
              }
              setState(() {
                //selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<HistoryCardMenuItem>>[
              const PopupMenuItem<HistoryCardMenuItem>(
                value: HistoryCardMenuItem.deleteAll,
                child: Row(
                  children: [
                    Icon(Icons.delete_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Delete all'),
                  ],
                ),
              ),
              const PopupMenuItem<HistoryCardMenuItem>(
                value: HistoryCardMenuItem.exportAll,
                child: Row(
                  children: [
                    Icon(Icons.save_alt_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Export all'),
                  ],
                ),
              ),
            ],
          ),
          title: Center(child: Text(dateTimeToString(last))),
          children: list,
        ),
      ));
    }
  }

  String dateTimeToString(DateTime dateTime) {
    String d = dateTime.day < 10 ? "0${dateTime.day}" : "${dateTime.day}";
    String m = dateTime.month < 10 ? "0${dateTime.month}" : "${dateTime.month}";
    String y = "${dateTime.year}";
    String h = dateTime.hour < 10 ? "0${dateTime.hour}" : "${dateTime.hour}";
    String min =
        dateTime.minute < 10 ? "0${dateTime.minute}" : "${dateTime.minute}";
    //String sec = dateTime.second < 10 ? "0${dateTime.second}" : "${dateTime.second}";
    return "$h:$min $d.$m.$y";
  }

  void deleteAllStopwatches() {
    _savedStopwatchCards.removeRange(0, _savedStopwatchCards.length);
    createHistoryList();
    _storeHistoryState();
  }

  void deleteCardStopwatches(DateTime timestamp) {
    _savedStopwatchCards.removeWhere(
        (element) => element.savedStopwatchModel.startingTime == timestamp);
    createHistoryList();
    _storeHistoryState();
  }

  Future<void> deleteStopwatch(int id, String name) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stopwatch '$name' has been removed")));
    _savedStopwatchCards
        .removeWhere((element) => element.savedStopwatchModel.id == id);
    createHistoryList();
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];
    history.removeWhere(
      (element) => jsonDecode(element)["id"] == id,
    );
    prefs.setStringList("history", history);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadHistory();
    setState(() {});
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList("history") ?? [];
    for (String entry in history.reversed) {
      _savedStopwatchCards.add(SavedStopwatchCard(
        deleteStopwatch,
        json: jsonDecode(entry),
        key: Key(entry),
      ));
    }
    _savedStopwatchCards.sort(
      (a, b) => -a.savedStopwatchModel.startingTime
          .compareTo(b.savedStopwatchModel.startingTime),
    );
    createHistoryList();
    setState(() {});
  }

  Future<void> _storeHistoryState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = [];
    for (SavedStopwatchCard card in _savedStopwatchCards) {
      history.add(jsonEncode(card.savedStopwatchModel));
    }
    prefs.setStringList("history", history);
  }
}
