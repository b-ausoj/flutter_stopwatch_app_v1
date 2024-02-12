import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/recordings_page_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_page_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/back_icon.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/recordings_page_popup_menu_button.dart';

class RecordingsPage extends StatefulWidget {
  const RecordingsPage({super.key});

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage>
    with SingleTickerProviderStateMixin {
  late final RecordingsPageController recordingsPageController;

  @override
  Widget build(BuildContext context) {
    // TODO: custom leading icon to add badge?
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recordings"),
        leading: BackIcon(recordingsPageController.badgeVisible),
        actions: [
          RecordingsPagePopupMenuButton(
              onSelected: (RecordingsPageMenuItem item) {
            switch (item) {
              case RecordingsPageMenuItem.deleteAll:
                recordingsPageController.deleteAllRecordings();
                break;
              case RecordingsPageMenuItem.exportAll:
                break;
            }
          })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: recordingsPageController.recordingsList.length,
          itemBuilder: (context, index) =>
              recordingsPageController.recordingsList[index],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadRecordings(recordingsPageController =
            RecordingsPageController(context, () => setState(() {})))
        .then((value) => null);
    recordingsPageController.refreshBadgeState();
  }
}
