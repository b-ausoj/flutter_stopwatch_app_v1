import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/stopwatch_card_menu_item.dart';

class StopwatchPopupMenuButton extends StatelessWidget {
  final Function(StopwatchCardMenuItem) onSelected;

  const StopwatchPopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => StopwatchCardMenuItem.values
          .map((menuItem) => PopupMenuItem<StopwatchCardMenuItem>(
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
