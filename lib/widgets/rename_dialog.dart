import 'package:flutter/material.dart';

class RenameDialog extends StatelessWidget {
  final String initialName;
  final void Function(String) onAccept;

  late final TextEditingController _controller = TextEditingController.fromValue(TextEditingValue(text: initialName, selection: TextSelection(baseOffset: 0, extentOffset: initialName.length)));

  RenameDialog(this.initialName, this.onAccept, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rename stopwatch"),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
        controller: _controller,
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            onAccept(_controller.text);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}