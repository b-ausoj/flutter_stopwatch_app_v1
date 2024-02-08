import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';

class NavIcon extends StatefulWidget {
  final BadgeController homeController;

  const NavIcon(this.homeController, {super.key});

  @override
  State<NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<NavIcon> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge(
        isLabelVisible: widget.homeController.badgeVisible,
        label: widget.homeController.badgeLabel > 0 ? Text("${widget.homeController.badgeLabel}") : null,
        smallSize: 8.0,
        child: const Icon(Icons.menu),
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
