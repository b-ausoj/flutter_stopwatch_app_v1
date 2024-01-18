import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';
import 'package:flutter_stopwatch_app_v1/models/saved_stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/widgets/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_popup_menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_stopwatch_app_v1/enums/stopwatch_card_menu_item.dart';

class StopwatchCard extends StatefulWidget {
  final int id;
  final String name;
  final dynamic json;
  late void Function() save;
  final void Function(int id, String name) deleteStopwatch;
  final void Function() changedState;
  late final StopwatchModel stopwatchModel =
      (json == null) ? StopwatchModel(name, id) : StopwatchModel.fromJson(json);

  StopwatchCard(this.name, this.deleteStopwatch, this.changedState, this.id,
      {super.key, this.json});

  @override
  State createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard>
    with SingleTickerProviderStateMixin {
  late final StopwatchModel _stopwatchModel = widget.stopwatchModel;
  late final Ticker _ticker;
  bool showAllLaps = false;
  String valueText = "";

  String _durationToString(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    int hSeconds = duration.inMilliseconds ~/
        100 %
        10; // ~/ 10 % 100 for hunderts of a second
    return "${minutes < 10 ? "0$minutes" : "$minutes"}:${seconds < 10 ? "0$seconds" : "$seconds"}.$hSeconds";
    //return "${minutes < 10 ? "0$minutes" : "$minutes"}:${seconds < 10 ? "0$seconds" : "$seconds"}.${hSeconds < 10 ? "0$hSeconds" : "$hSeconds"}";
  }

  String _formatPastLaps() {
    if (_stopwatchModel.lapList.isEmpty) {
      return "";
    } else if (showAllLaps) {
      StringBuffer result = StringBuffer();
      for (LapModel lap in _stopwatchModel.lapList.reversed) {
        result.write(
            "${lap.id < 10 ? "0${lap.id}" : "${lap.id}"} ${_durationToString(lap.lapTime)}${lap.id == 1 ? "" : "\n"}");
      }
      return result.toString();
    } else {
      LapModel lap = _stopwatchModel.lapList.last;
      return "${lap.id < 10 ? "0${lap.id}" : "${lap.id}"} ${_durationToString(lap.lapTime)}";
    }
  }

  Future<void> _storeStopwatchState() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> home = prefs.getStringList("home") ?? [];
    home.removeWhere(
      (element) => jsonDecode(element)["id"] == _stopwatchModel.id,
    );
    home.add(jsonEncode(_stopwatchModel));
    prefs.setStringList("home", home);
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      assert(widget.id == _stopwatchModel.id); // TODO: remove for deployment
      setState(() {});
    });
    _ticker.start();
    widget.save = save;
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    SavedStopwatchModel.nextId = prefs.getInt("nextSavedStopwatchId") ?? 1;
    SavedStopwatchModel model = SavedStopwatchModel(
        SavedStopwatchModel.nextId++,
        _stopwatchModel.name,
        _stopwatchModel.startTimestamp,
        _stopwatchModel.elapsedTime);
    model.lapTimes = _stopwatchModel.lapList;
    model.lapTimes.add(
        LapModel(_stopwatchModel.lapCount + 1, _stopwatchModel.elapsedLapTime));
    Duration split = Duration.zero;
    for (LapModel lap in model.lapTimes) {
      model.splitTimes.add(LapModel(lap.id, split = lap.lapTime + split));
    }
    List<String> history = prefs.getStringList("history") ?? [];
    history.add(jsonEncode(model));
    prefs.setStringList("history", history);
    prefs.setInt("nextSavedStopwatchId", SavedStopwatchModel.nextId);
    _stopwatchModel.reset();
    _storeStopwatchState(); // TODO remove
    widget.changedState(); // TODO remove
  }

  Future<String?> _showRenameDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RenameDialog(_stopwatchModel.name, (String text) {
          _stopwatchModel.name = text;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEFEFEF),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showAllLaps = !showAllLaps;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_durationToString(_stopwatchModel.elapsedTime),
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          height: 0)),
                  Text(
                      "${_stopwatchModel.lapCount < 9 ? "0${_stopwatchModel.lapCount + 1}" : "${_stopwatchModel.lapCount + 1}"} ${_durationToString(_stopwatchModel.elapsedLapTime)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 0)),
                  Text(_formatPastLaps(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 0)),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 4, // space between times and name/buttons
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(_stopwatchModel.name,
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0,
                                height: 0))),
                    StopwatchPopupMenuButton(onSelected: (StopwatchCardMenuItem item) async {
                          switch (item) {
                            case StopwatchCardMenuItem.rename:
                              _showRenameDialog();
                              _storeStopwatchState();
                              widget.changedState();
                              break;
                            case StopwatchCardMenuItem.save:
                              switch (_stopwatchModel.state) {
                                case StopwatchState.running:
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Can't save while running"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  break;
                                case StopwatchState.reseted:
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Can't save empty stopwatch"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  break;
                                case StopwatchState.stopped:
                                  save();
                                  _storeStopwatchState();
                                  widget.changedState();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "'${_stopwatchModel.name}' has been saved and reseted"),
                                    action: SnackBarAction(
                                        label: "Undo reset",
                                        onPressed: () {
                                          _stopwatchModel.restore();
                                          _storeStopwatchState();
                                          widget.changedState();
                                        }),
                                  ));
                                  break;
                              }
                              break;
                            case StopwatchCardMenuItem.reset:
                              switch (_stopwatchModel.state) {
                                case StopwatchState.running:
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Can't reset while running"),
                                    duration: Duration(seconds: 2),
                                  ));
                                  break;
                                case StopwatchState.reseted:
                                  break;
                                case StopwatchState.stopped:
                                  _stopwatchModel.reset();
                                  _storeStopwatchState();
                                  widget.changedState();
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                        "'${_stopwatchModel.name}' has been reseted"),
                                    action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          _stopwatchModel.restore();
                                          widget.changedState();
                                        }),
                                  ));
                                  break;
                              }
                              break;
                            case StopwatchCardMenuItem.delete:
                              widget.deleteStopwatch(widget.id, widget.name);
                              break;
                          }
                        },)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                  child: Row(
                    children: [
                      switch (_stopwatchModel.state) {
                        StopwatchState.reseted => TextButton.icon(
                            onPressed: () {
                              _stopwatchModel.start();
                              _storeStopwatchState();
                              widget.changedState();
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text("START"),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF1E7927))),
                        StopwatchState.running => TextButton.icon(
                            onPressed: () {
                              _stopwatchModel.stop();
                              _storeStopwatchState();
                              widget.changedState();
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.stop),
                            label: const Text("STOP"),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFBC2525))),
                        StopwatchState.stopped => TextButton.icon(
                            onPressed: () {
                              _stopwatchModel.resume();
                              _storeStopwatchState();
                              widget.changedState();
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.play_arrow_outlined),
                            label: const Text("RESUME"),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF259030))),
                      },
                      const Spacer(),
                      TextButton.icon(
                        onPressed:
                            _stopwatchModel.state == StopwatchState.running
                                ? () {
                                    _stopwatchModel.lap();
                                    _storeStopwatchState();
                                    widget.changedState();
                                    HapticFeedback.lightImpact();
                                  }
                                : null,
                        icon: const Icon(Icons.flag),
                        label: const Text("LAP"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFE5A426),
                          disabledForegroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFBFBFBF),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
