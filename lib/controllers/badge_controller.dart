
// This abstract class defines that a controller, 
// that controls a configuration (view) with a badge
// must have a method to refresh the badge state
abstract class BadgeController {
  int badgeLabel = 0;
  bool badgeVisible = false;
  void refreshBadgeState();
}