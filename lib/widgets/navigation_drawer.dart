import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/pages/about.dart';
import 'package:flutter_stopwatch_app_v1/pages/history.dart';
import 'package:flutter_stopwatch_app_v1/pages/home.dart';
import 'package:flutter_stopwatch_app_v1/pages/settings.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';

class NavDrawer extends StatefulWidget {
  final List<String> screens;
  final String name;
  const NavDrawer(this.screens, this.name, {super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late int _selectedIndex = widget.screens.indexOf(widget.name);
  late final List<String> _screens = widget.screens;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
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
          ..._screens.map((String screen) => NavigationDrawerDestination(
              icon: const Icon(Icons.timer_outlined), label: Text(screen))),
          const NavigationDrawerDestination(
              icon: Icon(Icons.add), label: Text("Add Screen")),
          const Divider(),
          const NavigationDrawerDestination(
              icon: Icon(Icons.history), label: Text("Records")),
          NavigationDrawerDestination(
              icon: Badge.count(count: 0,
              child: Icon(Icons.settings_outlined)), label: Text("Settings")),
          const NavigationDrawerDestination(
              icon: Icon(Icons.info_outlined), label: Text("About")),
        ]);
  }

  void handleScreenChanged(int selectedScreen) {
    log("$selectedScreen");
    String? _selectedScreen = _screens.elementAtOrNull(selectedScreen);

    if (_selectedScreen != null) {
      Navigator.pop(context);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Home(_selectedScreen)));
    } else {
      int base = _screens.length;
      switch (selectedScreen - base) {
        case 0:
          Navigator.pop(context);
          _screens.add("Screen ${_screens.length + 1}");
          storeScreens(_screens);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  Home("Screen ${_screens.length}")));
          break;
        case 1:
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const History()));
          break;
        case 2:
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Settings()));
          break;
        case 3:
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const About()));
          break;
        default:
          throw Exception("Invalid selectedScreen state");
      }
    }

    setState(() {
      _selectedIndex = selectedScreen;
    });
  }
}
