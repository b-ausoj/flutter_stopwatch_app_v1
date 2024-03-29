import 'dart:convert';

import 'package:flutter_stopwatch_app_v1/enums/csv_delimiter.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/enums/time_format.dart';

class SettingsModel {
  SortCriterion defaultSortCriterion = SortCriterion.creationDate;
  SortDirection defaultSortDirection = SortDirection.ascending;
  bool seperateRunningStopped = true;
  CSVDelimiter csvDelimiter = CSVDelimiter.semicolon;
  TimeFormat timeFormat = TimeFormat.hhmmss;

  SettingsModel();

  void copyFrom(String json) {
    SettingsModel other = SettingsModel.fromJson(jsonDecode(json));
    defaultSortCriterion = other.defaultSortCriterion;
    defaultSortDirection = other.defaultSortDirection;
    seperateRunningStopped = other.seperateRunningStopped;
    csvDelimiter = other.csvDelimiter;
    timeFormat = other.timeFormat;
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    SettingsModel settingsModel = SettingsModel();
    settingsModel.defaultSortCriterion =
        SortCriterion.values[json["defaultSortCriterion"]];
    settingsModel.defaultSortDirection =
        SortDirection.values[json["defaultSortDirection"]];
    settingsModel.seperateRunningStopped = json["seperateRunningStopped"];
    settingsModel.csvDelimiter = CSVDelimiter.values[json["csvDelimiter"]];
    settingsModel.timeFormat = TimeFormat.values[json["timeFormat"]];
    return settingsModel;
  }

  Map<String, dynamic> toJson() => {
        "defaultSortCriterion": defaultSortCriterion.index,
        "defaultSortDirection": defaultSortDirection.index,
        "seperateRunningStopped": seperateRunningStopped,
        "csvDelimiter": csvDelimiter.index,
        "timeFormat": timeFormat.index,
      };
}
