import 'package:flutter/material.dart';

class DeleteScreenDialog extends StatefulWidget {
  final void Function() onAccept;
  final String name;

  const DeleteScreenDialog(this.name, {required this.onAccept, super.key});

  @override
  State<DeleteScreenDialog> createState() => _DeleteScreenDialogState();
}

class _DeleteScreenDialogState extends State<DeleteScreenDialog> {
  bool confirmed = false;
  bool red = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete ${widget.name}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Checkbox(
                value: confirmed,
                onChanged: (bool? value) {
                  confirmed = value ?? false;
                  setState(() {});
                },
              ),
              const SizedBox(width: 180,child: Text("Are you sure? This can not be undone",),)
            ],
          ),
          red
              ? const Text(
                  "You have to check the box",
                  style: TextStyle(color: Colors.red),
                )
              : Container(),
          //Container(),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("CANCEL"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text("CONFIRM"),
          onPressed: () {
            if (confirmed) {
              widget.onAccept();
              Navigator.of(context).pop();
            } else {
              // show little red text or make checkbox red
              red = true;
              setState(() {
                
              });
            }
          },
        ),
      ],
    );
  }
}
