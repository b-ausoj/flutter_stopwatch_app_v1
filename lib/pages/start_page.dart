import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_page_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/pages/stopwatches_page.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/start_page_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/text_with_badge/start_text_with_badge.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final StartController startController = StartController(() {
    setState(() {});
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Stopwatch by Josua"),
        leading: NavIcon(startController),
      ),
      drawer: NavDrawer(startController.names, startController, "Start", true),
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
                  ...startController.names.map((String screen) => Card(
                        color: const Color(0xFFEFEFEF),
                        elevation: 0,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          leading: const Icon(Icons.timer_outlined),
                          title: Center(
                              child: StartTextWithBadge(startController,
                                  startController.names.indexOf(screen))),
                          trailing: StartPagePopupMenuButton(
                              onSelected: (StartPageCardMenuItem item) {
                            switch (item) {
                              case StartPageCardMenuItem.rename:
                                _showRenameDialog(screen);
                                break;
                              case StartPageCardMenuItem.delete:
                                break;
                            }
                          }),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) =>
                                        StopwatchesPage(screen)))
                                .then((value) {
                              startController.refreshBadgeState();
                              startController.refreshNames();
                              setState(() {});
                            });
                          },
                        ),
                      )),
                  Card(
                    // Add new Screen
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: const Color(0xFFEFEFEF),
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.add_to_photos_outlined),
                      title: const Text("Add new Screen"),
                      onTap: () {
                        startController.names
                            .add("Screen ${startController.names.length + 1}");
                        startController.refreshBadgeState();
                        storeScreens(startController.names);
                        setState(() {});
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => StopwatchesPage(
                                    "Screen ${startController.names.length}")))
                            .then((value) {
                          startController.refreshBadgeState();
                          startController.refreshNames();
                          setState(() {});
                        });
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

  Future<String?> _showRenameDialog(String oldName) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RenameDialog(oldName, (String newName) {
          setState(() {});
          renameScreen(oldName, newName, () => setState(() {}));
          int indexToReplace = startController.names.indexOf(oldName);
          if (indexToReplace != -1) {
            startController.names[indexToReplace] = newName;
          }
        });
      },
    );
  }
}
