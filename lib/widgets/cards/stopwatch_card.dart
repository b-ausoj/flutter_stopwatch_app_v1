import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/controllers/stopwatches_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatch_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/snackbar_utils.dart';
import 'package:flutter_stopwatch_app_v1/utils/times_formatting_utils.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/stopwatch_popup_menu_button.dart';

class StopwatchCard extends StatefulWidget {
  final StopwatchesPageController stopwatchesPageController;
  final void Function() changedState;

  final StopwatchModel stopwatchModel;

  const StopwatchCard(this.stopwatchModel, this.changedState,
      {super.key, required this.stopwatchesPageController});

  @override
  State createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard>
    with SingleTickerProviderStateMixin {
  late final StopwatchModel _stopwatchModel = widget.stopwatchModel;
  late final Ticker _ticker;
  bool showAllLaps = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEFEFEF),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                showAllLaps = !showAllLaps;
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(durationToString(_stopwatchModel.elapsedTime),
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          height: 0)),
                  Text(
                      "${_stopwatchModel.lapCount < 9 ? "0${_stopwatchModel.lapCount + 1}" : "${_stopwatchModel.lapCount + 1}"} ${durationToString(_stopwatchModel.elapsedLapTime)}",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          height: 0)),
                  Text(formatPastLaps(_stopwatchModel.lapList, showAllLaps),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          height: 0)),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 4, // space between times and name/buttons
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: _showRenameDialog,
                      child: Text(
                        _stopwatchModel.name,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0,
                            height: 0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                    StopwatchPopupMenuButton(
                      onSelected: (StopwatchCardMenuItem item) async {
                        switch (item) {
                          case StopwatchCardMenuItem.rename:
                            _showRenameDialog();
                            break;
                          case StopwatchCardMenuItem.save:
                            switch (_stopwatchModel.state) {
                              case StopwatchState.running:
                                showShortSnackBar(
                                    context, "Can't save while running");
                                break;
                              case StopwatchState.reseted:
                                showShortSnackBar(
                                    context, "Can't save empty stopwatch");
                                break;
                              case StopwatchState.stopped:
                                saveStopwatch(_stopwatchModel,
                                    widget.stopwatchesPageController.name);
                                widget.changedState();
                                showLongSnackBar(context,
                                    "'${_stopwatchModel.name}' has been saved and reseted",
                                    action: SnackBarAction(
                                        label: "Undo reset",
                                        onPressed: () {
                                          _stopwatchModel.restore();
                                          widget.changedState();
                                        }));
                                break;
                            }
                            break;
                          case StopwatchCardMenuItem.reset:
                            switch (_stopwatchModel.state) {
                              case StopwatchState.running:
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Can't reset while running"),
                                  duration: Duration(seconds: 2),
                                ));
                                break;
                              case StopwatchState.reseted:
                                break;
                              case StopwatchState.stopped:
                                _stopwatchModel.reset();
                                widget.changedState();
                                showLongSnackBar(context,
                                    "'${_stopwatchModel.name}' has been reseted",
                                    action: SnackBarAction(
                                        label: "Undo",
                                        onPressed: () {
                                          _stopwatchModel.restore();
                                          widget.changedState();
                                        }));
                                break;
                            }
                            break;
                          case StopwatchCardMenuItem.delete:
                            widget.stopwatchesPageController.deleteStopwatch(
                                widget.stopwatchModel.id,
                                widget.stopwatchModel.name);
                            break;
                        }
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                  child: Row(
                    children: [
                      switch (_stopwatchModel.state) {
                        StopwatchState.reseted => TextButton.icon(
                            onPressed: () {
                              _stopwatchModel.start();
                              widget.changedState();
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text("START"),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF1E7927))),
                        StopwatchState.running => TextButton.icon(
                            onPressed: () {
                              _stopwatchModel.stop();
                              widget.changedState();
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.stop),
                            label: const Text("STOP"),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFFBC2525))),
                        StopwatchState.stopped => TextButton.icon(
                            onPressed: () {
                              _stopwatchModel.resume();
                              widget.changedState();
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.play_arrow_outlined),
                            label: const Text("RESUME"),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF259030))),
                      },
                      const Spacer(),
                      TextButton.icon(
                        onPressed:
                            _stopwatchModel.state == StopwatchState.running
                                ? () {
                                    _stopwatchModel.lap();
                                    widget.changedState();
                                    HapticFeedback.lightImpact();
                                  }
                                : null,
                        icon: const Icon(Icons.flag),
                        label: const Text("LAP"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFE5A426),
                          disabledForegroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFFBFBFBF),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      assert(widget.stopwatchModel.id ==
          _stopwatchModel.id); // TODO: remove for deployment
      setState(() {});
    });
    _ticker.start();
  }

  Future<String?> _showRenameDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RenameDialog(_stopwatchModel.name, (String text) {
          _stopwatchModel.name = text;
          widget.changedState();
        });
      },
    );
  }
}
