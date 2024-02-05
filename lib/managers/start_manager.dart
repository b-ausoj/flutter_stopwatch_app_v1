import 'package:flutter_stopwatch_app_v1/managers/manager.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StartManager extends Manager {
  @override
  String name;

  int badgeLabel = 0;
  bool badgeVisible = false;

  StartManager(this.name);

  @override
  void updateBadge() {
    isTextBadgeRequired(name).then((value) => badgeVisible = value);
    getUnseenRecordsCount().then((value) => badgeLabel = value);
  }



}