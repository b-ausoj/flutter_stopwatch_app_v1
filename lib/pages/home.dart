import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stopwatch_app_v1/controllers/home_controller.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/home_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/stopwatch_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/add_stopwatch_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/home_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/sort_dialog.dart';

class Home extends StatefulWidget {
  final String name;
  const Home(this.name, {super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  late final HomeController _homeController;
  late final List<String> screens;
  late final List<StartController> startControllers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name),
        leading: NavIcon(_homeController),
        actions: [
          HomePopupMenuButton(
            onSelected: (HomeMenuItem item) {
              switch (item) {
                case HomeMenuItem.addStopwatch:
                  _homeController.addStopwatch();
                  break;
                case HomeMenuItem.saveAll:
                  for (var element in _homeController.stopwatchCards) {
                    saveStopwatch(element.stopwatchModel);
                    storeStopwatchState(element.stopwatchModel, _homeController);
                  }
                  _homeController.changedState();
                  break;
                case HomeMenuItem.resetAll:
                  _homeController.resetAllStopwatches();
                  break;
                case HomeMenuItem.deleteAll:
                  _homeController.deleteAllStopwatches();
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
      drawer: NavDrawer(screens, _homeController, widget.name),
      floatingActionButton: isFabActive()
          ? FloatingActionButton.extended(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF1E7927),
              onPressed: () {
                _homeController.startAllStopwatches();
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
              _homeController.order == SortCriterion.customReordable,
          footer: AddStopwatchCard(_homeController.addStopwatch),
          children: _homeController.stopwatchCards,
          onReorder: (int oldIndex, int newIndex) {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var item = _homeController.stopwatchCards.removeAt(oldIndex);
            _homeController.stopwatchCards.insert(newIndex, item);
            storeHomeState(_homeController); // TODO: a bit redundant
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
    log("init in home");
    loadHomeState(_homeController = HomeController(context, widget.name));
    loadScreens(screens = [], startControllers = [], () => setState(() {}));
    _ticker = createTicker((elapsed) {
      setState(() {});
    });
    _ticker.start();
  }

  bool isFabActive() {
    return _homeController.stopwatchCards.isNotEmpty &&
        _homeController.stopwatchCards.every((element) =>
            element.stopwatchModel.state == StopwatchState.reseted);
  }

  Future<void> _showOrderDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SortDialog(
            _homeController.order,
            _homeController.orientation,
            (SortCriterion order, SortDirection orientation) =>
                _homeController.setSorting(order, orientation));
      },
    );
  }
}
