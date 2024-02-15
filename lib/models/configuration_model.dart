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
class Configuration {
  static int nextId = 1;
  final int id;
  
  String name;

  SortCriterion order;
  SortDirection direction;

  List<StopwatchModel> stopwatches;

  Configuration(this.name, this.id, this.order, this.direction, this.stopwatches);
}