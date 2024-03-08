import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';

class StopwatchModel {
  static int nextId = 1;
  final int id;

  String name;

  StopwatchState state;
  DateTime _startedTime =
      DateTime.now(); // when the stopwatch was started or resumed
  Duration _savedTime;
  DateTime _startedLapTime =
      DateTime.now(); // when the lap was started or resumed
  Duration _savedLapTime;
  DateTime _startTimestamp =
      DateTime.now(); // when the stopwatch was started (for the recording)

  int lapCount = 0;
  List<LapModel> lapList = [];

  String oldStopwatch = "";

  StopwatchModel(this.name, this.id,
      {this.state = StopwatchState.reseted,
      Duration savedTime = Duration.zero,
      Duration savedLapTime = Duration.zero})
      : _savedLapTime = savedLapTime,
        _savedTime = savedTime;

  factory StopwatchModel.fromJson(Map<String, dynamic> json) {
    StopwatchModel model = StopwatchModel(
      json["name"],
      json["id"],
      state: json["state"] == "${StopwatchState.running}"
          ? StopwatchState.running
          : json["state"] == "${StopwatchState.reseted}"
              ? StopwatchState.reseted
              : StopwatchState.stopped,
      savedTime: Duration(milliseconds: json["savedTime"]),
      savedLapTime: Duration(milliseconds: json["savedLapTime"]),
    );
    model._startedTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedTime"]);
    model._startedLapTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedLapTime"]);
    model._startTimestamp =
        DateTime.fromMillisecondsSinceEpoch(json["startTimestamp"]);
    model.lapCount = json["lapCount"];
    Map<String, dynamic> lapList = jsonDecode(json["lapList"]);
    lapList.forEach((key, value) {
      model.lapList
          .add(LapModel(int.parse(key), Duration(milliseconds: value)));
    });
    return model;
  }
  Duration get elapsedLapTime =>
      (state == StopwatchState.running
          ? DateTime.now().difference(_startedLapTime)
          : Duration.zero) +
      _savedLapTime;

  int get elapsedLapTimeRounded =>
      ((state == StopwatchState.running
                  ? DateTime.now().difference(_startedLapTime)
                  : Duration.zero) +
              _savedLapTime)
          .inMilliseconds ~/
      100;
  Duration get elapsedTime =>
      (state == StopwatchState.running
          ? DateTime.now().difference(_startedTime)
          : Duration.zero) +
      _savedTime;

  int get elapsedTimeRounded =>
      ((state == StopwatchState.running
                  ? DateTime.now().difference(_startedTime)
                  : Duration.zero) +
              _savedTime)
          .inMilliseconds ~/
      100;

  bool get isRunning => state == StopwatchState.running;

  DateTime get startTimestamp => _startTimestamp;

  void lap() {
    lapList.add(LapModel(++lapCount, elapsedLapTime));
    _startedLapTime = DateTime.now();
    _savedLapTime = Duration.zero;
  }

  void reset() {
    if (state == StopwatchState.running) return;
    oldStopwatch = jsonEncode(this); // save stopwatch for an undo
    state = StopwatchState.reseted;
    _savedTime = Duration.zero;
    _savedLapTime = Duration.zero;
    _startTimestamp = DateTime.now();
    lapCount = 0;
    lapList = [];
  }

  void restore() {
    Map<String, dynamic> json = jsonDecode(oldStopwatch);
    if (json.isEmpty) {
      throw Exception(
          "Restore without reset"); // only call restore form snackbar when shortly before reset was called
    }
    name = json["name"];
    state = json["state"] == "${StopwatchState.running}"
        ? StopwatchState.running
        : json["state"] == "${StopwatchState.reseted}"
            ? StopwatchState.reseted
            : StopwatchState.stopped;
    _savedTime = Duration(milliseconds: json["savedTime"]);
    _savedLapTime = Duration(milliseconds: json["savedLapTime"]);
    _startTimestamp =
        DateTime.fromMillisecondsSinceEpoch(json["startTimestamp"]);
    _startedTime = DateTime.fromMillisecondsSinceEpoch(json["startedTime"]);
    _startedLapTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedLapTime"]);
    lapCount = json["lapCount"];
    jsonDecode(json["lapList"]).forEach((key, value) {
      lapList.add(LapModel(int.parse(key), Duration(milliseconds: value)));
    });
  }

  void resume() {
    state = StopwatchState.running;
    _startedTime = DateTime.now();
    _startedLapTime = DateTime.now();
  }

  void start() {
    state = StopwatchState.running;
    _startedTime = DateTime.now();
    _startedLapTime = DateTime.now();
    _startTimestamp = DateTime.now();
    _startTimestamp = _startTimestamp
        .subtract(Duration(milliseconds: _startTimestamp.millisecond));
  }

  void stop() {
    _savedTime = elapsedTime;
    _savedLapTime = elapsedLapTime;
    state = StopwatchState.stopped;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'state': "$state",
        'startedTime': _startedTime.millisecondsSinceEpoch,
        'savedTime': _savedTime.inMilliseconds,
        'startedLapTime': _startedLapTime.millisecondsSinceEpoch,
        'savedLapTime': _savedLapTime.inMilliseconds,
        'startTimestamp': _startTimestamp.millisecondsSinceEpoch,
        'lapCount': lapCount,
        'lapList': jsonEncode(_getLapsJson()),
      };

  @override
  String toString() {
    String string =
        "StopwatchModel: id: $id, name: $name, state: $state, startedTime: $_startedTime, savedTime: $_savedTime, startedLapTime: $_startedLapTime, savedLapTime: $_savedLapTime, startTimestamp: $_startTimestamp, lapCount: $lapCount, lapList: \n\t\t";
    for (var lap in lapList) {
      string += "${lap.lapTime} ";
    }
    return string;
  }

  Map<String, dynamic> _getLapsJson() {
    Map<String, dynamic> json = {};
    for (LapModel lap in lapList) {
      json["${lap.id}"] = lap.lapTime.inMilliseconds;
    }
    return json;
  }
}

enum StopwatchState { running, stopped, reseted }
