import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_page_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_page_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/widgets/recording_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingsPage extends StatefulWidget {
  const RecordingsPage({super.key});

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> with SingleTickerProviderStateMixin {
  final List<RecordingCard> _recordingCards = [];
  final List<Widget> _recordingsList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: custom leading icon to add badge?
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        actions: [
          PopupMenuButton(
            onSelected: (RecordingsPageMenuItem item) {
              // addStopwatch, saveAll, resetAll, deleteAll, changeOrder, settings
              switch (item) {
                case RecordingsPageMenuItem.deleteAll:
                  deleteAllStopwatches();
                  break;
                case RecordingsPageMenuItem.exportAll:
                  break;
                case RecordingsPageMenuItem.settings:
                  break;
                default:
                  throw Exception("Invalid HistoryMenuItem state");
              }
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<RecordingsPageMenuItem>>[
              const PopupMenuItem<RecordingsPageMenuItem>(
                value: RecordingsPageMenuItem.deleteAll,
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
              const PopupMenuItem<RecordingsPageMenuItem>(
                value: RecordingsPageMenuItem.exportAll,
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
              const PopupMenuItem<RecordingsPageMenuItem>(
                value: RecordingsPageMenuItem.settings,
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
          itemCount: _recordingsList.length,
          itemBuilder: (context, index) => _recordingsList[index],
        ),
      ),
    );
  }

  void createHistoryList() {
    _recordingsList.clear();
    if (_recordingCards.isEmpty) return;
    DateTime last = _recordingCards.first.recordingModel.startingTime;
    List<Widget> list = [];
    for (RecordingCard card in _recordingCards) {
      if (last == card.recordingModel.startingTime) {
        list.add(card);
      } else {
        var timeStamp = last.copyWith();
        _recordingsList.add(Card(
          color: const Color(0xFFEFEFEF),
          elevation: 0,
          child: ExpansionTile(
            onExpansionChanged: (value) => setViewedToTrue(timeStamp),
            shape: const Border(),
            controlAffinity: ListTileControlAffinity.leading,
            trailing: PopupMenuButton(
              onSelected: (RecordingsPageCardMenuItem item) {
                switch (item) {
                  case RecordingsPageCardMenuItem.deleteAll:
                    deleteCardStopwatches(timeStamp);
                    break;
                  case RecordingsPageCardMenuItem.exportAll:
                    break;
                }
                setState(() {
                  //selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<RecordingsPageCardMenuItem>>[
                const PopupMenuItem<RecordingsPageCardMenuItem>(
                  value: RecordingsPageCardMenuItem.deleteAll,
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
                const PopupMenuItem<RecordingsPageCardMenuItem>(
                  value: RecordingsPageCardMenuItem.exportAll,
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
      last = card.recordingModel.startingTime;
    }
    if (list.isNotEmpty) {
      _recordingsList.add(Card(
        elevation: 0,
        color: const Color(0xFFEFEFEF),
        child: ExpansionTile(
          onExpansionChanged: (value) => setViewedToTrue(last),
          shape: const Border(),
          controlAffinity: ListTileControlAffinity.leading,
          trailing: PopupMenuButton(
            onSelected: (RecordingsPageCardMenuItem item) {
              switch (item) {
                case RecordingsPageCardMenuItem.deleteAll:
                  deleteCardStopwatches(last);
                  break;
                case RecordingsPageCardMenuItem.exportAll:
                  break;
              }
              setState(() {
                //selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<RecordingsPageCardMenuItem>>[
              const PopupMenuItem<RecordingsPageCardMenuItem>(
                value: RecordingsPageCardMenuItem.deleteAll,
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
              const PopupMenuItem<RecordingsPageCardMenuItem>(
                value: RecordingsPageCardMenuItem.exportAll,
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
    _recordingCards.removeRange(0, _recordingCards.length);
    createHistoryList();
    _storeHistoryState();
  }

  void deleteCardStopwatches(DateTime timestamp) {
    _recordingCards.removeWhere(
        (element) => element.recordingModel.startingTime == timestamp);
    createHistoryList();
    _storeHistoryState();
  }

  void setViewedToTrue(DateTime timestamp) {
    for (RecordingCard card in _recordingCards) {
      if (card.recordingModel.startingTime == timestamp) {
        card.recordingModel.viewed = true;
        log("messageeeeeeeeeeeeeeeeee");
      }
    }
    createHistoryList();
    _storeHistoryState();
  }

  Future<void> deleteStopwatch(int id, String name) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stopwatch '$name' has been removed")));
    _recordingCards
        .removeWhere((element) => element.recordingModel.id == id);
    createHistoryList();
    final prefs = await SharedPreferences.getInstance();
    List<String> recordings = prefs.getStringList("recordings") ?? [];
    recordings.removeWhere(
      (element) => jsonDecode(element)["id"] == id,
    );
    prefs.setStringList("recordings", recordings);
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
    List<String> recordings = prefs.getStringList("recordings") ?? [];
    for (String entry in recordings.reversed) {
      _recordingCards.add(RecordingCard(
        deleteStopwatch,
        json: jsonDecode(entry),
        key: Key(entry),
      ));
    }
    _recordingCards.sort(
      (a, b) => -a.recordingModel.startingTime
          .compareTo(b.recordingModel.startingTime),
    );
    createHistoryList();
    setState(() {});
  }

  Future<void> _storeHistoryState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> recordings = [];
    for (RecordingCard card in _recordingCards) {
      recordings.add(jsonEncode(card.recordingModel));
    }
    prefs.setStringList("recordings", recordings);
  }
}
