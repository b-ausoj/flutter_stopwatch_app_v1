import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

// TODO: This class is very ugly and its constructor, please revise it
class NavTextWithBadge extends StatefulWidget {
  final String name;
  final SetupModel? setup;
  final List<SetupModel>? allSetups;
  final bool isRecordings;

  const NavTextWithBadge(
      this.name, this.setup, this.allSetups, this.isRecordings,
      {super.key});

  @override
  State<NavTextWithBadge> createState() => _NavTextWithBadgeState();
}

class _NavTextWithBadgeState extends State<NavTextWithBadge> {
  bool badgeVisible = false;
  int badgeLabel = 0;

  @override
  void initState() {
    super.initState();
    if (!widget.isRecordings) {
      // TODO: Attention, this could throw an exception
      badgeVisible = isTextBadgeRequired(widget.allSetups!, widget.setup!);
    }
    getUnseenRecordingsCount().then((value) => setState(() =>  badgeLabel = value,));
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
        child: Text(
          widget.name,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
