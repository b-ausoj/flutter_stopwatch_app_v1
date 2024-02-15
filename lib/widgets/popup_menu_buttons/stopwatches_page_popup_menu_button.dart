import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatches_page_menu_item.dart';

class StopwatchesPagePopupMenuButton extends StatelessWidget {
  final String name;
  final Function(StopwatchesPageMenuItem) onSelected;

  const StopwatchesPagePopupMenuButton(this.name,
      {required this.onSelected, super.key});

  // TODO: should improve this menu, not sure if it is intuitive and clear
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<StopwatchesPageMenuItem>>[
        const PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.rename,
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
        PopupMenuItem<StopwatchesPageMenuItem>(
          value: StopwatchesPageMenuItem.deleteConfiguration,
          child: Row(
            children: [
              const Icon(Icons.delete_forever_outlined),
              const SizedBox(
                width: 12,
              ),
              Container(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Text("Delete $name"), // TODO: not a perfect name
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
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
      ],
    );
  }
}
