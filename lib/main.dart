import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/pages/start_page.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';

void main() {
  runApp(const MyApp());
}

// TODO: at renaming stopwatches / saved stopwatches / configurations, ensure that there is at least one character
// TODO: undo in recordings page
// TODO: reorganize recordings page
// TODO: settings page where user can set default order and orientation
// TODO: decide on a default order and orientation
// TODO: decide on order or sorting as a text
// TODO: write about page mit feedback, contact, rate us page
// TODO: write privacy policy
// TODO: write terms of service
// TODO: write help page
// TODO: write tutorial page
// TODO: recordings instead of recordings
// TODO: add introduction configuration
// TODO: add an configuration screen where I can save all the stopwatches (with name and order) and load some others

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //resetSharedPreferences();
    logAllSharedPreferences();
    return MaterialApp(
      title: "Stopwatch by Josua",
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.white,
            primary: Colors.black,
            surfaceTint: Colors.white),
        popupMenuTheme: const PopupMenuThemeData(
          color: Color(0xFFDFDFDF),
          surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Color(0xFFDFDFDF),
          surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const StartPage(),
    );
  }
}
