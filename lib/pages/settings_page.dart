import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/widgets/back_icon.dart';

class SettingsPage extends StatelessWidget {
  final bool isBadgeVisible;
  const SettingsPage(this.isBadgeVisible, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        leading: BackIcon(isBadgeVisible),
      ),
      body: const Center(
        child: Text(
          "There are currently no settings \nPlease have a look at the about page \n;)",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
