import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';

enum StopwatchState { running, stopped, reseted }

class StopwatchModel {
  static int nextId = 1;
  final int id;

  String name;

  StopwatchState state;
  DateTime startedTime = DateTime.now();
  Duration savedTime;
  DateTime startedLapTime = DateTime.now();
  Duration savedLapTime;
  DateTime startTimestamp = DateTime.now();

  int lapCount = 0;
  List<LapModel> lapList = [];

  String oldStopwatch = "";

  Duration get elapsedTime =>
      (state == StopwatchState.running
          ? DateTime.now().difference(startedTime)
          : Duration.zero) +
      savedTime;
  Duration get elapsedLapTime =>
      (state == StopwatchState.running
          ? DateTime.now().difference(startedLapTime)
          : Duration.zero) +
      savedLapTime;

  int get elapsedTimeRounded =>
      ((state == StopwatchState.running
          ? DateTime.now().difference(startedTime)
          : Duration.zero) +
      savedTime).inMilliseconds ~/ 100;
  int get elapsedLapTimeRounded =>
      ((state == StopwatchState.running
          ? DateTime.now().difference(startedLapTime)
          : Duration.zero) +
      savedLapTime).inMilliseconds ~/ 100;

  StopwatchModel(this.name, this.id,
      {this.state = StopwatchState.reseted,
      this.savedTime = Duration.zero,
      this.savedLapTime = Duration.zero});

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
    model.startedTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedTime"]);
    model.startedLapTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedLapTime"]);
    model.startTimestamp =
        DateTime.fromMillisecondsSinceEpoch(json["startTimestamp"]);
    model.lapCount = json["lapCount"];
    Map<String, dynamic> lapList = jsonDecode(json["lapList"]);
    lapList.forEach((key, value) {
      model.lapList
          .add(LapModel(int.parse(key), Duration(milliseconds: value)));
    });
    return model;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'state': "$state",
        'startedTime': startedTime.millisecondsSinceEpoch,
        'savedTime': elapsedTime.inMilliseconds,
        'startedLapTime': startedLapTime.millisecondsSinceEpoch,
        'savedLapTime': elapsedLapTime.inMilliseconds,
        'startTimestamp': startTimestamp.millisecondsSinceEpoch,
        'lapCount': lapCount,
        'lapList': jsonEncode(_getLapsJson()),
      };

  Map<String, dynamic> _getLapsJson() {
    Map<String, dynamic> json = {};
    for (LapModel lap in lapList) {
      json["${lap.id}"] = lap.lapTime.inMilliseconds;
    }
    return json;
  }

  void start() {
    state = StopwatchState.running;
    startedTime = DateTime.now();
    startedLapTime = DateTime.now();
    startTimestamp = DateTime.now();
    startTimestamp = startTimestamp.subtract(Duration(milliseconds: startTimestamp.millisecond));
  }

  void stop() {
    savedTime = elapsedTime;
    savedLapTime = elapsedLapTime;
    state = StopwatchState.stopped;
  }

  void resume() {
    state = StopwatchState.running;
    startedTime = DateTime.now();
    startedLapTime = DateTime.now();
  }

  void lap() {
    lapList.add(LapModel(++lapCount, elapsedLapTime));
    startedLapTime = DateTime.now();
    savedLapTime = Duration.zero;
  }

  void restore() {
    Map<String, dynamic> json = jsonDecode(oldStopwatch);
    if (json.isEmpty) throw Exception("Restore without reset"); // only call restore form snackbar when shortly before reset was called
    name = json["name"];
    state = json["state"] == "${StopwatchState.running}"
          ? StopwatchState.running
          : json["state"] == "${StopwatchState.reseted}"
              ? StopwatchState.reseted
              : StopwatchState.stopped;
    savedTime = Duration(milliseconds: json["savedTime"]);
    savedLapTime = Duration(milliseconds: json["savedLapTime"]);
    startTimestamp = DateTime.fromMillisecondsSinceEpoch(json["startTimestamp"]);
    startedTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedTime"]);
    startedLapTime =
        DateTime.fromMillisecondsSinceEpoch(json["startedLapTime"]);
    lapCount = json["lapCount"];
    jsonDecode(json["lapList"]).forEach((key, value) {
      lapList.add(LapModel(int.parse(key), Duration(milliseconds: value)));
    });
  }


  void reset() {
    if (state == StopwatchState.running) return;
    oldStopwatch = jsonEncode(this); // save stopwatch for an undo
    state = StopwatchState.reseted;
    savedTime = Duration.zero;
    savedLapTime = Duration.zero;
    startTimestamp = DateTime.now();
    lapCount = 0;
    lapList = [];
  }
}
