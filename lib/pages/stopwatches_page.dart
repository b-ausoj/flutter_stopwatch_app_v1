import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/controllers/stopwatches_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatches_page_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/add_stopwatch_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/stopwatch_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/delete_setup_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/sort_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/icons/navigation_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/stopwatches_page_popup_menu_button.dart';

class StopwatchesPage extends StatefulWidget {
  final SetupModel setup;
  final List<SetupModel> allSetups;
  const StopwatchesPage(this.setup, this.allSetups, {super.key});

  @override
  State<StopwatchesPage> createState() => _StopwatchesPageState();
}

class _StopwatchesPageState extends State<StopwatchesPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final StopwatchesPageController _stopwatchesPageController;
  late final SetupModel _setupModel = widget.setup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: InkWell(
            onTap: _showRenameDialog,
            child: Text(_stopwatchesPageController.name)),
        leading: NavIcon(_stopwatchesPageController),
        actions: [
          StopwatchesPagePopupMenuButton(
            _stopwatchesPageController.name,
            onSelected: (StopwatchesPageMenuItem item) {
              switch (item) {
                case StopwatchesPageMenuItem.rename:
                  _showRenameDialog();
                  break;
                case StopwatchesPageMenuItem.deleteSetup:
                  _showDeleteSetupDialog();
                  break;
                case StopwatchesPageMenuItem.saveAll:
                  for (StopwatchCard element
                      in _stopwatchesPageController.stopwatchCards) {
                    if (element.stopwatchModel.state ==
                        StopwatchState.stopped) {
                      saveStopwatch(element.stopwatchModel,
                          _stopwatchesPageController.name);
                    }
                  }
                  _stopwatchesPageController.changedState();
                  break;
                case StopwatchesPageMenuItem.resetAll:
                  _stopwatchesPageController.resetAllStopwatches();
                  break;
                case StopwatchesPageMenuItem.deleteAll:
                  _stopwatchesPageController.deleteAllStopwatches();
                  break;
                case StopwatchesPageMenuItem.changeOrder:
                  _showOrderDialog();
                  break;
              }
            },
          )
        ],
      ),
      drawer: NavDrawer(widget.allSetups, _stopwatchesPageController,
          _stopwatchesPageController.setupModel),
      floatingActionButton: _stopwatchesPageController.isFabActive()
          ? FloatingActionButton.extended(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1E7927),
              onPressed: () {
                _stopwatchesPageController.startAllStopwatches();
                HapticFeedback.lightImpact();
              },
              label: const Text("START ALL"),
              icon: const Icon(Icons.play_arrow),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReorderableListView(
          buildDefaultDragHandles:
              _stopwatchesPageController.order == SortCriterion.customReordable,
          footer: AddStopwatchCard(_stopwatchesPageController.addStopwatch),
          children: _stopwatchesPageController.stopwatchCards,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            _stopwatchesPageController.onReorder(oldIndex, newIndex);
          },
        ),
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
    _stopwatchesPageController =
        StopwatchesPageController(widget.allSetups, context, _setupModel);
    _ticker = createTicker((elapsed) {
      setState(() {});
      _stopwatchesPageController.changedState();
    });
    _ticker.start();
    _stopwatchesPageController.refreshBadgeState();
  }

  Future<void> _showDeleteSetupDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeleteSetupDialog(
          _stopwatchesPageController.name,
          onAccept: () {
            widget.allSetups.remove(_setupModel);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  Future<void> _showOrderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SortDialog(
            _stopwatchesPageController.order,
            _stopwatchesPageController.direction,
            (SortCriterion order, SortDirection orientation) =>
                _stopwatchesPageController.setSorting(order, orientation));
      },
    );
  }

  Future<String?> _showRenameDialog() async {
    String oldName = _stopwatchesPageController.name;
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RenameDialog(oldName, (String newName) {
          setState(() {
            _stopwatchesPageController.name = newName;
          });
        });
      },
    );
  }
}
