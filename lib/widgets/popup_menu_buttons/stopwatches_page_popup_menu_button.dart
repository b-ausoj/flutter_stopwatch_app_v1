import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatches_page_menu_item.dart';

class StopwatchesPagePopupMenuButton extends StatelessWidget {
  final Function(StopwatchesPageMenuItem) onSelected;

  const StopwatchesPagePopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<StopwatchesPageMenuItem>>[
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.addStopwatch,
          child: Row(
            children: [
              Icon(Icons.add_circle_outline),
              SizedBox(
                width: 12,
              ),
              Text('Add stopwatch'),
            ],
          ),
        ),
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.saveAll,
          child: Row(
            children: [
              Icon(Icons.save_outlined),
              SizedBox(
                width: 12,
              ),
              Text('Save all'),
            ],
          ),
        ),
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.resetAll,
          child: Row(
            children: [
              Icon(Icons.refresh),
              SizedBox(
                width: 12,
              ),
              Text('Reset all'),
            ],
          ),
        ),
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.deleteAll,
          child: Row(
            children: [
              Icon(Icons.delete_outline),
              SizedBox(
                width: 12,
              ),
              Text('Delete all'),
            ],
          ),
        ),
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.changeOrder,
          child: Row(
            children: [
              Icon(Icons.sort),
              SizedBox(
                width: 12,
              ),
              Text('Change order'),
            ],
          ),
        ),
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.settings,
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
