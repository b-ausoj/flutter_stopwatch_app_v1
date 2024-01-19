import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/saved_stopwatch_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/saved_stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/times_formatting_utils.dart';
import 'package:flutter_stopwatch_app_v1/widgets/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/saved_stopwatch_popup_menu_button.dart';

class SavedStopwatchCard extends StatefulWidget {
  final Map<String, dynamic> json;
  final void Function(int id, String name) deleteSavedStopwatch;
  late final SavedStopwatchModel savedStopwatchModel = (json.isEmpty)
      ? SavedStopwatchModel(0, "bla", DateTime.now(),
          Duration.zero) // TODO: schöner/korrekt machen
      : SavedStopwatchModel.fromJson(json);
  SavedStopwatchCard(this.deleteSavedStopwatch,
      {super.key, this.json = const {}});

  @override
  State<SavedStopwatchCard> createState() => _SavedStopwatchCardState();
}

class _SavedStopwatchCardState extends State<SavedStopwatchCard> {
  late final SavedStopwatchModel _savedStopwatchModel =
      widget.savedStopwatchModel;

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
                    child: Text(_savedStopwatchModel.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            height: 0)),
                  ),
                ),
                Text(durationToString(_savedStopwatchModel.totalTime),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w600, height: 0)),
                const Spacer(
                  flex: 1,
                ),
                SavedStopwatchPopupMenuButton(
                  onSelected: (SavedStopwatchCardMenuItem item) {
                    switch (item) {
                      case SavedStopwatchCardMenuItem.rename:
                        _showRenameDialog();
                        break;
                      case SavedStopwatchCardMenuItem.export:
                        break;
                      case SavedStopwatchCardMenuItem.share:
                        break;
                      case SavedStopwatchCardMenuItem.delete:
                        widget.deleteSavedStopwatch(
                            _savedStopwatchModel.id, _savedStopwatchModel.name);
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
                Text(formatLapCount(_savedStopwatchModel.lapTimes),
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
                    Text(formatLapTimes(_savedStopwatchModel.lapTimes),
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
                    Text(formatLapTimes(_savedStopwatchModel.splitTimes),
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
        return RenameDialog(_savedStopwatchModel.name, (String text) {
          setState(() {
            _savedStopwatchModel.name = text;
          });
          storeSavedStopwatchState(_savedStopwatchModel);
        });
      },
    );
  }
}
