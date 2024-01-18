import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

// This widget is the root of your application.
@override
Widget build(BuildContext context) {
	return MaterialApp(
	title: 'Stopwatch',
	theme: ThemeData(
		// This is the theme of your application.
		//
		// TRY THIS: Try running your application with "flutter run". You'll see
		// the application has a blue toolbar. Then, without quitting the app,
		// try changing the seedColor in the colorScheme below to Colors.green
		// and then invoke "hot reload" (save your changes or press the "hot
		// reload" button in a Flutter-supported IDE, or press "r" if you used
		// the command line to start the app).
		//
		// Notice that the counter didn't reset back to zero; the application
		// state is not lost during the reload. To reset the state, use hot
		// restart instead.
		//
		// This works for code too, not just values: Most code changes can be
		// tested with just a hot reload.
		colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
		useMaterial3: true,
	),
	home: const MyHomePage(),
	);
}
}

class MyHomePage extends StatefulWidget {
const MyHomePage({super.key});

@override
State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
late Stopwatch stopwatch;
late Timer t;

void handleStartStop() {
	if(stopwatch.isRunning) {
	stopwatch.stop();
	}
	else {
	stopwatch.start();
	}
}

String returnFormattedText() {
	var milli = stopwatch.elapsed.inMilliseconds;

	String milliseconds = (milli % 1000).toString().padLeft(3, "0"); // this one for the miliseconds
	String seconds = ((milli ~/ 1000) % 60).toString().padLeft(2, "0"); // this is for the second
	String minutes = ((milli ~/ 1000) ~/ 60).toString().padLeft(2, "0"); // this is for the minute

	return "$minutes:$seconds:$milliseconds";
}

@override
void initState() {
	super.initState();
	stopwatch = Stopwatch();

	t = Timer.periodic(const Duration(milliseconds: 100), (timer) {
	setState(() {});
	});
}

@override
Widget build(BuildContext context) {
	return Scaffold(
	body: SafeArea(
		child: Center(
		child: Column( // this is the column
			mainAxisAlignment: MainAxisAlignment.center,
			children: [

			CupertinoButton(
				onPressed: () {
				handleStartStop();
				},
				padding: const EdgeInsets.all(0),
				child: Container(
				height: 250,
				alignment: Alignment.center,
				decoration: BoxDecoration(
					shape: BoxShape.circle, // this one is use for make the circle on ui.
					border: Border.all(
					color: const Color(0xff0395eb),
					width: 4,
					),
				),
				child: Text(returnFormattedText(), style: const TextStyle(
					color: Colors.black,
					fontSize: 40,
					fontWeight: FontWeight.bold,
				),),
				),
			),

			const SizedBox(height: 15,),

			CupertinoButton(	 // this the cupertino button and here we perform all the reset button function
				onPressed: () {
				stopwatch.reset();
				},
				padding: const EdgeInsets.all(0),
				child: const Text("Reset", style: TextStyle(
				color: Colors.red,
				fontWeight: FontWeight.bold,
				),),
			),

			],
		),
		),
	),
	); 
}
}
