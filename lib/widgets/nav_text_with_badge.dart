import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class NavTextWithBadge extends StatefulWidget {
  final String name;
  final bool isRecordings;

  const NavTextWithBadge(this.name, this.isRecordings, {super.key});

  @override
  State<NavTextWithBadge> createState() => _NavTextWithBadgeState();
}

class _NavTextWithBadgeState extends State<NavTextWithBadge> {
  bool badgeVisible = false;
  int badgeLabel = 0;

  @override
  void initState() {
    log("initState of text with badge in drawer?");
    super.initState();
    isTextBadgeRequired(widget.name)
        .then((value) => setState(() => badgeVisible = value));
    getUnseenRecordingsCount().then((value) => badgeLabel = value);
  }

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: badgeVisible || badgeLabel > 0 && widget.isRecordings,
      label: badgeLabel > 0 && widget.isRecordings ? Text("$badgeLabel") : null,
      alignment: Alignment.centerRight,
      offset: const Offset(8, 0),
      smallSize: 8.0,
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Text(widget.name),
      ),
    );
  }
}
