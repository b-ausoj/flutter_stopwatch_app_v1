import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_set_menu_item.dart';

class RecordingsSetPopupMenuButton extends StatelessWidget {
  final Function(RecordingsSetMenuItem) onSelected;

  const RecordingsSetPopupMenuButton({required this.onSelected, super.key});

  // TODO: simplify like recording_popup_menu_button.dart
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<RecordingsSetMenuItem>>[
        const PopupMenuItem<RecordingsSetMenuItem>(
          value: RecordingsSetMenuItem.deleteAll,
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
        const PopupMenuItem<RecordingsSetMenuItem>(
          value: RecordingsSetMenuItem.exportAll,
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
      ],
    );
  }
}
