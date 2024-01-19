import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/pages/history.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int screenIndex = 0;

  void handleScreenChanged(int selectedScreen) {
    screenIndex = selectedScreen;
    if (screenIndex == 0) {
      Navigator.pop(context);
    } else if (screenIndex == 1) {
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const History()));
    } else {
      Navigator.pop(context);
    }
    screenIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
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
          const NavigationDrawerDestination(
              icon: Icon(Icons.timer_outlined), label: Text("Stopwatches")),
          const NavigationDrawerDestination(
              icon: Icon(Icons.history), label: Text("History")),
          const NavigationDrawerDestination(
              icon: Icon(Icons.settings_outlined), label: Text("Settings")),
        ]);
  }
}
