import 'package:flutter/material.dart';

class AddStopwatchCard extends StatelessWidget {
  final void Function() addStopwatch;

  const AddStopwatchCard(this.addStopwatch, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEFEFEF),
      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 4),
      child: InkWell(
        onTap: () {
          addStopwatch();
        },
        child: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              Text(
                "Add Stopwatch",
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Icon(Icons.add)
            ],
          ),
        ),
      ),
    );
  }
}
