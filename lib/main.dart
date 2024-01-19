import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/pages/home.dart';

void main() {
  runApp(const MyApp());
}

// TODO: undo in history page
// TODO: settings page where user can set default order and orientation

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
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
      home: const Home(),
    );
  }
}
