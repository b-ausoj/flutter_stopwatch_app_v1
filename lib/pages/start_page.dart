import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_page_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/pages/stopwatches_page.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/delete_setup_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/rename_dialog.dart';
import 'package:flutter_stopwatch_app_v1/widgets/icons/navigation_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/navigation_drawer.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/start_page_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/text_with_badge/start_text_with_badge.dart';

class StartPage extends StatefulWidget {
  final String sharedPreferencesKey;
  const StartPage({required this.sharedPreferencesKey, super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  late final StartController _startController =
      StartController(() => setState(() {}), widget.sharedPreferencesKey);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("MultiStopwatches by Josua"),
        leading: NavIcon(_startController),
      ),
      drawer:
          NavDrawer(_startController.allSetups, _startController, null),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Welcome to the MultiStopwatches app by Josua"),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ..._startController.allSetups.map((SetupModel setup) => Card(
                        color: const Color(0xFFEFEFEF),
                        elevation: 0,
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.only(left: 16.0, right: 8.0),
                          leading: const Icon(Icons.timer_outlined),
                          title: Center(
                              child: StartTextWithBadge(_startController,
                                  _startController.allSetups.indexOf(setup))),
                          trailing: StartPagePopupMenuButton(
                              onSelected: (StartPageCardMenuItem item) {
                            switch (item) {
                              case StartPageCardMenuItem.rename:
                                _showRenameDialog(setup);
                                break;
                              case StartPageCardMenuItem.delete:
                                _showDeleteSetupDialog(setup);
                                break;
                            }
                          }),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => StopwatchesPage(
                                        setup, _startController.allSetups)))
                                .then((value) {
                              _startController.refreshBadgeState();
                              setState(() {});
                            });
                          },
                        ),
                      )),
                  Card(
                    // Add new Setup
                    margin: const EdgeInsets.symmetric(
                        horizontal: 90.0, vertical: 4.0),
                    color: const Color(0xFFEFEFEF),
                    elevation: 0,
                    child: InkWell(
                        onTap: () {
                          SetupModel newSetup = SetupModel(
                              "Setup ${_startController.allSetups.length + 1}",
                              0,
                              SortCriterion.creationDate,
                              SortDirection.ascending, []);
                          _startController.allSetups.add(newSetup);
                          _startController.refreshBadgeState();
                          setState(() {});
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => StopwatchesPage(
                                      newSetup, _startController.allSetups)))
                              .then((value) {
                            _startController.refreshBadgeState();
                            setState(() {});
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Add a new setup",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Icon(Icons.add_to_photos_outlined)
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteSetupDialog(SetupModel setupModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeleteSetupDialog(
          setupModel.name,
          onAccept: () {
            _startController.removeSetup(setupModel);
            setState(() {});
          },
        );
      },
    );
  }

  Future<String?> _showRenameDialog(SetupModel setupModel) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RenameDialog(setupModel.name, (String newName) {
          setupModel.name = newName;
          setState(() {});
        });
      },
    );
  }
}
