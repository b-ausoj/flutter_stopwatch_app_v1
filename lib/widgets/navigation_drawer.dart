import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/controllers/badge_controller.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/models/configuration_model.dart';
import 'package:flutter_stopwatch_app_v1/pages/about_page.dart';
import 'package:flutter_stopwatch_app_v1/pages/recordings_page.dart';
import 'package:flutter_stopwatch_app_v1/pages/settings_page.dart';
import 'package:flutter_stopwatch_app_v1/pages/stopwatches_page.dart';
import 'package:flutter_stopwatch_app_v1/utils/badge_checking.dart';
import 'package:flutter_stopwatch_app_v1/widgets/text_with_badge/nav_text_with_badge.dart';

class NavDrawer extends StatefulWidget {
  final List<ConfigurationModel> configurations;
  // add list of startControllers so that if we open the drawer from start page and
  // then navigate to a configuration and go back per arrows (back wishing)
  // the badge will be updated
  final BadgeController controller;
  final ConfigurationModel? configurationModel;
  final bool isStartPage;
  const NavDrawer(this.configurations, this.controller, this.configurationModel,
      this.isStartPage,
      {super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late int _selectedIndex = widget.configurationModel == null
      ? -1
      : widget.configurations.indexOf(widget.configurationModel!);
  late final List<ConfigurationModel> _configurations = widget.configurations;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        onDestinationSelected: handleConfigurationChanged,
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
          ..._configurations.map((ConfigurationModel configuration) =>
              NavigationDrawerDestination(
                  icon: const Icon(Icons.timer_outlined),
                  label: NavTextWithBadge(configuration.name, false))),
          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text("Add Configuration")),
          const Divider(),
          const NavigationDrawerDestination(
              icon: Icon(Icons.history),
              label: NavTextWithBadge("Recordings", true)),
          const NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined), label: Text("Settings")),
          const NavigationDrawerDestination(
              icon: Icon(Icons.info_outlined), label: Text("About")),
        ]);
  }

  void handleConfigurationChanged(int selectedIndex) {
    ConfigurationModel? selectedConfiguration =
        _configurations.elementAtOrNull(selectedIndex);

    if (selectedConfiguration != null) {
      // configuration x
      Navigator.pop(context);
      if (!widget.isStartPage) {
        Navigator.pop(context);
      }
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => StopwatchesPage(
                  selectedConfiguration, widget.configurations)))
          .then((value) => widget.controller.refreshBadgeState());
    } else {
      int base = _configurations.length;
      switch (selectedIndex - base) {
        case 0:
          // add configuration
          Navigator.pop(context);
          if (!widget.isStartPage) {
            Navigator.pop(context);
          }
          ConfigurationModel newConfiguration = ConfigurationModel(
              "Configuration ${_configurations.length + 1}",
              0,
              SortCriterion.creationDate,
              SortDirection.ascending,
              []); // TODO: get the default orientation and criterion from somewhere
          _configurations.add(newConfiguration);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      StopwatchesPage(newConfiguration, widget.configurations)))
              .then((value) => widget.controller.refreshBadgeState());
          break;
        case 1:
          // recordings
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => const RecordingsPage()))
              .then((value) => widget.controller.refreshBadgeState());
          break;
        case 2:
          // settings
          Navigator.pop(context);
          isBackBadgeRequired().then((value) => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SettingsPage(value))));
          break;
        case 3:
          // about
          Navigator.pop(context);
          isBackBadgeRequired().then((value) => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AboutPage(value))));

          break;
        default:
          throw Exception("Invalid selectedConfiguration state");
      }
    }

    setState(() {
      _selectedIndex = selectedIndex;
    });
  }
}
