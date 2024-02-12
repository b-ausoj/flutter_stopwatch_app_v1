import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/recordings_page_controller.dart';

class BackIcon extends StatelessWidget {
  final RecordingsPageController recordingsPageController;

  const BackIcon(this.recordingsPageController, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Badge(
            smallSize: 8.0,
            isLabelVisible: recordingsPageController.badgeVisible,
            child: const Icon(Icons.arrow_back)));
  }
}
