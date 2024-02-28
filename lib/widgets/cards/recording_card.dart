import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recording_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/recording_model.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/export_to_csv.dart';
import 'package:flutter_stopwatch_app_v1/utils/times_formatting_utils.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/recording_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/rename_dialog.dart';

class RecordingCard extends StatefulWidget {
  final Map<String, dynamic> json;
  final void Function(int id, String name) deleteRecording;
  final SettingsModel settings;
  late final RecordingModel recordingModel = (json.isEmpty)
      ? RecordingModel(0, "bla", DateTime.now(), false, "test",
          Duration.zero) // TODO: schöner/korrekt machen
      : RecordingModel.fromJson(json);
  RecordingCard(this.deleteRecording, this.settings,
      {super.key, this.json = const {}});

  @override
  State<RecordingCard> createState() => _RecordingCardState();
}

class _RecordingCardState extends State<RecordingCard> {
  late final RecordingModel _recordingModel = widget.recordingModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFDFDFDF),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: InkWell(
                    onTap: _showRenameDialog,
                    child: Text(_recordingModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            height: 0)),
                  ),
                ),
                Text(durationToString(_recordingModel.totalTime),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w600, height: 0)),
                const Spacer(
                  flex: 1,
                ),
                RecordingPopupMenuButton(
                  onSelected: (RecordingCardMenuItem item) {
                    switch (item) {
                      case RecordingCardMenuItem.rename:
                        log("message");
                        _showRenameDialog();
                        break;
                      case RecordingCardMenuItem.export:
                        log("exporting");
                        exportRecordingToCSV(_recordingModel, widget.settings);
                        break;
                      case RecordingCardMenuItem.delete:
                        widget.deleteRecording(
                            _recordingModel.id, _recordingModel.name);
                        break;
                      default:
                    }
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatLapCount(_recordingModel.lapTimes),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w400, height: 0)),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    const Text("Lap time",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 0)),
                    Text(formatLapTimes(_recordingModel.lapTimes),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 0)),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  children: [
                    const Text("Split time",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 0)),
                    Text(formatLapTimes(_recordingModel.splitTimes),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            height: 0)),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<String?> _showRenameDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RenameDialog(_recordingModel.name, (String text) {
          setState(() {
            _recordingModel.name = text;
          });
          storeRecordingState(_recordingModel);
        });
      },
    );
  }
}
