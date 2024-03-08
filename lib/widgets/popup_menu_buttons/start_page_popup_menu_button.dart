import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/start_page_card_menu_item.dart';

class StartPagePopupMenuButton extends StatelessWidget {
  final Function(StartPageCardMenuItem) onSelected;

  const StartPagePopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => StartPageCardMenuItem.values
          .map((menuItem) => PopupMenuItem<StartPageCardMenuItem>(
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
          .toList(),
    );
  }
}
