import 'package:flutter/material.dart';

import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';

class SortDialog extends StatefulWidget {
  final SortCriterion initialCriterion;
  final SortDirection initialDirection;
  final void Function(SortCriterion, SortDirection) onValueChange;

  const SortDialog(
      this.initialCriterion, this.initialDirection, this.onValueChange,
      {super.key});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  late SortCriterion _selectedOrder = widget.initialCriterion;
  late SortDirection _selectedOrientation = widget.initialDirection;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Change sorting"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile(
                title: const Text("Creation date"),
                value: SortCriterion.creationDate,
                groupValue: _selectedOrder,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrder = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
            RadioListTile(
                title: const Text("Name"),
                value: SortCriterion.name,
                groupValue: _selectedOrder,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrder = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
            RadioListTile(
                title: const Text("Longest Time"),
                value: SortCriterion.longestTime,
                groupValue: _selectedOrder,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrder = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
            RadioListTile(
                title: const Text("Longest Lap Time"),
                value: SortCriterion.longestLapTime,
                groupValue: _selectedOrder,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrder = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
            RadioListTile(
                title: const Text("Custom"),
                value: SortCriterion.customReordable,
                groupValue: _selectedOrder,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrder = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
            const Divider(),
            RadioListTile(
                title: const Text("Ascending"),
                value: SortDirection.ascending,
                groupValue: _selectedOrientation,
                onChanged: (SortDirection? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrientation = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
            RadioListTile(
                title: const Text("Descending"),
                value: SortDirection.descending,
                groupValue: _selectedOrientation,
                onChanged: (SortDirection? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedOrientation = value;
                  });
                  widget.onValueChange(_selectedOrder, _selectedOrientation);
                }),
          ],
        ));
  }
}
