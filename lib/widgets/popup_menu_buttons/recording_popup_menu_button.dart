import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recording_card_menu_item.dart';

class RecordingPopupMenuButton extends StatelessWidget {
  final Function(RecordingCardMenuItem) onSelected;

  const RecordingPopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) => RecordingCardMenuItem.values
            .map<PopupMenuEntry<RecordingCardMenuItem>>(
                (RecordingCardMenuItem menuItem) => PopupMenuItem(
                      value: menuItem,
                      child: Row(
                        children: [
                          Icon(menuItem.icon),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(menuItem.label),
                        ],
                      ),
                    ))
            .toList());
  }
}
