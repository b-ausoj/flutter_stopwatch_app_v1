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
  late SortCriterion _selectedCriterion = widget.initialCriterion;
  late SortDirection _selectedDirection = widget.initialDirection;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Change sorting"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // TODO: can make this shorter with map and the enum values string function
            RadioListTile(
                title: const Text("Creation date"),
                value: SortCriterion.creationDate,
                groupValue: _selectedCriterion,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCriterion = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
            RadioListTile(
                title: const Text("Name"),
                value: SortCriterion.name,
                groupValue: _selectedCriterion,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCriterion = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
            RadioListTile(
                title: const Text("Longest Time"),
                value: SortCriterion.longestTime,
                groupValue: _selectedCriterion,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCriterion = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
            RadioListTile(
                title: const Text("Longest Lap Time"),
                value: SortCriterion.longestLapTime,
                groupValue: _selectedCriterion,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCriterion = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
            RadioListTile(
                title: const Text("Custom"),
                value: SortCriterion.customReordable,
                groupValue: _selectedCriterion,
                onChanged: (SortCriterion? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedCriterion = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
            const Divider(),
            RadioListTile(
                title: const Text("Ascending"),
                value: SortDirection.ascending,
                groupValue: _selectedDirection,
                onChanged: (SortDirection? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedDirection = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
            RadioListTile(
                title: const Text("Descending"),
                value: SortDirection.descending,
                groupValue: _selectedDirection,
                onChanged: (SortDirection? value) {
                  if (value == null) return;
                  setState(() {
                    _selectedDirection = value;
                  });
                  widget.onValueChange(_selectedCriterion, _selectedDirection);
                }),
          ],
        ));
  }
}
