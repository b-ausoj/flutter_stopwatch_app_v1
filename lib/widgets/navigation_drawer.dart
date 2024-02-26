import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/setup_model.dart';
import 'package:flutter_stopwatch_app_v1/pages/about_page.dart';
import 'package:flutter_stopwatch_app_v1/pages/recordings_page.dart';
import 'package:flutter_stopwatch_app_v1/pages/settings_page.dart';
import 'package:flutter_stopwatch_app_v1/pages/stopwatches_page.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';
import 'package:flutter_stopwatch_app_v1/widgets/text_with_badge/nav_text_with_badge.dart';

class NavDrawer extends StatefulWidget {
  final List<SetupModel> allSetups;
  // add list of startControllers so that if we open the drawer from start page and
  // then navigate to a setup and go back per arrows (back wishing)
  // the badge will be updated
  final BadgeController controller;
  final SetupModel? setup;
  final bool isStartPage;
  const NavDrawer(this.allSetups, this.controller, this.setup, this.isStartPage,
      {super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late int _selectedIndex =
      widget.setup == null ? -1 : widget.allSetups.indexOf(widget.setup!);

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        onDestinationSelected: handleSetupChanged,
        selectedIndex: _selectedIndex,
        backgroundColor: const Color(0xFFDFDFDF),
        indicatorColor: const Color(0xFFBFBFBF),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
            child: Text(
              "Stopwatch by Josua",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ...widget.allSetups.map((SetupModel setup) =>
              NavigationDrawerDestination(
                  icon: const Icon(Icons.timer_outlined),
                  label: Flexible(
                      child: NavTextWithBadge(
                          setup.name, setup, widget.allSetups, false)))),
          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text("Add a new setup")),
          const Divider(),
          const NavigationDrawerDestination(
              icon: Icon(Icons.history),
              label: NavTextWithBadge("Recordings", null, null, true)),
          const NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined), label: Text("Settings")),
          const NavigationDrawerDestination(
              icon: Icon(Icons.info_outlined), label: Text("About")),
        ]);
  }

  void handleSetupChanged(int selectedIndex) {
    SetupModel? selectedSetup = widget.allSetups.elementAtOrNull(selectedIndex);

    if (selectedSetup != null) {
      // setup x
      Navigator.pop(context);
      if (!widget.isStartPage) {
        Navigator.pop(context);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) =>
                  StopwatchesPage(selectedSetup, widget.allSetups)))
          .then((value) => widget.controller.refreshBadgeState());
    } else {
      int base = widget.allSetups.length;
      switch (selectedIndex - base) {
        case 0:
          // add setup
          Navigator.pop(context);
          if (!widget.isStartPage) {
            Navigator.pop(context);
          }
          SetupModel newSetup = SetupModel(
              "Setup ${widget.allSetups.length + 1}",
              0,
              SortCriterion.creationDate,
              SortDirection.ascending,
              []); // TODO: get the default orientation and criterion from somewhere
          widget.allSetups.add(newSetup);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      StopwatchesPage(newSetup, widget.allSetups)))
              .then((value) => widget.controller.refreshBadgeState());
          break;
        case 1:
          // recordings
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => RecordingsPage(widget.allSetups)))
              .then((value) => widget.controller.refreshBadgeState());
          break;
        case 2:
          // settings
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  SettingsPage(isBackBadgeRequired(widget.allSetups))));
          break;
        case 3:
          // about
          Navigator.pop(context);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  AboutPage(isBackBadgeRequired(widget.allSetups))));

          break;
        default:
          throw Exception("Invalid selectedSetup state");
      }
    }

    setState(() {
      _selectedIndex = selectedIndex;
    });
  }
}
