import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/home_menu_item.dart';

class HomePopupMenuButton extends StatelessWidget {
  final Function(HomeMenuItem) onSelected;

  const HomePopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<HomeMenuItem>>[
        const PopupMenuItem<HomeMenuItem>(
          value: HomeMenuItem.addStopwatch,
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
        const PopupMenuItem<HomeMenuItem>(
          value: HomeMenuItem.saveAll,
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
        const PopupMenuItem<HomeMenuItem>(
          value: HomeMenuItem.resetAll,
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
        const PopupMenuItem<HomeMenuItem>(
          value: HomeMenuItem.deleteAll,
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
        const PopupMenuItem<HomeMenuItem>(
          value: HomeMenuItem.changeOrder,
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
        const PopupMenuItem<HomeMenuItem>(
          value: HomeMenuItem.settings,
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
