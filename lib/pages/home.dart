import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/enums/home_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/managers/home_manager.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/add_stopwatch_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/home_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/sort_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final HomeManager _homeManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stopwatch by Josua"),
        actions: [
          HomePopupMenuButton(
            onSelected: (HomeMenuItem item) {
              switch (item) {
                case HomeMenuItem.addStopwatch:
                  _homeManager.addStopwatch();
                  break;
                case HomeMenuItem.saveAll:
                  for (var element in _homeManager.stopwatchCards) {
                    saveStopwatch(element.stopwatchModel);
                    storeStopwatchState(element.stopwatchModel);
                  }
                  _homeManager.changedState();
                  break;
                case HomeMenuItem.resetAll:
                  _homeManager.resetAllStopwatches();
                  break;
                case HomeMenuItem.deleteAll:
                  _homeManager.deleteAllStopwatches();
                  break;
                case HomeMenuItem.changeOrder:
                  _showOrderDialog();
                  break;
                case HomeMenuItem.settings:
                  resetSharedPreferences(); // TODO: here can easy reset only for debugging
                  break;
                default:
                  throw Exception("Invalid HomeMenuItem state");
              }
            },
          )
        ],
      ),
      drawer: const NavDrawer(),
      floatingActionButton: isFabActive()
          ? FloatingActionButton.extended(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1E7927),
              onPressed: () {
                _homeManager.startAllStopwatches();
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
              _homeManager.order == SortCriterion.customReordable,
          footer: AddStopwatchCard(_homeManager.addStopwatch),
          children: _homeManager.stopwatchCards,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var item = _homeManager.stopwatchCards.removeAt(oldIndex);
            _homeManager.stopwatchCards.insert(newIndex, item);
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
    loadHomeState(_homeManager = HomeManager(context));
    _ticker = createTicker((elapsed) {
      setState(() {});
    });
    _ticker.start();
  }

  bool isFabActive() {
    return _homeManager.stopwatchCards.isNotEmpty &&
        _homeManager.stopwatchCards.every((element) =>
            element.stopwatchModel.state == StopwatchState.reseted);
  }

  Future<void> _showOrderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SortDialog(
            _homeManager.order,
            _homeManager.orientation,
            (SortCriterion order, SortDirection orientation) =>
                _homeManager.setSorting(order, orientation));
      },
    );
  }
}
