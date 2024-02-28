import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter_stopwatch_app_v1/enums/time_format.dart';
import 'package:flutter_stopwatch_app_v1/models/recording_model.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/utils/times_formatting_utils.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/recording_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<void> exportRecordingToCSV(
    RecordingModel recording, SettingsModel settings) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  String fileName =
      "$path/${recording.name}_${dateTimeToString(recording.startingTime).replaceAll(" ", "_")}.csv";
  final file = File(fileName);

  List<List<String>> data = [];
  data.add(["", recording.fromSetup, dateTimeToString(recording.startingTime)]);
  data.add(["", "", ""]);
  data.addAll(recordingToList(recording, settings.timeFormat));

  file.writeAsString(
      ListToCsvConverter(fieldDelimiter: settings.csvDelimiter.delimiter)
          .convert(data));

  Share.shareXFiles([XFile(fileName)], text: "Here is your recording!");
}

Future<void> exportRecordingsSetToCSV(
    List<RecordingCard> recordings, SettingsModel settings) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  String fileName =
      "$path/${recordings.first.recordingModel.fromSetup}_${dateTimeToString(recordings.first.recordingModel.startingTime).replaceAll(" ", "_")}.csv";
  final file = File(fileName);

  List<List<String>> data = [];
  data.add([
    "",
    recordings.first.recordingModel.fromSetup,
    dateTimeToString(recordings.first.recordingModel.startingTime)
  ]);
  for (RecordingCard recording in recordings) {
    data.add(["", "", ""]);
    data.addAll(recordingToList(recording.recordingModel, settings.timeFormat));
  }

  file.writeAsString(
      ListToCsvConverter(fieldDelimiter: settings.csvDelimiter.delimiter)
          .convert(data));

  Share.shareXFiles([XFile(fileName)], text: "Here is your recording!");
}

List<List<String>> recordingToList(
    RecordingModel recording, TimeFormat timeFormat) {
  List<List<String>> data = [];
  data.add([
    recording.name,
    "Total Time",
    durationToStringExport(recording.totalTime, timeFormat)
  ]);
  data.add(["Lap No.", "Lap Time", "Split Time"]);
  for (int i = 0; i < recording.lapTimes.length; i++) {
    data.add([
      (i + 1).toString(),
      durationToStringExport(recording.lapTimes[i].lapTime, timeFormat),
      durationToStringExport(recording.splitTimes[i].lapTime, timeFormat)
    ]);
  }
  return data;
}
