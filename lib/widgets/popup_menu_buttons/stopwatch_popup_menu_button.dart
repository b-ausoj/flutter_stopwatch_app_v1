import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatch_card_menu_item.dart';

class StopwatchPopupMenuButton extends StatelessWidget {
  final Function(StopwatchCardMenuItem) onSelected;

  const StopwatchPopupMenuButton({required this.onSelected, super.key});
  // TODO: simplify like recording_popup_menu_button.dart

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<StopwatchCardMenuItem>>[
              const PopupMenuItem<StopwatchCardMenuItem>(
                value: StopwatchCardMenuItem.rename,
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
              const PopupMenuItem<StopwatchCardMenuItem>(
                value: StopwatchCardMenuItem.save,
                child: Row(
                  children: [
                    Icon(Icons.save_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Save'),
                  ],
                ),
              ),
              const PopupMenuItem<StopwatchCardMenuItem>(
                value: StopwatchCardMenuItem.reset,
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Reset'),
                  ],
                ),
              ),
              const PopupMenuItem<StopwatchCardMenuItem>(
                value: StopwatchCardMenuItem.delete,
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
