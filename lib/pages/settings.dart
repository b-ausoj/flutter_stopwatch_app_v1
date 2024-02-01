import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: const Center(
        child: Text("There are currently no settings \nPlease have a look at the about page \n;)", textAlign: TextAlign.center,),
      ),);
  }
}