import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/utils/times_formatting_utils.dart';
import 'package:flutter_stopwatch_app_v1/widgets/recording_card.dart';

class RecordingsSetTextWithBadge extends StatefulWidget {
  final List<RecordingCard> list;
  final DateTime timeStamp;

  const RecordingsSetTextWithBadge(this.list, this.timeStamp, {super.key});

  @override
  State<RecordingsSetTextWithBadge> createState() => _RecordingsSetTextWithBadgeState();
}

class _RecordingsSetTextWithBadgeState extends State<RecordingsSetTextWithBadge> {
  @override
  Widget build(BuildContext context) {
    return Badge(
            alignment: Alignment.centerRight,
            offset: const Offset(24, -1),
            isLabelVisible: !widget.list.first.recordingModel.viewed,
            label: Text("${widget.list.length}"),
            child: Text(dateTimeToString(widget.timeStamp)),
          );
  }
}