
// This abstract class defines that a controller, 
// that controls a screen (view) with a badge
// must have a method to refresh the badge state
abstract class BadgeController {
  String get name;
  void refreshBadgeState();
}