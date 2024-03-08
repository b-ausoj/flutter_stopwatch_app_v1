import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';

// idea is, that this is the model that can be saved and loaded from the shared preferences
// it contains the setup of the stopwatches (previously screen)
// so the stopwatches themself are here but the cards are in the stopwatches_page_controller
// so seperate the data from the view (i.e. the controller takes the data, puts it in the cards and then displays it on the screen)
// the controller only has the cards and the model
// every screen has an unique id and order and direction
// TODO: rename order to criterion
class SetupModel {
  static int nextId = 1;
  final int id; // not needed

  String name;

  SortCriterion criterion;
  SortDirection direction;

  List<StopwatchModel> stopwatches;

  SetupModel(this.name, this.id, this.criterion, this.direction, this.stopwatches);

  // TODO: Should write tests for that
  factory SetupModel.fromJson(Map<String, dynamic> json) {
    List<StopwatchModel> stopwatches = [];
    for (var stopwatchJson in jsonDecode(json["stopwatches"])) {
      stopwatches.add(StopwatchModel.fromJson(stopwatchJson));
    }
    SetupModel model = SetupModel(
        json["name"],
        json["id"],
        SortCriterion.values[json["criterion"]],
        SortDirection.values[json["direction"]],
        stopwatches);
    return model;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "criterion": SortCriterion.values.indexOf(criterion),
        "direction": SortDirection.values.indexOf(direction),
        "stopwatches": jsonEncode(stopwatches)
      };

  @override
  String toString() {
    String string =
        "SetupModel: id: $id, name: $name, criterion: $criterion, direction: $direction, stopwatches: \n";

    for (var stopwatch in stopwatches) {
      string += "\t$stopwatch\n";
    }

    return string;
  }
}
