import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/pages/start_page.dart';

void main() {
  runApp(const MyApp());
}

// TODO: at renaming stopwatches / saved stopwatches / setups, ensure that there is at least one character
// TODO: reorganize recordings page
// TODO: decide on a default order and orientation
// TODO: decide on order or sorting as a text
// TODO: write about page mit feedback, contact, rate us page
// TODO: write privacy policy
// TODO: write terms of service
// TODO: write help page
// TODO: write tutorial page
// TODO: add introduction screen

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //resetSharedPreferences();
    //logAllSharedPreferences();
    return MaterialApp(
      title: "MultiStopwatch by Josua",
      theme: ThemeData(
        useMaterial3: true,
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(Colors.white),
          trackColor: MaterialStateProperty.all(Colors.black),
        ),
        appBarTheme: const AppBarTheme(color: Colors.white),
        scaffoldBackgroundColor: Colors.white,
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
      home: const StartPage(
        sharedPreferencesKey: "key_v5",
      ),
    );
  }
}
