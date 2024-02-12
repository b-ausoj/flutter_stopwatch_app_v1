import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/start_page_controller.dart';

class StartTextWithBadge extends StatefulWidget {
  final StartController controller;
  final int index;

  const StartTextWithBadge(this.controller, this.index, {super.key});

  @override
  State<StartTextWithBadge> createState() => _StartTextWithBadgeState();
}

class _StartTextWithBadgeState extends State<StartTextWithBadge> {
  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: widget.controller.badgeVisibles[widget.index],
      alignment: Alignment.centerRight,
      offset: const Offset(8, 0),
      smallSize: 8.0,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, left: 16.0),
        child: Text(
          widget.controller.names[widget.index],
        ),
      ),
    );
  }
}
