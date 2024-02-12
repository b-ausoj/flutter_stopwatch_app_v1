import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/controllers/stopwatches_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatches_page_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/add_stopwatch_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/stopwatches_page_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/sort_dialog.dart';

class StopwatchesPage extends StatefulWidget {
  final String name;
  const StopwatchesPage(this.name, {super.key});

  @override
  State<StopwatchesPage> createState() => _StopwatchesPageState();
}

class _StopwatchesPageState extends State<StopwatchesPage>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final StopwatchesPageController _stopwatchesPageController;
  late final List<String> screens;

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
            onSelected: (StopwatchesPageMenuItem item) {
              switch (item) {
                case StopwatchesPageMenuItem.rename:
                  _showRenameDialog();
                  break;
                case StopwatchesPageMenuItem.addStopwatch:
                  _stopwatchesPageController.addStopwatch();
                  break;
                case StopwatchesPageMenuItem.saveAll:
                  for (var element
                      in _stopwatchesPageController.stopwatchCards) {
                    saveStopwatch(element.stopwatchModel,
                        _stopwatchesPageController.name);
                    storeStopwatchState(
                        element.stopwatchModel, _stopwatchesPageController);
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
                case StopwatchesPageMenuItem.settings:
                  resetSharedPreferences(); // TODO: here can easy reset only for debugging
                  break;
              }
            },
          )
        ],
      ),
      drawer: NavDrawer(
          screens, _stopwatchesPageController, _stopwatchesPageController.name, false),
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
            var item =
                _stopwatchesPageController.stopwatchCards.removeAt(oldIndex);
            _stopwatchesPageController.stopwatchCards.insert(newIndex, item);
            storeStopwatchesPageState(
                _stopwatchesPageController); // TODO: a bit redundant
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
    loadStopwatchesPageState(_stopwatchesPageController =
        StopwatchesPageController(context, widget.name));
    loadScreens(
        screens = [],
        () => setState(
            () {})); // do I have to do something in setState with the controller?
    _ticker = createTicker((elapsed) {
      setState(() {});
    });
    _ticker.start();
  }

  Future<void> _showOrderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SortDialog(
            _stopwatchesPageController.order,
            _stopwatchesPageController.orientation,
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
          renameScreen(oldName, newName, () => setState(() {}));
          int indexToReplace = screens.indexOf(oldName);
          if (indexToReplace != -1) {
            screens[indexToReplace] = newName;
          }
        });
      },
    );
  }
}
