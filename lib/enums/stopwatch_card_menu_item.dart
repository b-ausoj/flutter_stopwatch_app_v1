import 'package:flutter/material.dart';

enum StopwatchCardMenuItem {
  rename("Rename", Icons.edit_outlined),
  save("Save", Icons.save_outlined),
  reset("Reset", Icons.refresh),
  delete("Delete", Icons.delete_outline);

  final String label;
  final IconData icon;
  const StopwatchCardMenuItem(this.label, this.icon);
}
