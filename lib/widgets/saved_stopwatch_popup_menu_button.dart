import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/saved_stopwatch_card_menu_item.dart';

class SavedStopwatchPopupMenuButton extends StatelessWidget {
  final Function(SavedStopwatchCardMenuItem) onSelected;

  const SavedStopwatchPopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<SavedStopwatchCardMenuItem>>[
              const PopupMenuItem<SavedStopwatchCardMenuItem>(
                value: SavedStopwatchCardMenuItem.rename,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Rename'),
                  ],
                ),
              ),
              const PopupMenuItem<SavedStopwatchCardMenuItem>(
                value: SavedStopwatchCardMenuItem.export,
                child: Row(
                  children: [
                    Icon(Icons.save_alt),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Export'),
                  ],
                ),
              ),
              const PopupMenuItem<SavedStopwatchCardMenuItem>(
                value: SavedStopwatchCardMenuItem.share,
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem<SavedStopwatchCardMenuItem>(
                value: SavedStopwatchCardMenuItem.delete,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Delete'),
                  ],
                ),
              ),
            ]);
  }
}
