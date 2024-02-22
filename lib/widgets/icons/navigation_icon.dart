import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';

class NavIcon extends StatefulWidget {
  final BadgeController stopwatchesPageController;

  const NavIcon(this.stopwatchesPageController, {super.key});

  @override
  State<NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<NavIcon> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge(
        isLabelVisible: widget.stopwatchesPageController.badgeVisible,
        label: widget.stopwatchesPageController.badgeLabel > 0
            ? Text("${widget.stopwatchesPageController.badgeLabel}")
            : null,
        smallSize: 8.0,
        child: const Icon(Icons.menu),
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
