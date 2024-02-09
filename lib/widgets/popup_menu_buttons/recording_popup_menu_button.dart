import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recording_card_menu_item.dart';

class RecordingPopupMenuButton extends StatelessWidget {
  final Function(RecordingCardMenuItem) onSelected;

  const RecordingPopupMenuButton({required this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<RecordingCardMenuItem>>[
              const PopupMenuItem<RecordingCardMenuItem>(
                value: RecordingCardMenuItem.rename,
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Rename'),
                  ],
                ),
              ),
              const PopupMenuItem<RecordingCardMenuItem>(
                value: RecordingCardMenuItem.export,
                child: Row(
                  children: [
                    Icon(Icons.save_alt),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Export'),
                  ],
                ),
              ),
              const PopupMenuItem<RecordingCardMenuItem>(
                value: RecordingCardMenuItem.share,
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Share'),
                  ],
                ),
              ),
              const PopupMenuItem<RecordingCardMenuItem>(
                value: RecordingCardMenuItem.delete,
                child: Row(
                  children: [
                    Icon(Icons.delete_outline),
                    SizedBox(
                      width: 12,
                    ),
                    Text('Delete'),
                  ],
                ),
              ),
            ]);
  }
}
