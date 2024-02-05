import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StopwatchIcon extends StatefulWidget {
  final String name;

  const StopwatchIcon(this.name, {super.key});

  @override
  State<StopwatchIcon> createState() => _StopwatchIconState();
}

class _StopwatchIconState extends State<StopwatchIcon> {
  bool badgeVisible = false;

  @override
  void initState() {
    super.initState();
    //isIconBadgeRequired(widget.name).then((value) => setState(() => badgeVisible = value));

  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: badgeVisible,
      //alignment: Alignment.topLeft,
      //smallSize: 8.0,
      child: const Icon(Icons.timer_outlined),
    );
  }
}
