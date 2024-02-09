import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/models/lap_model.dart';

class RecordingModel {
  // fields
  static int nextId = 1;
  final int id;

  String name;
  DateTime startingTime;
  bool viewed;

  Duration totalTime;
  List<LapModel> lapTimes = [];
  List<LapModel> splitTimes = [];

  // constructor
  RecordingModel(this.id, this.name, this.startingTime, this.viewed, this.totalTime);

  factory RecordingModel.fromJson(Map<String, dynamic> json) {
    RecordingModel model = RecordingModel(
        json["id"],
        json["name"],
        DateTime.fromMillisecondsSinceEpoch(json["startingTime"]),
        json["viewed"],
        Duration(milliseconds: json["totalTime"]));
    Map<String, dynamic> lapTimes = jsonDecode(json["lapTimes"]);
    lapTimes.forEach((key, value) {
      model.lapTimes
          .add(LapModel(int.parse(key), Duration(milliseconds: value)));
    });
    Map<String, dynamic> splitTimes = jsonDecode(json["splitTimes"]);
    splitTimes.forEach((key, value) {
      model.splitTimes
          .add(LapModel(int.parse(key), Duration(milliseconds: value)));
    });
    return model;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "startingTime": startingTime.millisecondsSinceEpoch,
        "viewed": viewed,
        "totalTime": totalTime.inMilliseconds,
        "lapTimes": jsonEncode(getListJson(lapTimes)),
        "splitTimes": jsonEncode(getListJson(splitTimes))
      };

  Map<String, dynamic> getListJson(List<LapModel> list) {
    Map<String, dynamic> json = {};
    for (LapModel lap in list) {
      json["${lap.id}"] = lap.lapTime.inMilliseconds;
    }
    return json;
  }
}
