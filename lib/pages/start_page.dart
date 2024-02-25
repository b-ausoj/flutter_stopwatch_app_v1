import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_page_card_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/configuration_model.dart';
import 'package:flutter_stopwatch_app_v1/pages/stopwatches_page.dart';
import 'package:flutter_stopwatch_app_v1/widgets/dialogs/delete_configuration_dialog.dart';
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
      drawer: NavDrawer(
          _startController.configurations, _startController, null, true),
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
                  ..._startController.configurations
                      .map((ConfigurationModel configuration) => Card(
                            color: const Color(0xFFEFEFEF),
                            elevation: 0,
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.only(left: 16.0, right: 8.0),
                              leading: const Icon(Icons.timer_outlined),
                              title: Center(
                                  child: StartTextWithBadge(
                                      _startController,
                                      _startController.configurations
                                          .indexOf(configuration))),
                              trailing: StartPagePopupMenuButton(
                                  onSelected: (StartPageCardMenuItem item) {
                                switch (item) {
                                  case StartPageCardMenuItem.rename:
                                    _showRenameDialog(configuration);
                                    break;
                                  case StartPageCardMenuItem.delete:
                                    _showDeleteConfigurationDialog(
                                        configuration);
                                    break;
                                }
                              }),
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => StopwatchesPage(
                                            configuration,
                                            _startController.configurations)))
                                    .then((value) {
                                  _startController.refreshBadgeState();
                                  setState(() {});
                                });
                              },
                            ),
                          )),
                  Card(
                    // Add new Configuration
                    margin: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    color: const Color(0xFFEFEFEF),
                    elevation: 0,
                    child: ListTile(
                      leading: const Icon(Icons.add_to_photos_outlined),
                      title: const Text("Add new Configuration"),
                      onTap: () {
                        ConfigurationModel newConfiguration = ConfigurationModel(
                            "Configuration ${_startController.configurations.length + 1}",
                            0,
                            SortCriterion.creationDate,
                            SortDirection.ascending, []);
                        _startController.configurations.add(newConfiguration);
                        _startController.refreshBadgeState();
                        setState(() {});
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => StopwatchesPage(
                                    newConfiguration,
                                    _startController.configurations)))
                            .then((value) {
                          _startController.refreshBadgeState();
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

  Future<void> _showDeleteConfigurationDialog(
      ConfigurationModel configurationModel) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeleteConfigurationDialog(
          configurationModel.name,
          onAccept: () {
            _startController.removeConfiguration(configurationModel);
            setState(() {});
          },
        );
      },
    );
  }

  Future<String?> _showRenameDialog(
      ConfigurationModel configurationModel) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return RenameDialog(configurationModel.name, (String newName) {
          configurationModel.name = newName;
          setState(() {});
        });
      },
    );
  }
}
