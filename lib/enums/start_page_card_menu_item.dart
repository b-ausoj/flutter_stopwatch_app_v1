import 'package:flutter/material.dart';

enum StartPageCardMenuItem {
  rename("Rename", Icons.edit_outlined),
  delete("Delete", Icons.delete_outlined);

  final String label;
  final IconData icon;
  const StartPageCardMenuItem(this.label, this.icon);
}
