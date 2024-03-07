import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/recordings_set_menu_item.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';
import 'package:flutter_stopwatch_app_v1/utils/export_to_csv.dart';
import 'package:flutter_stopwatch_app_v1/utils/snackbar_utils.dart';
import 'package:flutter_stopwatch_app_v1/widgets/popup_menu_buttons/recordings_set_popup_menu_button.dart';
import 'package:flutter_stopwatch_app_v1/widgets/cards/recording_card.dart';
import 'package:flutter_stopwatch_app_v1/widgets/text_with_badge/recordings_set_text_with_badge.dart';

class RecordingsPageController extends BadgeController {
  BuildContext context;
  void Function() refresh;
  final List<RecordingCard> recordingCards = [];
  final List<Widget> recordingsList = [];
  final List<SetupModel> allSetups;
  final SettingsModel settings;

  RecordingsPageController(
      this.context, this.refresh, this.allSetups, this.settings);

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
                  exportRecordingsSetToCSV(
                      recordingCards
                          .where((element) =>
                              element.recordingModel.startingTime == timeStamp)
                          .toList(),
                      settings);
                  break;
              }
              //selectedMenu = item;
              refresh();
            }),
            title: Center(child: RecordingsSetTextWithBadge(list, timeStamp)),
            subtitle: Center(
                child: Text("from ${list.first.recordingModel.fromSetup}")),
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
                exportRecordingsSetToCSV(
                    recordingCards
                        .where((element) =>
                            element.recordingModel.startingTime == last)
                        .toList(),
                    settings);
                break;
            }
            //selectedMenu = item;
            refresh();
          }),
          title: Center(child: RecordingsSetTextWithBadge(list, last)),
          subtitle: Center(
              child: Text("from ${list.first.recordingModel.fromSetup}")),
          children: list,
        ),
      ));
    }
  }

  void deleteAllRecordings() {
    List<RecordingCard> deletedCards = [];
    deletedCards.addAll(recordingCards);
    recordingCards.clear();
    createRecordingList();
    storeRecordingsState(this);
    refresh();
    showLongSnackBar(context, "All recordings have been deleted",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              recordingCards.addAll(deletedCards);
              createRecordingList();
              storeRecordingsState(this);
              refresh();
            }));
  }

  Future<void> deleteRecoding(int id, String name) async {
    RecordingCard? deletedCard;
    recordingCards.removeWhere((element) {
      bool remove = element.recordingModel.id == id;
      if (remove) deletedCard = element;
      return remove;
    });
    createRecordingList();
    storeRecordingsState(this);
    refresh();
    if (deletedCard != null) {
      showLongSnackBar(context, "Recording have been deleted",
          action: SnackBarAction(
              label: "Undo",
              onPressed: () {
                recordingCards.add(deletedCard!);
                createRecordingList();
                storeRecordingsState(this);
                refresh();
              }));
    }
  }

  void deleteRecordingsSet(DateTime timestamp) {
    List<RecordingCard> deletedCards = [];
    recordingCards.removeWhere((element) {
      bool remove = element.recordingModel.startingTime == timestamp;
      if (remove) deletedCards.add(element);
      return remove;
    });
    createRecordingList();
    storeRecordingsState(this);
    refresh();
    showLongSnackBar(context, "Recordings have been deleted",
        action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              recordingCards.addAll(deletedCards);
              createRecordingList();
              storeRecordingsState(this);
              refresh();
            }));
  }

  @override
  void refreshBadgeState() {
    badgeVisible = isBackBadgeRequired(allSetups);
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
