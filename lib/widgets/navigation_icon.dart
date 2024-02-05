import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/managers/home_manager.dart';

class NavIcon extends StatefulWidget {
  final HomeManager homeManager;

  const NavIcon(this.homeManager, {super.key});

  @override
  State<NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<NavIcon> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Badge(
        isLabelVisible: widget.homeManager.badgeVisible,
        label: widget.homeManager.badgeLabel > 0 ? Text("${widget.homeManager.badgeLabel}") : null,
        smallSize: 8.0,
        child: const Icon(Icons.menu),
      ),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
