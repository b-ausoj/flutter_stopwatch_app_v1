import 'package:flutter/material.dart';

enum RecordingsPageMenuItem {
  exportAll("Export all", Icons.save_alt_outlined),
  deleteAll("Delete all", Icons.delete_outlined);

  final String label;
  final IconData icon;
  const RecordingsPageMenuItem(this.label, this.icon);
}
