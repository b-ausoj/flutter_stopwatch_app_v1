import 'package:flutter/material.dart';

enum RecordingsSetMenuItem {
  exportAll("Export all", Icons.save_alt_outlined),
  deleteAll("Delete all", Icons.delete_outlined);

  final String label;
  final IconData icon;
  const RecordingsSetMenuItem(this.label, this.icon);
}
