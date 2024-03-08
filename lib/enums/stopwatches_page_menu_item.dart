import 'package:flutter/material.dart';

enum StopwatchesPageMenuItem {
  rename("Rename", Icons.edit_outlined),
  deleteSetup("Delete this setup", Icons.delete_forever_outlined),
  saveAll("Save all", Icons.save_outlined),
  resetAll("Reset all", Icons.refresh),
  deleteAll("Delete all", Icons.delete_outline),
  changeOrder("Change order", Icons.sort);

  final String label;
  final IconData icon;
  const StopwatchesPageMenuItem(this.label, this.icon);
}
