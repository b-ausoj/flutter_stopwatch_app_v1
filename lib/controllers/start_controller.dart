import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';

class StartController extends BadgeController {
  @override
  String name;

  int badgeLabel = 0;
  bool badgeVisible = false;

  StartController(this.name);

  @override
  void refreshBadge() {
    isTextBadgeRequired(name).then((value) => badgeVisible = value);
    getUnseenRecordsCount().then((value) => badgeLabel = value);
  }



}