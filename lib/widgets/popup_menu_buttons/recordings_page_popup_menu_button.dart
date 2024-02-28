import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_page_menu_item.dart';

class RecordingsPagePopupMenuButton extends StatelessWidget {
  final Function(RecordingsPageMenuItem) onSelected;

  const RecordingsPagePopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => RecordingsPageMenuItem.values
          .map<PopupMenuEntry<RecordingsPageMenuItem>>(
              (RecordingsPageMenuItem menuItem) => PopupMenuItem(
                  value: menuItem,
                  child: Row(
                    children: [
                      Icon(menuItem.icon),
                      const SizedBox(
                        width: 12,
                      ),
                      Text(menuItem.label),
                    ],
                  )))
          .toList(),
    );
  }
}
