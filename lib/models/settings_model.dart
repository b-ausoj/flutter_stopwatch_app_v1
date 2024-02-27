import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';

class SettingsModel {
  SortCriterion defaultSortCriterion = SortCriterion.creationDate;
  SortDirection defaultSortDirection = SortDirection.ascending;
  bool seperateRunningStopped = true;

  SettingsModel();

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    SettingsModel settingsModel = SettingsModel();
    settingsModel.defaultSortCriterion = SortCriterion.values[json["defaultSortCriterion"]];
    settingsModel.defaultSortDirection = SortDirection.values[json["defaultSortDirection"]];
    settingsModel.seperateRunningStopped = json["seperateRunningStopped"];
    return settingsModel;
  }

  Map<String, dynamic> toJson() => {
        "defaultSortCriterion": defaultSortCriterion.index,
        "defaultSortDirection": defaultSortDirection.index,
        "seperateRunningStopped": seperateRunningStopped
      };
  
}