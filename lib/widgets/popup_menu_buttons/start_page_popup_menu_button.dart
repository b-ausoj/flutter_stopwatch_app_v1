import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_page_card_menu_item.dart';

class StartPagePopupMenuButton extends StatelessWidget {
  final Function(StartPageCardMenuItem) onSelected;

  const StartPagePopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<StartPageCardMenuItem>>[
        const PopupMenuItem<StartPageCardMenuItem>(
          value: StartPageCardMenuItem.rename,
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
        const PopupMenuItem<StartPageCardMenuItem>(
          value: StartPageCardMenuItem.delete,
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
