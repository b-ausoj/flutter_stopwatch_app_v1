import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_page_menu_item.dart';

class RecordingsPagePopupMenuButton extends StatelessWidget {
  final Function(RecordingsPageMenuItem) onSelected;

  const RecordingsPagePopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<RecordingsPageMenuItem>>[
        const PopupMenuItem<RecordingsPageMenuItem>(
          value: RecordingsPageMenuItem.deleteAll,
          child: Row(
            children: [
              Icon(Icons.delete_outlined),
              SizedBox(
                width: 12,
              ),
              Text('Delete all'),
            ],
          ),
        ),
        const PopupMenuItem<RecordingsPageMenuItem>(
          value: RecordingsPageMenuItem.exportAll,
          child: Row(
            children: [
              Icon(Icons.save_alt_outlined),
              SizedBox(
                width: 12,
              ),
              Text('Export all'),
            ],
          ),
        ),
        const PopupMenuItem<RecordingsPageMenuItem>(
          value: RecordingsPageMenuItem.settings,
          child: Row(
            children: [
              Icon(Icons.settings_outlined),
              SizedBox(
                width: 12,
              ),
              Text('Settings'),
            ],
          ),
        ),
      ],
    );
  }
}
