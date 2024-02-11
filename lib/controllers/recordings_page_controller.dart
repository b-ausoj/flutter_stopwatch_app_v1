import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_set_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/recordings_set_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/recording_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/text_with_badge/recordings_set_text_with_badge.dart';

class RecordingsPageController {
  BuildContext context;
  void Function() refresh;
  final List<RecordingCard> recordingCards = [];
  final List<Widget> recordingsList = [];

  RecordingsPageController(this.context, this.refresh);

  void createRecordingList() {
    recordingsList.clear();
    if (recordingCards.isEmpty) return;

    DateTime last = recordingCards.first.recordingModel.startingTime;
    List<RecordingCard> list = [];

    for (RecordingCard card in recordingCards) {
      if (last == card.recordingModel.startingTime) {
        list.add(card);
      } else {
        var timeStamp = last.copyWith();
        recordingsList.add(Card(
          color: const Color(0xFFEFEFEF),
          elevation: 0,
          child: ExpansionTile(
            onExpansionChanged: (value) {
              if (!value) return; // only change if opens and not on close
              setViewedToTrue(timeStamp);
            },
            shape: const Border(),
            controlAffinity: ListTileControlAffinity.leading,
            trailing: RecordingsSetPopupMenuButton(
                onSelected: (RecordingsSetMenuItem item) {
              switch (item) {
                case RecordingsSetMenuItem.deleteAll:
                  deleteRecordingsSet(timeStamp);
                  break;
                case RecordingsSetMenuItem.exportAll:
                  break;
              }
              //selectedMenu = item;
              refresh();
            }),
            title: Center(child: RecordingsSetTextWithBadge(list, timeStamp)),
            subtitle: Center(
                child: Text("from ${list.first.recordingModel.fromScreen}")),
            children: list,
          ),
        ));
        list = [card];
      }
      last = card.recordingModel.startingTime;
    }
    if (list.isNotEmpty) {
      recordingsList.add(Card(
        elevation: 0,
        color: const Color(0xFFEFEFEF),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            if (!value) return; // only change if opens and not on close
            setViewedToTrue(last);
          },
          shape: const Border(),
          controlAffinity: ListTileControlAffinity.leading,
          trailing: RecordingsSetPopupMenuButton(
              onSelected: (RecordingsSetMenuItem item) {
            switch (item) {
              case RecordingsSetMenuItem.deleteAll:
                deleteRecordingsSet(last);
                break;
              case RecordingsSetMenuItem.exportAll:
                break;
            }
            //selectedMenu = item;
            refresh();
          }),
          title: Center(child: RecordingsSetTextWithBadge(list, last)),
          subtitle: Center(
              child: Text("from ${list.first.recordingModel.fromScreen}")),
          children: list,
        ),
      ));
    }
  }

  void deleteAllRecordings() {
    recordingCards.removeRange(0, recordingCards.length);
    createRecordingList();
    storeRecordingsState(this);
    refresh();
  }

  void deleteRecordingsSet(DateTime timestamp) {
    recordingCards.removeWhere(
        (element) => element.recordingModel.startingTime == timestamp);
    createRecordingList();
    storeRecordingsState(this);
    refresh();
  }

  Future<void> deleteRecoding(int id, String name) async {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Stopwatch '$name' has been removed")));
    recordingCards.removeWhere((element) => element.recordingModel.id == id);
    createRecordingList();
    storeRecordingsState(this);
    refresh();
  }

  void setViewedToTrue(DateTime timestamp) {
    bool changed = false;
    for (RecordingCard card in recordingCards) {
      if (card.recordingModel.startingTime == timestamp &&
          !card.recordingModel.viewed) {
        card.recordingModel.viewed = true;
        changed = true;
      }
    }
    if (changed) {
      // only recreate list and store state if something changed
      createRecordingList();
      storeRecordingsState(this);
      refresh();
    }
  }
}
