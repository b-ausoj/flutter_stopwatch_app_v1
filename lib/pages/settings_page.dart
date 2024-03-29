import 'package:flutter/material.dart';
import 'package:flutter_stopwatch_app_v1/enums/csv_delimiter.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_criterion.dart';
import 'package:flutter_stopwatch_app_v1/enums/sort_direction.dart';
import 'package:flutter_stopwatch_app_v1/enums/time_format.dart';
import 'package:flutter_stopwatch_app_v1/models/settings_model.dart';
import 'package:flutter_stopwatch_app_v1/services/shared_preferences_service.dart';
import 'package:flutter_stopwatch_app_v1/widgets/icons/back_icon.dart';

class SettingsPage extends StatefulWidget {
  final bool isBadgeVisible;
  final SettingsModel settings;
  const SettingsPage(this.isBadgeVisible, this.settings, {super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          leading: BackIcon(widget.isBadgeVisible),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                      child: Text(
                    "Do you want to have the running and stopped stopwatches seperated in sorting by longest (lap) time?",
                    style: TextStyle(fontSize: 16),
                  )),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Switch(
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.white,
                    value: widget.settings.seperateRunningStopped,
                    onChanged: (value) {
                      setState(() {
                        widget.settings.seperateRunningStopped = value;
                      });
                      storeSettings(widget.settings);
                    },
                  )
                ],
              ),
            ),
            const Divider(
              indent: 16.0,
              endIndent: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Expanded(
                    child: Text(
                  "Default sort criterion:",
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(
                  width: 16.0,
                ),
                DropdownMenu<SortCriterion>(
                  initialSelection: widget.settings.defaultSortCriterion,
                  onSelected: (SortCriterion? criterion) {
                    if (criterion != null) {
                      setState(() {
                        widget.settings.defaultSortCriterion = criterion;
                      });
                      storeSettings(widget.settings);
                    }
                  },
                  dropdownMenuEntries: SortCriterion.values
                      .map<DropdownMenuEntry<SortCriterion>>(
                          (SortCriterion criterion) {
                    return DropdownMenuEntry<SortCriterion>(
                      value: criterion,
                      label: criterion.label,
                    );
                  }).toList(),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Expanded(
                    child: Text(
                  "Default sort direction:",
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(
                  width: 16.0,
                ),
                DropdownMenu<SortDirection>(
                  initialSelection: widget.settings.defaultSortDirection,
                  onSelected: (SortDirection? direction) {
                    if (direction != null) {
                      setState(() {
                        widget.settings.defaultSortDirection = direction;
                      });
                      storeSettings(widget.settings);
                    }
                  },
                  dropdownMenuEntries: SortDirection.values
                      .map<DropdownMenuEntry<SortDirection>>(
                          (SortDirection direction) {
                    return DropdownMenuEntry<SortDirection>(
                      value: direction,
                      label: direction.label,
                    );
                  }).toList(),
                )
              ]),
            ),
            const Divider(
              indent: 16.0,
              endIndent: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Expanded(
                    child: Text(
                  "Timeformat for .csv export:",
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(
                  width: 16.0,
                ),
                DropdownMenu<TimeFormat>(
                  initialSelection: widget.settings.timeFormat,
                  onSelected: (TimeFormat? timeFormat) {
                    if (timeFormat != null) {
                      setState(() {
                        widget.settings.timeFormat = timeFormat;
                      });
                      storeSettings(widget.settings);
                    }
                  },
                  dropdownMenuEntries: TimeFormat.values
                      .map<DropdownMenuEntry<TimeFormat>>(
                          (TimeFormat timeFormat) {
                    return DropdownMenuEntry<TimeFormat>(
                      value: timeFormat,
                      label: timeFormat.value,
                    );
                  }).toList(),
                )
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                const Expanded(
                    child: Text(
                  "Delimiter for .csv file:",
                  style: TextStyle(fontSize: 16),
                )),
                const SizedBox(
                  width: 16.0,
                ),
                DropdownMenu<CSVDelimiter>(
                  initialSelection: widget.settings.csvDelimiter,
                  onSelected: (CSVDelimiter? csvDelimiter) {
                    if (csvDelimiter != null) {
                      setState(() {
                        widget.settings.csvDelimiter = csvDelimiter;
                      });
                      storeSettings(widget.settings);
                    }
                  },
                  dropdownMenuEntries: CSVDelimiter.values
                      .map<DropdownMenuEntry<CSVDelimiter>>(
                          (CSVDelimiter csvDelimiter) {
                    return DropdownMenuEntry<CSVDelimiter>(
                      value: csvDelimiter,
                      label: csvDelimiter.label,
                    );
                  }).toList(),
                )
              ]),
            ),
            const Divider(
              indent: 16.0,
              endIndent: 16.0,
            ),
          ],
        ));
  }
}
