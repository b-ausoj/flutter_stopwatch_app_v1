import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StartController extends BadgeController {
  List<String> names = [];
  // needs the label/visible for the menu(drawr) icon an the screen list items
  // TODO: use better naming for the list
  List<bool> badgeVisibles = [];

  void Function() update;

  StartController(this.update) {
    loadScreens(names, update).then((value) => refreshBadgeState());
  }

  @override
  void refreshBadgeState() {
    badgeVisibles = List.filled(names.length, false);
    // could do all of that in parallel instead of .then
    isMenuBadgeRequired("").then((value) => badgeVisible = value);
    getUnseenRecordingsCount().then((value) => badgeLabel = value);

    for (int i = 0; i < names.length; i++) {
      isTextBadgeRequired(names[i]).then((value) => badgeVisibles[i] = value);
    }
    update(); // calls set state because start badge doesn't have a ticker with setState
  }

  void refreshNames() {
    loadScreens(names, update);
  }

  void removeScreen(String name) {
    deleteScreen(name).then((value) {
      names.remove(name);
      refreshBadgeState();
    });
  }
}
