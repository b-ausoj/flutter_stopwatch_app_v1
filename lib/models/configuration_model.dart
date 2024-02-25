import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';

// idea is, that this is the model that can be saved and loaded from the shared preferences
// it contains the configuration of the stopwatches (previously screen)
// so the stopwatches themself are here but the cards are in the stopwatches_page_controller
// so seperate the data from the view (i.e. the controller takes the data, puts it in the cards and then displays it on the screen)
// the controller only has the cards and the model
// every screen has an unique id and order and direction
// TODO: rename order to criterion
class ConfigurationModel {
  static int nextId = 1;
  final int id; // not needed

  String name;

  SortCriterion order;
  SortDirection direction;

  List<StopwatchModel> stopwatches;

  ConfigurationModel(
      this.name, this.id, this.order, this.direction, this.stopwatches);

  // TODO: Should write tests for that
  factory ConfigurationModel.fromJson(Map<String, dynamic> json) {
    List<StopwatchModel> stopwatches = [];
    for (var stopwatchJson in jsonDecode(json["stopwatches"])) {
      stopwatches.add(StopwatchModel.fromJson(stopwatchJson));
    }
    ConfigurationModel model = ConfigurationModel(json["name"], json["id"],
        SortCriterion.values[json["order"]], SortDirection.values[json["direction"]], stopwatches);
    return model;
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "order": SortCriterion.values.indexOf(order),
        "direction": SortDirection.values.indexOf(direction),
        "stopwatches": jsonEncode(stopwatches)
      };

  @override
  String toString() {
    String string = "ConfigurationModel: id: $id, name: $name, order: $order, direction: $direction, stopwatches: \n";

    for (var stopwatch in stopwatches) {
      string += "\t$stopwatch\n";
    }

    return string;
  }
}
