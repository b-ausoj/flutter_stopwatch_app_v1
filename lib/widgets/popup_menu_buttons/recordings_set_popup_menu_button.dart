import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_set_menu_item.dart';

class RecordingsSetPopupMenuButton extends StatelessWidget {
  final Function(RecordingsSetMenuItem) onSelected;

  const RecordingsSetPopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => RecordingsSetMenuItem.values
          .map<PopupMenuEntry<RecordingsSetMenuItem>>(
              (RecordingsSetMenuItem menuItem) => PopupMenuItem(
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
