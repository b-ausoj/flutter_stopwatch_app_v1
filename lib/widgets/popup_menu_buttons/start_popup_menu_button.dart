import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_card_menu_item.dart';

class StartPopupMenuButton extends StatelessWidget {
  final Function(StartCardMenuItem) onSelected;

  const StartPopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<StartCardMenuItem>>[
        const PopupMenuItem<StartCardMenuItem>(
          value: StartCardMenuItem.rename,
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
        const PopupMenuItem<StartCardMenuItem>(
          value: StartCardMenuItem.delete,
          child: Row(
            children: [
              Icon(Icons.delete_outlined),
              SizedBox(
                width: 12,
              ),
              Text('Delete'),
            ],
          ),
        ),
      ],
    );
  }
}
