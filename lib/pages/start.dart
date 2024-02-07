import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/home_controller.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/pages/home.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/start_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/start_text_with_badge.dart';
import 'package:flutter_stopwatch_app_v1/widgets/stopwatch_icon.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  final List<String> screens = [];
  final List<StartController> startControllers =
      []; // could combine / include screens
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    log("build Start");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stopwatch by Josua"),
        leading: NavIcon(HomeController(context, "")),
      ),
      drawer: NavDrawer(screens, StartController(""), "Start"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Welcome to Stopwatch by Josua"),
            const Text("This is the start page"),
            const Text(
              "Here you can see an overview of all your stopwatch screens (each one stores it's configuration and timers). Cou can also rename, delete or add a new screen",
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...screens.map((String screen) => Card(
                        color: const Color(0xFFEFEFEF),
                        elevation: 0,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          leading: StopwatchIcon(screen),
                          title: Center(
                              child: StartTextWithBadge(
                                  startControllers[screens.indexOf(screen)])),
                          trailing: StartPopupMenuButton(
                              onSelected: (StartCardMenuItem item) {
                            switch (item) {
                              case StartCardMenuItem.rename:
                                break;
                              case StartCardMenuItem.delete:
                                break;
                            }
                          }),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => Home(screen)))
                                .then((value) {
                                    startControllers[screens.indexOf(screen)]
                                        .refreshBadge(); setState(() {
                                          
                                        });});
                          },
                        ),
                      )),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: const Color(0xFFEFEFEF),
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.add_to_photos_outlined),
                      title: const Text("Add new Screen"),
                      onTap: () {
                        screens.add("Screen ${screens.length + 1}");
                        startControllers
                            .add(StartController("Screen ${screens.length}"));
                        storeScreens(screens);
                        setState(() {});
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Home("Screen ${screens.length}")));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadScreens(screens, startControllers, () => setState(() {}));
  }
}
